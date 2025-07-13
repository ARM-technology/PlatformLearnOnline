import 'package:flutter/material.dart';
import 'package:web_learn/BackEnd/BackendDB.dart';

void main() {
  runApp(const Self_Student());
}

class Self_Student extends StatelessWidget {
  const Self_Student({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Multi-Class Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const IDPage(),
    );
  }
}

/// الصفحة الأولى: تحتوي على صندوق نص لإدخال الـ ID وزر للانتقال
class IDPage extends StatefulWidget {
  const IDPage({super.key});

  @override
  State<IDPage> createState() => _IDPageState();
}

class _IDPageState extends State<IDPage> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController idController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter ID'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: idController,
              decoration: InputDecoration(
                hintText: 'Enter your ID',
                labelText: 'ID',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async{
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

/// الصفحة الثانية: تحتوي على صناديق نص وزر إضافة
class StudentInfoPage extends StatefulWidget {
  const StudentInfoPage({super.key});

  @override
  State<StudentInfoPage> createState() => _StudentInfoPageState();
}

class _StudentInfoPageState extends State<StudentInfoPage> {
  String? password;
  String? name;
  String? phone;
  @override
  Widget build(BuildContext context) {
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    void addStudentInfo() async{

      setState(() {
      phone = phoneController.text.trim();
       name = nameController.text.trim();
       password = passwordController.text.trim();
    });


      if (phone!.isEmpty || name!.isEmpty || password!.isEmpty) {

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all fields'),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student information added successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      phoneController.clear();
      nameController.clear();
      passwordController.clear();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Information'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: 'Enter phone number 05*********',
                labelText: 'Phone Number 05',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.phone),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Enter student name',
                labelText: 'Student Name',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Enter password',
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                prefixIcon: const Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: addStudentInfo,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:  Text('Add to '),
            ),
          ],
        ),
      ),
    );
  }
}
