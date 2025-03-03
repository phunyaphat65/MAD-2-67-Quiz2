import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'model/jobItem.dart';
import 'provider/jobProvider.dart';
import 'jobFormScreen.dart';
import 'jobEditScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) {
          return JobProvider();
        })
      ],
      child: MaterialApp(
        title: 'Job Management',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
        home: const MyHomePage(title: 'ประกาศรับสมัครงาน'),
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const JobFormScreen();
              }));
            },
          ),
        ],
      ),
      body: Consumer<JobProvider>(
        builder: (context, provider, child) {
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
                return Dismissible(
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
                      subtitle: Text(
                        'เงินเดือน: ${data.salary} บาท\nสถานที่: ${data.location}',
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
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
                );
              },
            );
          }
        },
      ),
    );
  }
}
