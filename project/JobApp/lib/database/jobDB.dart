import 'dart:io';
import 'package:account/model/jobItem.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';

class JobDB {
  String dbName;

  JobDB({required this.dbName});

  Future<Database> openDatabase() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbLocation = join(appDir.path, dbName);

    DatabaseFactory dbFactory = databaseFactoryIo;
    Database db = await dbFactory.openDatabase(dbLocation);
    return db;
  }

  // ฟังก์ชันสำหรับการเพิ่มข้อมูลงานใหม่
  Future<int> insertDatabase(JobItem job) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('jobs');

    int jobID = await store.add(db, {
      'title': job.title,
      'company': job.company,
      'location': job.location,
      'salary': job.salary,
      'postDate': job.postDate?.toIso8601String(),
      'jobType': job.jobType,            // เพิ่ม jobType
      'requirements': job.requirements,   // เพิ่ม requirements
      'applicationDeadline': job.applicationDeadline?.toIso8601String(), // เพิ่ม applicationDeadline
    });

    await db.close();
    return jobID;
  }

  // ฟังก์ชันสำหรับการโหลดข้อมูลทั้งหมด
  Future<List<JobItem>> loadAllData() async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('jobs');

    var snapshot = await store.find(db,
        finder: Finder(sortOrders: [SortOrder('postDate', false)]));

    List<JobItem> jobs = snapshot.map((record) {
      return JobItem(
        jobID: record.key,
        title: record['title'].toString(),
        company: record['company'].toString(),
        location: record['location'].toString(),
        salary: double.parse(record['salary'].toString()),
        postDate: record['postDate'] != null ? DateTime.parse(record['postDate'].toString()) : null,
        jobType: record['jobType'].toString(), // โหลด jobType
        requirements: record['requirements'].toString(), // โหลด requirements
        applicationDeadline: record['applicationDeadline'] != null
            ? DateTime.parse(record['applicationDeadline'].toString())
            : null, // โหลด applicationDeadline
      );
    }).toList();

    await db.close();
    return jobs;
  }

  // ฟังก์ชันสำหรับการลบข้อมูล
  Future<void> deleteData(JobItem job) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('jobs');
    await store.delete(db, finder: Finder(filter: Filter.equals(Field.key, job.jobID)));
    await db.close();
  }

  // ฟังก์ชันสำหรับการอัปเดตข้อมูลงาน
  Future<void> updateData(JobItem job) async {
    var db = await openDatabase();
    var store = intMapStoreFactory.store('jobs');

    await store.update(
      db,
      {
        'title': job.title,
        'company': job.company,
        'location': job.location,
        'salary': job.salary,
        'postDate': job.postDate?.toIso8601String(),
        'jobType': job.jobType,             // เพิ่ม jobType
        'requirements': job.requirements,    // เพิ่ม requirements
        'applicationDeadline': job.applicationDeadline?.toIso8601String(), // เพิ่ม applicationDeadline
      },
      finder: Finder(filter: Filter.equals(Field.key, job.jobID)),
    );

    await db.close();
  }
}
