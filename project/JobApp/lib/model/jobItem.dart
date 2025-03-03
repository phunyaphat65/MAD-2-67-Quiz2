class JobItem {
  int? jobID;          // รหัสงาน
  String title;        // ชื่อตำแหน่งงาน
  String company;      // ชื่อบริษัท
  String location;     // สถานที่ทำงาน
  double salary;       // เงินเดือน
  DateTime? postDate;  // วันที่ประกาศงาน
  String jobType;      // ประเภทของงาน
  String requirements; // ข้อกำหนดของงาน
  DateTime? applicationDeadline; // วันหมดอายุการสมัครงาน

  JobItem({
    this.jobID,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    this.postDate,
    required this.jobType,         // เพิ่ม jobType
    required this.requirements,    // เพิ่ม requirements
    this.applicationDeadline,
  });
}
