import 'package:flutter/material.dart';   
import 'package:provider/provider.dart';
import 'model/jobItem.dart';
import 'provider/jobProvider.dart';
import 'jobFormScreen.dart';  // เพิ่มการนำเข้า JobFormScreen
import 'jobEditScreen.dart';

void main() {
  runApp(const JobApp());
}

class JobApp extends StatelessWidget {
  const JobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return JobProvider();
        })
      ],
      child: MaterialApp(
        title: 'Job App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 47, 47, 47)),
          useMaterial3: true,
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 16),
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.deepPurple,
            titleTextStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white, backgroundColor: Colors.deepPurpleAccent,
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        home: const MyHomePage(title: 'ประกาศรับสมัครงาน'), // ชื่อที่แสดงใน AppBar
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isButtonExpanded = false;

  @override
  void initState() {
    super.initState();
    Provider.of<JobProvider>(context, listen: false).initData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Consumer<JobProvider>(builder: (context, provider, child) {
        int itemCount = provider.jobs.length;
        if (itemCount == 0) {
          return const Center(
            child: Text(
              'ไม่มีงานที่บันทึก',
              style: TextStyle(fontSize: 24),
            ),
          );
        } else {
          return ListView.builder(
            itemCount: itemCount,
            itemBuilder: (context, index) {
              JobItem data = provider.jobs[index];
              return AnimatedOpacity(
                opacity: 1.0,
                duration: const Duration(milliseconds: 500),
                child: Dismissible(
                  key: Key(data.jobID.toString()),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    provider.deleteJob(data);
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    elevation: 5,
                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: ListTile(
                      title: Text(
                        data.title,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'เงินเดือน: ${data.salary} บาท',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            'สถานที่: ${data.location}',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            'ประเภทงาน: ${data.jobType}',
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.deepPurple),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) {
                                return JobEditScreen(job: data);
                              }));
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              provider.deleteJob(data); // ทำการลบงานเมื่อกดปุ่มลบ
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      }),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight, // ตั้งปุ่มให้ชิดมุมขวา
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const JobFormScreen(); // นำทางไปยังหน้าเพิ่มงาน
              }));
            },
            backgroundColor: Colors.deepPurpleAccent,
            child: const Icon(
              Icons.add,
              size: 30,
            ),
          ),
        ),
      ),
    );
  }
}
