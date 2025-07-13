import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:web_learn/Authentication/Auth_LogIn.dart';
import 'package:web_learn/BackEnd/BackendDB.dart';
import 'package:web_learn/DB_in_client/LocalStorage.dart';
import 'package:web_learn/DB_in_client/StudentManagerStorge.dart';
import 'package:web_learn/Folder_Teachers/TEST_Teachers/Home.dart';
import 'package:web_learn/Folder_Teachers/Teacher.dart';
import 'Adman.dart';
import 'self_student.dart';
import 'student.dart';
import 'package:video_player_platform_interface/video_player_platform_interface.dart';
import 'package:video_player_web/video_player_web.dart';
void main() {
  VideoPlayerPlatform.instance = VideoPlayerPlugin();
  runApp(const LogIn());
}

class LogIn extends StatelessWidget {
  const LogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  AuthLogin _authLogin =AuthLogin();
  BackendDB _backendDB =BackendDB();
  late double screenWidth;
  late double screenHeight;
  final TextEditingController userName = TextEditingController();
  final TextEditingController pass = TextEditingController();
  String? errorMessage;

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.bounceOut),
    );

    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF667eea),
              Color(0xFF764ba2),
              Color(0xFF6B73FF),
              Color(0xFF000428),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // خلفية متحركة مع دوائر
            ...List.generate(6, (index) {
              return AnimatedBuilder(
                animation: _fadeController,
                builder: (context, child) {
                  return Positioned(
                    top: (index * 150.0) - 100 + (50 * index),
                    left: (index % 2 == 0) ? -50 : screenWidth - 100,
                    child: Transform.rotate(
                      angle: _fadeController.value * 2 * 3.14159 * (index + 1),
                      child: Container(
                        width: 100 + (index * 20),
                        height: 100 + (index * 20),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),

            // المحتوى الرئيسي
            Center(
              child: SingleChildScrollView(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: screenWidth * 0.9,
                        margin: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.9),
                              Colors.white.withOpacity(0.8),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 8,
                              blurRadius: 25,
                              offset: const Offset(0, 15),
                            ),
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.2),
                              spreadRadius: 5,
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Stack(
                            children: [
                              // خلفية الصورة مع تأثير ضبابي
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: const AssetImage('assets/images/ARM_icon.png'),
                                      fit: BoxFit.cover,
                                      colorFilter: ColorFilter.mode(
                                        Colors.blue.withOpacity(0.1),
                                        BlendMode.overlay,
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.white.withOpacity(0.95),
                                          Colors.white.withOpacity(0.85),
                                          Colors.white.withOpacity(0.95),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // المحتوى
                              Padding(
                                padding: const EdgeInsets.all(30),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // شعار وعنوان
                                    Container(
                                      width: 120,
                                      height: 120,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [
                                            Color(0xFF667eea),
                                            Color(0xFF764ba2),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.blue.withOpacity(0.4),
                                            spreadRadius: 5,
                                            blurRadius: 20,
                                          ),
                                        ],
                                      ),
                                      child: ClipOval(
                                        child: Image.asset(
                                          'assets/images/ARM_icon.png',
                                          fit: BoxFit.cover,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.school,
                                              size: 60,
                                              color: Colors.white,
                                            );
                                          },
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 25),

                                    ShaderMask(
                                      shaderCallback: (bounds) => const LinearGradient(
                                        colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                      ).createShader(bounds),
                                      child: Text(
                                        "مرحباً بك",
                                        style: TextStyle(
                                          fontSize: screenWidth * 0.08,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontFamily: 'Arial',
                                        ),
                                      ),
                                    ),

                                    Text(
                                      "منصة التعلم الذكية",
                                      style: TextStyle(
                                        fontSize: screenWidth * 0.04,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),

                                    const SizedBox(height: 35),

                                    // حقل اسم المستخدم
                                    _buildStyledTextField(
                                      controller: userName,
                                      labelText: "اسم المستخدم",
                                      icon: Icons.person_outline,
                                      isPassword: false,
                                    ),

                                    const SizedBox(height: 20),

                                    // حقل كلمة المرور
                                    _buildStyledTextField(
                                      controller: pass,
                                      labelText: "كلمة المرور",
                                      icon: Icons.lock_outline,
                                      isPassword: true,
                                    ),

                                    const SizedBox(height: 15),

                                    // رسالة الخطأ
                                    if (errorMessage != null)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                                        margin: const EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(15),
                                          border: Border.all(color: Colors.red.withOpacity(0.3)),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.error_outline, color: Colors.red, size: 20),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                errorMessage!,
                                                style: TextStyle(
                                                  color: Colors.red[700],
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    // رابط التسجيل
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) => const Self_Student()),
                                        );
                                      },
                                      child: const Text(
                                        'ليس لديك حساب؟ سجل من هنا!',
                                        style: TextStyle(
                                          color: Color(0xFF667eea),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),

                                    const SizedBox(height: 25),



                                    const SizedBox(height: 15),

                                    _buildLoginButton(
                                      text: "تسجيل الدخول",
                                      icon: Icons.person,
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF11998e), Color(0xFF38ef7d)],
                                      ),
                                      onPressed: () async {
                                        await _handleLogin();
                                      },
                                    ),

                                    const SizedBox(height: 15),

                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.8),
              Colors.black.withOpacity(0.6),
            ],
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.copyright, color: Colors.white70, size: 16),
            SizedBox(width: 5),
            Text(
              "جميع الحقوق محفوظة © ARM TIC",
              style: TextStyle(
                fontSize: 14,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    required bool isPassword,
  }) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.9),
            Colors.white.withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFF667eea), Color(0xFF764ba2)],
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        ),
      ),
    );
  }

  Widget _buildLoginButton({
    required String text,
    required IconData icon,
    required Gradient gradient,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: gradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(25),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    setState(() {
      namePage = userName.text;
      errorMessage = null;
    });

    bool loginSuccess = false;




        String prefix = userName.text.substring(0, 2);
        switch(prefix){
          case "T#":
            print("T# True ");
        if ( await _authLogin.auth_login_T(userName.text,pass.text)) {
          await WebLocalStorage.saveCredentials(
            id: userName.text,
            pass:pass.text,
            job: "1",
          );
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SidebarXExampleApp()
              ),);
        }

          case "S#":
          // الخطوة 1: التحقق من صحة كلمة المرور
            bool authSuccess = await _authLogin.auth_login_S(userName.text, pass.text);
            if (authSuccess) {
              // الخطوة 2: جلب بيانات الطالب الكاملة
              final studentId = userName.text;
              final response = await _backendDB.queryItems( // <-- جلب من السيرفر
                tableName: _backendDB.tableName(),
                partitionKey: studentId,
                limit: 1,
              );

              if (response['statusCode'] == 200 && response['body']['data'] != null && (response['body']['data'] as List).isNotEmpty) {
                final studentData = response['body']['data'][0];

                // الخطوة 3: تخزين كل البيانات في StudentDataManager
                StudentDataManager.studentId = studentId;
                StudentDataManager.teacherId = studentData['SK']; // <-- تخزين Teacher ID
                StudentDataManager.courses = [];
                if (studentData.containsKey('Course_Json')) {
                  final Map<String, dynamic> courseJson = jsonDecode(studentData['Course_Json']);
                  if (courseJson.containsKey('Course') && courseJson['Course'] is Map) {
                    StudentDataManager.courses.addAll((courseJson['Course'] as Map).keys.cast<String>()); // <-- تخزين المقررات
                  }
                }

                // الخطوة 4: تحميل بيانات التقدم من LocalStorage
                await StudentDataManager.loadDataFromStorage(); // <-- تحميل التقدم

                // الخطوة 5: الانتقال إلى الواجهة الرئيسية للطالب بالبيانات الكاملة
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomeStudent()));
              } else {
                throw Exception("تم التحقق من الحساب، ولكن فشل جلب بيانات الطالب.");
              }
            } else {
              throw Exception("خطأ في كلمة السر أو اسم المستخدم للطالب");
            }
            break;
          default:
break;
        }



    if (!loginSuccess) {
      setState(() {
        errorMessage = "خطأ في كلمة السر أو اسم المستخدم";
      });
    }
  }
}