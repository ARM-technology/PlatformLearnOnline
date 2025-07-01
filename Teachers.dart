import 'package:flutter/material.dart';
import 'package:web_learn/API_serves/API_Firebase.dart';
import '../show_developing_masg.dart';
import 'addStudent.dart'; // تأكد من إضافة هذا الاستيراد لربط الكلاس الثاني
import 'self_addition.dart';
import 'upload_video.dart';

void main() {
  runApp(const teacher1());
}

class teacher1 extends StatefulWidget {
  const teacher1({super.key});

  @override
  State<teacher1> createState() => _MyAppState();
}

class _MyAppState extends State<teacher1> {
  bool isDarkMode = false; // الحالة العامة لوضع الدارك مود

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // الثيم المضيء
      darkTheme: ThemeData.dark(), // الثيم الداكن
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light, // تبديل الثيم
      home: TeacherDashboard(
        isDarkMode: isDarkMode,
        toggleDarkMode: () {
          setState(() {
            isDarkMode = !isDarkMode;
          });
        },
      ),
    );
  }
}

class TeacherDashboard extends StatelessWidget {
  final bool isDarkMode; // حالة الدارك مود
  final VoidCallback toggleDarkMode; // وظيفة تبديل الوضع

  const TeacherDashboard({
    super.key,
    required this.isDarkMode,
    required this.toggleDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode
          ? Colors.black87
          : Colors.grey[200], // تغيير الخلفية حسب الوضع
      appBar: AppBar(title: Text('ID:$namePage لوحة تحكم المعلمين')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.grey[800]!
                    : Colors.blue, // تغيير اللون حسب الوضع
              ),
              child: const Text(
                'لوحة التحكم',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('إضافة الطالب و المقررات'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const addStudent1()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.video_collection),
              title: const Text('تنزيل فيديو'),
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => const Uplod()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.table_chart),
              title: const Text('عرض بيانات الطلاب'),
              onTap: () {
                // تنفيذ منطق عرض بيانات الطلاب إذا كان مطلوبًا
              },
            ),

            ListTile(
              leading: const Icon(Icons.note_alt),
              title: const Text('الإضافة الذاتيه'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Self_add()),
                );
                // تنفيذ منطق عرض بيانات الطلاب إذا كان مطلوبًا
              },
            ),

            ListTile(
              leading: const Icon(Icons.article_rounded),
              title: const Text('نشرة ARM'),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ShowDeveloping_Masg(),
                  ),
                );
                // تنفيذ منطق عرض بيانات الطلاب إذا كان مطلوبًا
              },
            ),

            ListTile(
              leading: const Icon(Icons.dark_mode),
              title: const Text('وضع الدارك مود'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  toggleDarkMode(); // تبديل الوضع عند التغيير
                },
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Text(
          ' \n Mr $namePage\n  مرحباً بك في لوحة تحكم المعلمين',
          style: TextStyle(
            fontSize: 20,
            color: isDarkMode ? Colors.white : Colors.black,
          ), // تغيير اللون حسب الوضع
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "All rights reserved © ARM TIC",
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
