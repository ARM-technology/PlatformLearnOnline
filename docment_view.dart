import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;

import 'package:web_learn/BackEnd/Backend_Storage.dart';


class DocumentViewerPage extends StatefulWidget {
  final String fileKey;
  final String fileName;

  const DocumentViewerPage({
    Key? key,
    required this.fileKey,
    required this.fileName,
  }) : super(key: key);

  @override
  _DocumentViewerPageState createState() => _DocumentViewerPageState();
}

class _DocumentViewerPageState extends State<DocumentViewerPage> {
  final S3LambdaService _s3Service = S3LambdaService();
  String? _viewId;
  String? _errorMessage;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _generateDocumentUrl();
    _setupDownloadProtection();
  }

  void _setupDownloadProtection() {
    // منع النقر بزر الماوس الأيمن
    html.document.addEventListener('contextmenu', (event) {
      event.preventDefault();
    });

    // منع اختصارات الطباعة والحفظ
    html.document.addEventListener('keydown', (event) {
      final keyEvent = event as html.KeyboardEvent;

      // منع Ctrl+S (حفظ)
      if (keyEvent.ctrlKey && keyEvent.key == 's') {
        event.preventDefault();
        _showWarningMessage('التحميل غير مسموح!');
      }

      // منع Ctrl+P (طباعة)
      if (keyEvent.ctrlKey && keyEvent.key == 'p') {
        event.preventDefault();
        _showWarningMessage('الطباعة غير مسموحة!');
      }

      // منع F12 (أدوات المطور)
      if (keyEvent.key == 'F12') {
        event.preventDefault();
        _showWarningMessage('أدوات المطور غير مسموحة!');
      }

      // منع Ctrl+Shift+I (أدوات المطور)
      if (keyEvent.ctrlKey && keyEvent.shiftKey && keyEvent.key == 'I') {
        event.preventDefault();
        _showWarningMessage('أدوات المطور غير مسموحة!');
      }
    });

    // مراقبة تغيير حالة النافذة للكشف عن محاولات التحميل
    html.window.addEventListener('beforeunload', (event) {
      // يمكن استخدام هذا لتسجيل محاولات المغادرة
    });
  }

  void _showWarningMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _generateDocumentUrl() async {
    try {
      final presignedUrl = await _s3Service.getDownloadUrl(fileKey: widget.fileKey);
      final encodedUrl = Uri.encodeComponent(presignedUrl);
      final viewerUrl = 'https://docs.google.com/gview?url=$encodedUrl&embedded=true';

      final uniqueViewId = 'iframe-viewer-${widget.fileKey.hashCode}';

      // إنشاء حاوية div مع حماية إضافية
      final html.DivElement div = html.DivElement()
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.overflow = 'hidden'
        ..style.position = 'relative'
        ..style.userSelect = 'none' // منع تحديد النص
        ..style.pointerEvents = 'auto';

      // إنشاء عنصر IFrame مع حماية
      final html.IFrameElement iframe = html.IFrameElement()
        ..src = viewerUrl
        ..style.border = 'none'
        ..style.width = '100%'
        ..style.height = 'calc(100% + 56px)'
        ..style.position = 'relative'
        ..style.top = '-56px'
        ..setAttribute('sandbox', 'allow-same-origin allow-scripts allow-popups allow-forms')
        ..setAttribute('allowfullscreen', 'false')
        ..setAttribute('webkitallowfullscreen', 'false')
        ..setAttribute('mozallowfullscreen', 'false');

      // إضافة طبقة حماية شفافة فوق الـ iframe
      final html.DivElement protectionLayer = html.DivElement()
        ..style.position = 'absolute'
        ..style.top = '0'
        ..style.left = '0'
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.backgroundColor = 'transparent'
        ..style.zIndex = '1000'
        ..style.pointerEvents = 'none'; // السماح بالتفاعل مع المحتوى

      // إضافة رسالة تحذيرية في الأعلى
      final html.DivElement warningBar = html.DivElement()
        ..style.position = 'absolute'
        ..style.top = '0'
        ..style.left = '0'
        ..style.width = '100%'
        ..style.height = '30px'
        ..style.backgroundColor = 'rgba(255, 0, 0, 0.8)'
        ..style.color = 'white'
        ..style.textAlign = 'center'
        ..style.lineHeight = '30px'
        ..style.fontSize = '12px'
        ..style.zIndex = '1001'
        ..style.userSelect = 'none'
        ..innerText = '⚠️ التحميل والطباعة غير مسموحان';

      // إضافة JavaScript لحماية إضافية
      final html.ScriptElement script = html.ScriptElement()
        ..text = '''
          // منع النقر بزر الماوس الأيمن
          document.addEventListener('contextmenu', function(e) {
            e.preventDefault();
            return false;
          });
          
          // منع التحديد
          document.addEventListener('selectstart', function(e) {
            e.preventDefault();
            return false;
          });
          
          // منع السحب والإفلات
          document.addEventListener('dragstart', function(e) {
            e.preventDefault();
            return false;
          });
          
          // مراقبة محاولات فتح نوافذ جديدة أو التحميل
          window.addEventListener('beforeunload', function(e) {
            // يمكن إضافة تسجيل هنا
          });
          
          // تعطيل اختصارات لوحة المفاتيح الإضافية
          document.addEventListener('keydown', function(e) {
            // منع Ctrl+A (تحديد الكل)
            if (e.ctrlKey && e.key === 'a') {
              e.preventDefault();
              return false;
            }
            
            // منع Ctrl+C (نسخ)
            if (e.ctrlKey && e.key === 'c') {
              e.preventDefault();
              return false;
            }
            
            // منع Ctrl+V (لصق)
            if (e.ctrlKey && e.key === 'v') {
              e.preventDefault();
              return false;
            }
            
            // منع Ctrl+X (قص)
            if (e.ctrlKey && e.key === 'x') {
              e.preventDefault();
              return false;
            }
            
            // منع Ctrl+U (عرض مصدر الصفحة)
            if (e.ctrlKey && e.key === 'u') {
              e.preventDefault();
              return false;
            }
            
            // منع Ctrl+Shift+C (أدوات المطور)
            if (e.ctrlKey && e.shiftKey && e.key === 'C') {
              e.preventDefault();
              return false;
            }
            
            // منع Ctrl+Shift+J (وحدة التحكم)
            if (e.ctrlKey && e.shiftKey && e.key === 'J') {
              e.preventDefault();
              return false;
            }
          });
          
          // إعادة تعريف وظائف الطباعة والحفظ
          window.print = function() {
            alert('الطباعة غير مسموحة!');
            return false;
          };
          
          // مراقبة تغيير الـ URL للكشف عن محاولات التحميل
          let originalUrl = window.location.href;
          setInterval(function() {
            if (window.location.href !== originalUrl) {
              // إعادة توجيه إلى الصفحة الأصلية
              window.location.href = originalUrl;
            }
          }, 1000);
        ''';

      // إضافة العناصر للحاوية
      div.append(iframe);
      div.append(protectionLayer);
      div.append(warningBar);
      div.append(script);

      // إضافة CSS إضافي لمنع التحديد والنسخ
      final html.StyleElement style = html.StyleElement()
        ..text = '''
          * {
            -webkit-user-select: none !important;
            -moz-user-select: none !important;
            -ms-user-select: none !important;
            user-select: none !important;
            -webkit-touch-callout: none !important;
            -webkit-tap-highlight-color: transparent !important;
          }
          
          body {
            -webkit-print-color-adjust: exact !important;
          }
          
          @media print {
            body {
              display: none !important;
            }
          }
          
          iframe {
            pointer-events: auto !important;
          }
        ''';

      div.append(style);

      // تسجيل الحاوية للعرض في فلاتر
      ui.platformViewRegistry.registerViewFactory(
        uniqueViewId,
            (int viewId) => div,
      );

      if (mounted) {
        setState(() {
          _viewId = uniqueViewId;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = "فشل في تجهيز المستند للعرض: ${e.toString()}";
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // إزالة مستمعي الأحداث عند إغلاق الصفحة
    html.document.removeEventListener('contextmenu', null);
    html.document.removeEventListener('keydown', null);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // يمكن إضافة تأكيد للخروج هنا
        return true;
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1A202C),
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(Icons.security, color: Colors.red, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.fileName,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2D3748),
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              icon: const Icon(Icons.warning, color: Colors.amber),
              onPressed: () {
                _showProtectionInfo();
              },
            ),
          ],
        ),
        body: _buildBody(),
      ),
    );
  }

  void _showProtectionInfo() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('معلومات الحماية'),
          content: const Text(
            'هذا المستند محمي:\n\n'
                '• لا يمكن تحميله\n'
                '• لا يمكن طباعته\n'
                '• لا يمكن نسخه\n'
                '• للعرض فقط\n\n'
                'أي محاولة للتحميل أو الطباعة سيتم منعها.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('فهمت'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text(
              'جاري تحميل المستند المحمي...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _errorMessage = null;
                  });
                  _generateDocumentUrl();
                },
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
      );
    }

    if (_viewId != null) {
      return Stack(
        children: [
          HtmlElementView(viewType: _viewId!),
          // إضافة طبقة حماية إضافية على مستوى Flutter
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 30,
              color: Colors.red.withOpacity(0.8),
              child: const Center(
                child: Text(
                  '🔒 مستند محمي - للعرض فقط',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    return const Center(
      child: Text(
        'حدث خطأ غير متوقع.',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}