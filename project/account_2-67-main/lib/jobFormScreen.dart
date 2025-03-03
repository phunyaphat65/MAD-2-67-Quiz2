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
                validator: (value) {
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
              TextFormField(
                decoration: const InputDecoration(labelText: 'สถานที่ทำงาน'),
                controller: locationController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาป้อนสถานที่ทำงาน";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ประเภทของงาน'),
                controller: jobTypeController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาป้อนประเภทของงาน";
                  }
                  return null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'ข้อกำหนดของงาน'),
                controller: requirementsController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "กรุณาป้อนข้อกำหนดของงาน";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    var provider = Provider.of<JobProvider>(context, listen: false);

                    JobItem newJob = JobItem(
                      title: titleController.text,
                      salary: double.tryParse(salaryController.text) ?? 0.0,
                      location: locationController.text, 
                      jobID: null, // ตรวจสอบว่ารองรับ null หรือไม่
                      company: 'บริษัทตัวอย่าง', // อาจต้องให้ป้อนข้อมูลนี้ในฟอร์ม
                      jobType: jobTypeController.text, // รับค่าจาก jobTypeController
                      requirements: requirementsController.text, // รับค่าจาก requirementsController
                    );

                    provider.addJob(newJob);
                    Navigator.pop(context);
                  }
                },
                child: const Text('เพิ่มงาน'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
