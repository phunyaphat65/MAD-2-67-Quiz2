import 'package:flutter/foundation.dart';
import '../model/jobItem.dart';
import '../database/jobDB.dart';

class JobProvider with ChangeNotifier {
  List<JobItem> jobs = [];

  // ฟังก์ชันสำหรับการดึงข้อมูลงานทั้งหมด
  List<JobItem> getJobList() {
    return jobs;
  }

  // ฟังก์ชันสำหรับการโหลดข้อมูลงานจากฐานข้อมูล
  Future<void> initData() async {
    try {
      var db = JobDB(dbName: 'jobs.db');
      jobs = await db.loadAllData();
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading jobs: $e');
    }
  }

  // ฟังก์ชันสำหรับการเพิ่มงานใหม่
  Future<void> addJob(JobItem job) async {
    try {
      var db = JobDB(dbName: 'jobs.db');
      await db.insertDatabase(job);
      await _refreshJobList(); // โหลดข้อมูลใหม่หลังการเพิ่ม
    } catch (e) {
      debugPrint('❌ Error adding job: $e');
    }
  }

  // ฟังก์ชันสำหรับการลบงาน
  Future<void> deleteJob(JobItem job) async {
    try {
      var db = JobDB(dbName: 'jobs.db');
      await db.deleteData(job);
      await _refreshJobList(); // โหลดข้อมูลใหม่หลังการลบ
    } catch (e) {
      debugPrint('❌ Error deleting job: $e');
    }
  }

  // ฟังก์ชันสำหรับการอัปเดตงาน
  Future<void> updateJob(JobItem job) async {
    try {
      var db = JobDB(dbName: 'jobs.db');
      await db.updateData(job);
      await _refreshJobList(); // โหลดข้อมูลใหม่หลังการอัปเดต
    } catch (e) {
      debugPrint('❌ Error updating job: $e');
    }
  }

  // ฟังก์ชันช่วยสำหรับการรีเฟรชข้อมูลใหม่หลังจากการดำเนินการ
  Future<void> _refreshJobList() async {
    await initData(); // เรียกใช้ฟังก์ชัน initData เพื่อโหลดข้อมูลล่าสุด
  }
}
