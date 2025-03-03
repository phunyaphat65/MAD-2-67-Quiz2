import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/jobItem.dart';
import '../provider/jobProvider.dart';

class JobEditScreen extends StatefulWidget {
  final JobItem job;

  const JobEditScreen({super.key, required this.job});

  @override
  State<JobEditScreen> createState() => _JobEditScreenState();
}

class _JobEditScreenState extends State<JobEditScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final salaryController = TextEditingController();
  final locationController = TextEditingController();
  final jobTypeController = TextEditingController();
  final requirementsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.job.title;
    salaryController.text = widget.job.salary.toString();
    locationController.text = widget.job.location;
    jobTypeController.text = widget.job.jobType;
    requirementsController.text = widget.job.requirements;
  }

  @override
  void dispose() {
    titleController.dispose();
    salaryController.dispose();
    locationController.dispose();
    jobTypeController.dispose();
    requirementsController.dispose();
    super.dispose();
  }

  void _saveJob() {
    if (formKey.currentState!.validate()) {
      var provider = Provider.of<JobProvider>(context, listen: false);

      JobItem updatedJob = JobItem(
        jobID: widget.job.jobID,
        title: titleController.text,
        company: widget.job.company,
        location: locationController.text,
        salary: double.parse(salaryController.text),
        postDate: widget.job.postDate,
        jobType: jobTypeController.text,
        requirements: requirementsController.text,
        applicationDeadline: widget.job.applicationDeadline,
      );

      provider.updateJob(updatedJob);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('แก้ไขงาน'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title field
                _buildTextFormField(
                  controller: titleController,
                  labelText: 'ชื่อตำแหน่งงาน',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณาป้อนชื่อตำแหน่งงาน";
                    }
                    return null;
                  },
                ),
                
                // Salary field
                _buildTextFormField(
                  controller: salaryController,
                  labelText: 'เงินเดือน',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณาป้อนเงินเดือน";
                    }
                    try {
                      double salary = double.parse(value);
                      if (salary <= 0) {
                        return "กรุณาป้อนเงินเดือนที่มากกว่า 0";
                      }
                    } catch (e) {
                      return "กรุณาป้อนเป็นตัวเลขเท่านั้น";
                    }
                    return null;
                  },
                ),

                // Location field
                _buildTextFormField(
                  controller: locationController,
                  labelText: 'สถานที่ทำงาน',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณาป้อนสถานที่ทำงาน";
                    }
                    return null;
                  },
                ),

                // Job type field
                _buildTextFormField(
                  controller: jobTypeController,
                  labelText: 'ประเภทของงาน',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณาป้อนประเภทของงาน";
                    }
                    return null;
                  },
                ),

                // Requirements field
                _buildTextFormField(
                  controller: requirementsController,
                  labelText: 'ข้อกำหนดของงาน',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "กรุณาป้อนข้อกำหนดของงาน";
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Save button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveJob,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('บันทึกการแก้ไข'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Custom TextFormField to reduce repetition
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        validator: validator,
      ),
    );
  }
}
