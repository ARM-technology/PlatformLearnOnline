import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // استيراد حزمة url_launcher
import 'HomeProject/HomeWebsite.dart';

Future<void> main() async {
  print("BASSAM");
  runApp(const EramEduApp());
}

void launchWhatsApp(BuildContext context) async {
  const phoneNumber = '966532131074'; // ضع رقم الواتساب هنا مع رمز البلد بدون علامة + أو أي رموز أخرى (مثال: 9665xxxxxxxx)
  const url = 'https://wa.me/$phoneNumber';
  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('لا يمكن فتح WhatsApp.')),
    );
  }
}


