import 'dart:math';
import 'package:flutter/material.dart';
import 'package:web_learn/CRN_Student_Page.dart';
import 'package:web_learn/DB_in_client/StudentManagerStorge.dart';

// استدعاء الملفات الضرورية

class HomeStudent extends StatefulWidget {
  const HomeStudent({Key? key}) : super(key: key);

  @override
  State<HomeStudent> createState() => _HomeStudentState();
}

class _HomeStudentState extends State<HomeStudent> {
  late String _greeting;

  @override
  void initState() {
    super.initState();
    _greeting = _getGreeting();
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'صباح الخير';
    if (hour < 18) return 'مساء الخير';
    return 'مساء الخير';
  }

  // هذه الدالة ستكون مفيدة إذا أردت تحديث الواجهة من مكان آخر
  void _updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A202C),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
          children: [
            _buildHeader(),
            const SizedBox(height: 30),
            _buildQuickStats(),
            const SizedBox(height: 30),
            if (StudentDataManager.courses.isNotEmpty) ...[
              _buildSectionHeader('اكمل رحلتك'),
              _buildContinueLearningCard(),
              const SizedBox(height: 30),
            ],
            _buildSectionHeader('جميع المقررات'),
            _buildCoursesGrid(context), // تمرير الـ context هنا
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greeting,
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18),
        ),
        const Text(
          'مستعد ليوم دراسي جديد؟',
          style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem(Icons.library_books, '${StudentDataManager.courses.length}', 'المقررات'),
        _buildStatItem(Icons.trending_up, '${(StudentDataManager.overallProgress * 100).toInt()}%', 'التقدم الإجمالي'),
        _buildStatItem(Icons.local_fire_department_outlined, '${StudentDataManager.consecutiveDays}', 'أيام متتالية'),
      ],
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF2D3748),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.tealAccent, size: 28),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildContinueLearningCard() {
    // التحقق من وجود مقررات لتجنب الأخطاء
    if (StudentDataManager.courses.isEmpty) {
      return const SizedBox.shrink(); // لا تعرض شيئاً إذا لا توجد مقررات
    }

    final firstCourse = StudentDataManager.courses.first;
    final progress = StudentDataManager.courseProgress[firstCourse] ?? 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)],
          begin: Alignment.topLeft, end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(firstCourse, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.white24,
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                    minHeight: 8,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Text('${(progress * 100).toInt()}% مكتمل', style: const TextStyle(color: Colors.white70, fontSize: 14)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoursesGrid(BuildContext context) {
    final courses = StudentDataManager.courses;
    final List<Gradient> gradients = [
      const LinearGradient(colors: [Color(0xFF00b09b), Color(0xFF96c93d)]),
      const LinearGradient(colors: [Color(0xFFff9966), Color(0xFFff5e62)]),
      const LinearGradient(colors: [Color(0xFF2193b0), Color(0xFF6dd5ed)]),
      const LinearGradient(colors: [Color(0xFF3a6186), Color(0xFF89253e)]),
    ];

    if (courses.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(color: const Color(0xFF2D3748), borderRadius: BorderRadius.circular(15)),
        child: const Text('لا توجد مقررات مسجلة حالياً.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 16)),
      );
    }

    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 1.0,
      ),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final courseName = courses[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: gradients[index % gradients.length],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              // --- (هذا هو التعديل المطلوب) ---
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CourseContentPage(courseName: courseName),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _getIconForCourse(courseName),
                    Text(
                      courseName,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
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

  Icon _getIconForCourse(String courseName) {
    String lowerCaseName = courseName.toLowerCase();
    IconData iconData = Icons.school_outlined;

    if (lowerCaseName.contains('flutter')) iconData = Icons.phone_android;
    if (lowerCaseName.contains('math')) iconData = Icons.calculate_outlined;
    if (lowerCaseName.contains('web')) iconData = Icons.web_asset;
    if (lowerCaseName.contains('data')) iconData = Icons.bar_chart_rounded;

    return Icon(iconData, color: Colors.white.withOpacity(0.8), size: 32);
  }
}