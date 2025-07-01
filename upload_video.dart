import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:web_learn/API_serves/API_Firebase.dart';
import 'package:web_learn/Folder_Teachers/self_addition.dart';

import '../show_developing_masg.dart';
import 'addStudent.dart';

void main() {
  runApp(const Uplod());
}

class Uplod extends StatefulWidget {
  const Uplod({super.key});

  @override
  State<Uplod> createState() => _UplodState();
}

class _UplodState extends State<Uplod> {
  String? nameFile;
  String? name_CRN;
  String? URLData;
  final TextEditingController _name_CRN = TextEditingController();
  final TextEditingController _name_File = TextEditingController();
  String selectedResourceType = 'raw'; // نوع المورد
  bool isLoading = false;
  String statusMessage = '';

  // رفع الملف إلى Firebase Storage
  Future<void> uploadFileToFirebase(String id, String crn) async {
    try {
      // اختيار الملف
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
      if (result != null) {
        setState(() {
          isLoading = true;
          statusMessage = 'Uploading file...';
        });

        Uint8List fileBytes = result.files.single.bytes!;
        String fileName = result.files.single.name;

        // تحديد مسار التخزين
        String folderPath =
            'class/$id/$crn/${selectedResourceType == "raw" ? "docment" : "video"}/${_name_File.text}/$fileName';
        Reference ref = FirebaseStorage.instance.ref().child(folderPath);

        // رفع الملف إلى Firebase Storage
        UploadTask uploadTask = ref.putData(fileBytes);
        TaskSnapshot snapshot = await uploadTask.whenComplete(() => {});
        String downloadUrl = await snapshot.ref.getDownloadURL();

        setState(() {
          isLoading = false;
          URLData = downloadUrl;
          statusMessage = 'File uploaded successfully!';
        });

        print('File uploaded successfully: $downloadUrl');
      } else {
        setState(() {
          statusMessage = 'No file selected.';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        statusMessage = 'Error occurred: $e';
      });

      print('Error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Upload Files to Storge')),

        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text(
                  'لوحة التحكم',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person_add),
                title: const Text('إضافة الطالب و المقررات'),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const addStudent1(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.video_collection),
                title: const Text('تنزيل فيديو'),
                onTap: () {},
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
            ],
          ),
        ),

        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _name_CRN,
                decoration: InputDecoration(
                  hintText: 'Enter CRN...',
                  labelText: 'CRN',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.class_),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _name_File,
                decoration: InputDecoration(
                  hintText: 'Enter file name...',
                  labelText: 'File Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  prefixIcon: const Icon(Icons.file_present),
                ),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: selectedResourceType,
                items: const [
                  DropdownMenuItem(value: 'raw', child: Text('Document')),
                  DropdownMenuItem(value: 'video', child: Text('Video')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedResourceType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: isLoading
                    ? null // تعطيل الزر أثناء التحميل
                    : () async {
                        setState(() {
                          isLoading = true; // عرض حالة التحميل
                          statusMessage = 'Uploading file...';
                        });

                        try {
                          String crn = _name_CRN.text;
                          String fileName = _name_File.text;

                          // التحقق من إدخال القيم الأساسية
                          if (crn.isEmpty || fileName.isEmpty) {
                            setState(() {
                              isLoading = false;
                              statusMessage = 'Please enter CRN and file name.';
                            });
                            return;
                          }

                          // رفع الملف إلى Firebase Storage
                          await uploadFileToFirebase(namePage, crn);

                          // تحقق إذا تم تحميل الرابط بشكل صحيح
                          if (URLData != null) {
                            if (selectedResourceType == 'video') {
                              // حفظ رابط الفيديو في Firestore
                              await firebase_conect().url_Video(
                                namePage,
                                crn,
                                URLData!,
                                fileName,
                              );
                              print('Video saved in Storge!');
                              setState(() {
                                statusMessage =
                                    'Video saved successfully in Storge!';
                              });
                            } else if (selectedResourceType == 'raw') {
                              // حفظ رابط المستند في Firestore
                              await firebase_conect().url_Docment(
                                namePage,
                                crn,
                                URLData!,
                                fileName,
                              );
                              print('Document saved in Storge!');
                              setState(() {
                                statusMessage =
                                    'Document saved successfully in Storge!';
                              });
                            }
                          } else {
                            // إذا لم يتم تحميل الرابط
                            setState(() {
                              statusMessage =
                                  'Failed to upload file to Storage.';
                            });
                          }
                        } catch (e) {
                          // معالجة الأخطاء أثناء التحميل
                          setState(() {
                            statusMessage = 'Error occurred: $e';
                          });
                          print('Error: $e');
                        } finally {
                          // إنهاء حالة التحميل
                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Upload File'),
              ),
              const SizedBox(height: 16),
              if (statusMessage.isNotEmpty)
                Text(
                  statusMessage,
                  style: TextStyle(
                    color: statusMessage.contains('successfully')
                        ? Colors.green
                        : Colors.red,
                  ),
                ),
            ],
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
      ),
    );
  }
}
