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
    jobTypeController.text = widget.job.jobType; // กำหนดค่าเริ่มต้นของ jobType
    requirementsController.text = widget.job.requirements; // กำหนดค่าเริ่มต้นของ requirements
  }

  @override
  void dispose() {
    titleController.dispose();
    salaryController.dispose();
    locationController.dispose();
    jobTypeController.dispose(); // ต้องทำการ dispose ด้วย
    requirementsController.dispose(); // ต้องทำการ dispose ด้วย
    super.dispose();
  }

  void _saveJob() {
    if (formKey.currentState!.validate()) {
      var provider = Provider.of<JobProvider>(context, listen: false);

      JobItem updatedJob = JobItem(
        jobID: widget.job.jobID,
        title: titleController.text,
        company: widget.job.company, // ใช้ค่าเดิมของ company
        location: locationController.text,
        salary: double.parse(salaryController.text),
        postDate: widget.job.postDate, // ใช้ค่าเดิมของ postDate
        jobType: jobTypeController.text, // รับค่าจาก jobTypeController
        requirements: requirementsController.text, // รับค่าจาก requirementsController
        applicationDeadline: widget.job.applicationDeadline, // ใช้ค่าเดิมของ applicationDeadline
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
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'ชื่อตำแหน่งงาน'),
                autofocus: true,
                controller: titleController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาป้อนชื่อตำแหน่งงาน";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'เงินเดือน'),
                keyboardType: TextInputType.number,
                controller: salaryController,
                validator: (String? value) {
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'สถานที่ทำงาน'),
                controller: locationController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาป้อนสถานที่ทำงาน";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ประเภทของงาน'),
                controller: jobTypeController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาป้อนประเภทของงาน";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ข้อกำหนดของงาน'),
                controller: requirementsController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาป้อนข้อกำหนดของงาน";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity, // ให้ปุ่มเต็มหน้าจอ
                child: ElevatedButton(
                  onPressed: _saveJob,
                  child: const Text('บันทึกการแก้ไข'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
