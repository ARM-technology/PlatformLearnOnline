import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShowDeveloping_Masg extends StatefulWidget {

  const ShowDeveloping_Masg({super.key});

  @override
  State<ShowDeveloping_Masg> createState() => _ShowDeveloping_MasgState();
}

class _ShowDeveloping_MasgState extends State<ShowDeveloping_Masg> {
  final String tiktokUrl = "https://www.tiktok.com/@armstore2024?_t=ZS-8t82yZgr7UG&_r=1";

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "قريباً",
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _launchURL(tiktokUrl),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pinkAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.tiktok, color: Colors.white),
                  SizedBox(width: 10),
                  Text(
                    "حساب تيك توك",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ShowDeveloping_Masg(),
    debugShowCheckedModeBanner: false,
  ));
}
