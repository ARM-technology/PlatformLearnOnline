import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:web_learn/All_Widget/Widget_1.dart';
import 'dart:ui';

import 'package:web_learn/main.dart';

void main() {
  runApp(const EramEduApp());
}

class EramEduApp extends StatelessWidget {
  const EramEduApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'إرم لقطاع التعليم',
      home:  HomePage(),
    );
  }
}

// Custom Glass Container for Web compatibility
class CustomGlassContainer extends StatelessWidget {

  final Widget child;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final double opacity;
  final Color borderColor;
  final double borderWidth;
  const CustomGlassContainer({
    super.key,
     required this.child,
    this.width,
    this.height,
    this.borderRadius,
    this.padding,
    this.opacity = 0.1,
    this.borderColor = Colors.white,
    this.borderWidth = 1,
  });



  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(opacity),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(
          color: borderColor.withOpacity(0.2),
          width: borderWidth,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: child,
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // List of carousel image asset paths with titles
  final List<Map<String, String>> carouselItems = const [
    {
      'image': 'assets/images/ARM_icon.png',
      'title': 'منصة إرم التعليمية',
      'subtitle': 'حلول تعليمية متطورة'
    },
    {
      'image': 'assets/images/LearnOnline.jpg',
      'title': 'التعلم الإلكتروني',
      'subtitle': 'تعلم من أي مكان وفي أي وقت'
    },
    {
      'image': 'assets/images/Study.jpg',
      'title': 'الدراسة التفاعلية',
      'subtitle': 'بيئة تعليمية محفزة'
    },
    {
      'image': 'assets/images/withAI.jpg',
      'title': 'التعلم بالذكاء الاصطناعي',
      'subtitle': 'مساعد ذكي متاح 24/7'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,// هذا مسؤول عن شفافية البار
      appBar: Widget_1().appbar_1(context),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.indigo.shade100,
              Colors.purple.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            vertical: 40,
            horizontal: MediaQuery.of(context).size.width > 800 ? 80 : 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo and Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade600,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.withOpacity(0.3),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.school, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Flexible(
                    child: Text(
                      'إرم لقطاع التعليم',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.indigo.shade800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ).animate().fadeIn(duration: 800.ms),
              const SizedBox(height: 32),

              // Enhanced Carousel with real images
              CarouselSlider(
                items: carouselItems.map((item) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 3,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          // Background image
                          Image.asset(
                            item['image']!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              // Fallback if image doesn't exist
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.blue.shade400, Colors.purple.shade400],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.image,
                                  size: 80,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          // Gradient overlay for better text readability
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.7),
                                ],
                              ),
                            ),
                          ),
                          // Text overlay
                          Positioned(
                            bottom: 20,
                            left: 20,
                            right: 20,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 3,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  item['subtitle']!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(1, 1),
                                        blurRadius: 3,
                                        color: Colors.black54,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ).animate().slideY(begin: 0.2, end: 0, duration: 600.ms);
                }).toList(),
                options: CarouselOptions(
                  height: 350,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.3,
                  viewportFraction: MediaQuery.of(context).size.width > 800 ? 0.8 : 0.9,
                  scrollDirection: Axis.horizontal,
                ),
              ),
              const SizedBox(height: 40),

              // Description Section
              CustomGlassContainer(
                opacity: 0.15,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إرم لقطاع التعليم منصة ويب متكاملة للمعلمين الخصوصيين تتيح لك:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.indigo.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...[
                      'الاشتراك الشهري برسوم مبسطة ومخفضة',
                      'إضافة وإدارة طلابك بسهولة',
                      'رفع وتنظيم المحتوى التعليمي (مستندات وفيديو)',
                      'الاستفادة من نموذج ذكاء اصطناعي كمساعد تعليمي على مدار الساعة',
                      'نظام تحقق ثنائي يمنع مشاركة الحساب بين أكثر من طالب',
                    ].map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.indigo.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ).animate().fadeIn(duration: 800.ms),
              const SizedBox(height: 40),

              // Why Choose Us
              const SectionTitle('لماذا تختار إرم؟'),
              const SizedBox(height: 16),
              CustomGlassContainer(
                opacity: 0.12,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[
                      'اشتراك شهري مبسط ومخفض يناسب ميزانيتك',
                      'إدارة طلاب متقدمة (إضافة، تعديل، حذف)',
                      'رفع وتنظيم المحتوى: مستندات PDF/DOCX وفيديوهات MP4',
                      'شات بوت ذكي مبني على الذكاء الاصطناعي لمساعدة الطلاب فورياً',
                      'نظام تحقق ثنائي يمنع مشاركة الحساب لأكثر من طالب',
                      'مساحة تخزين سحابية مخصصة لكل باقة مع رسوم إضافية منخفضة',
                    ].map((item) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.star, color: Colors.amber.shade600, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.indigo.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Subscription Packages
              const SectionTitle('باقات الاشتراك'),
              const SizedBox(height: 16),
              // Responsive layout for subscription cards
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 1200) {
                    // Desktop: 4 cards in a row
                    return const Row(
                      children: [
                        Expanded(child: SubscriptionCard(
                          title: 'باقة البداية',
                          price: '150 ريال / شهر',
                          students: 'حتى 50',
                          storage: '5 جيجا',
                          extraFee: '3 ريالات/جيجا',
                          color: Colors.blue,
                          features: [
                            'لوحة تحكم بسيطة وسريعة',
                            'رفع مستندات وفيديو بلا حدّ',
                            'شات بوت ذكي أساسي',
                            'نظام تحقق ثنائي ضد مشاركة الحساب',
                          ],
                        )),
                        SizedBox(width: 16),
                        Expanded(child: SubscriptionCard(
                          title: 'باقة النمو',
                          price: '300 ريال / شهر',
                          students: 'حتى 100',
                          storage: '10 جيجا',
                          extraFee: '3 ريالات/جيجا',
                          color: Colors.green,
                          features: ['جميع مزايا باقة البداية'],
                        )),
                        SizedBox(width: 16),
                        Expanded(child: SubscriptionCard(
                          title: 'باقة الاحتراف',
                          price: '450 ريال / شهر',
                          students: 'حتى 150',
                          storage: '15 جيجا',
                          extraFee: '3 ريالات/جيجا',
                          color: Colors.purple,
                          features: ['جميع مزايا باقة النمو', 'تصدير تقارير CSV'],
                        )),
                        SizedBox(width: 16),
                        Expanded(child: SubscriptionCard(
                          title: 'باقة المؤسسة',
                          price: '600 ريال / شهر',
                          students: 'حتى 300',
                          storage: '20 جيجا',
                          extraFee: '3 ريالات/جيجا',
                          color: Colors.orange,
                          features: ['جميع مزايا باقة الاحتراف', 'دعم فني أولوي'],
                        )),
                      ],
                    );
                  } else {
                    // Mobile/Tablet: Wrap layout
                    return const Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      children: [
                        SubscriptionCard(
                          title: 'باقة البداية',
                          price: '150 ريال / شهر',
                          students: 'حتى 50',
                          storage: '5 جيجا',
                          extraFee: '3 ريالات/جيجا',
                          color: Colors.blue,
                          features: [
                            'لوحة تحكم بسيطة وسريعة',
                            'رفع مستندات وفيديو بلا حدّ',
                            'شات بوت ذكي أساسي',
                            'نظام تحقق ثنائي ضد مشاركة الحساب',
                          ],
                        ),
                        SubscriptionCard(
                          title: 'باقة النمو',
                          price: '300 ريال / شهر',
                          students: 'حتى 100',
                          storage: '10 جيجا',
                          extraFee: '3 ريالات/جيجا',
                          color: Colors.green,
                          features: ['جميع مزايا باقة البداية'],
                        ),
                        SubscriptionCard(
                          title: 'باقة الاحتراف',
                          price: '450 ريال / شهر',
                          students: 'حتى 150',
                          storage: '15 جيجا',
                          extraFee: '3 ريالات/جيجا',
                          color: Colors.purple,
                          features: ['جميع مزايا باقة النمو', 'تصدير تقارير CSV'],
                        ),
                        SubscriptionCard(
                          title: 'باقة المؤسسة',
                          price: '600 ريال / شهر',
                          students: 'حتى 300',
                          storage: '20 جيجا',
                          extraFee: '3 ريالات/جيجا',
                          color: Colors.orange,
                          features: ['جميع مزايا باقة الاحتراف', 'دعم فني أولوي'],
                        ),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 40),

              // Getting Started Steps
              const SectionTitle('خطوات البدء'),
              const SizedBox(height: 16),
              CustomGlassContainer(
                opacity: 0.1,
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...[
                      'اختر باقتك واضغط "اشترك الآن"',
                      'أكمل الدفع الإلكتروني بأمان',
                      'أنشئ حسابك وأضف بيانات طلابك',
                      'ارفع مستنداتك وفيديوهاتك',
                      'استخدم شات البوت الذكي لدعم طلابك',
                      'تابع التقارير لتحسين تجربتهم التعليمية',
                    ].asMap().entries.map((entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.indigo.shade600,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${entry.key + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              entry.value,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.indigo.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade600, Colors.purple.shade600],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                  launchWhatsApp(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'انضم اليوم',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ).animate().scale(duration: 500.ms),
              ),
              const SizedBox(height: 20),

              Center(
                child: Text(
                  'للمزيد من الدعم: support@eram-edu.sa',
                  style: TextStyle(
                    color: Colors.indigo.shade600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Colors.indigo.shade800,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class SubscriptionCard extends StatelessWidget {
  final String title, price, students, storage, extraFee;
  final List<String> features;
  final MaterialColor color;

  const SubscriptionCard({
    super.key,
    required this.title,
    required this.price,
    required this.students,
    required this.storage,
    required this.extraFee,
    required this.features,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 300),
      child: CustomGlassContainer(
        opacity: 0.15,
        borderColor: color,
        borderWidth: 2,
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: color.shade800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              price,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: color.shade700,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(Icons.people, 'عدد الطلاب: $students'),
            _buildInfoRow(Icons.storage, 'التخزين: $storage'),
            _buildInfoRow(Icons.attach_money, 'رسوم إضافية: $extraFee'),
            const Divider(height: 20),
            ...features.map((f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check, color: color.shade600, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      f,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  launchWhatsApp(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color.shade600,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'اشترك الآن',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(duration: 600.ms),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color.shade600),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: Colors.indigo.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}