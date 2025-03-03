import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/jobItem.dart';
import '../provider/jobProvider.dart';

class JobFormScreen extends StatefulWidget {
  const JobFormScreen({super.key});

  @override
  State<JobFormScreen> createState() => _JobFormScreenState();
}

class _JobFormScreenState extends State<JobFormScreen> {
  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final salaryController = TextEditingController();
  final locationController = TextEditingController();
  final jobTypeController = TextEditingController();
  final requirementsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('เพิ่มงานใหม่'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
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

              // Add job button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      var provider = Provider.of<JobProvider>(context, listen: false);

                      JobItem newJob = JobItem(
                        title: titleController.text,
                        salary: double.tryParse(salaryController.text) ?? 0.0,
                        location: locationController.text, 
                        jobID: null, 
                        company: 'บริษัทตัวอย่าง', 
                        jobType: jobTypeController.text, 
                        requirements: requirementsController.text, 
                      );

                      provider.addJob(newJob);
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: Theme.of(context).colorScheme.primary, 
                    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text('เพิ่มงาน'),
                ),
              ),
            ],
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
