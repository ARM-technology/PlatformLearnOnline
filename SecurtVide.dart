import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;
import 'dart:async';

class VideoProtectionManager {
  static VideoProtectionManager? _instance;
  bool _isProtectionActive = false;
  Timer? _protectionTimer;
  bool _isShowingSnackBar = false;
  BuildContext? _context;

  VideoProtectionManager._internal();

  factory VideoProtectionManager() {
    _instance ??= VideoProtectionManager._internal();
    return _instance!;
  }

  void initializeProtection(BuildContext context) {
    _context = context;
    if (!_isProtectionActive) {
      _isProtectionActive = true;
      _setupVideoProtection();
    }
  }

  void _setupVideoProtection() {
    // إضافة JavaScript للحماية المتقدمة
    _injectProtectionScript();

    // مراقبة دورية للحماية
    _protectionTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_isProtectionActive) {
        _reinforceProtection();
      }
    });

    // منع النقر بزر الماوس الأيمن
    html.document.addEventListener(
        'contextmenu', (event) => _handleContextMenu(event));

    // منع اختصارات لوحة المفاتيح
    html.document.addEventListener(
        'keydown', (event) => _handleKeyDown(event));

    // منع السحب والإفلات للفيديو
    html.document.addEventListener(
        'dragstart', (event) => _handleDragStart(event));

    // مراقبة تغيير الصفحة
    html.window.addEventListener(
        'beforeunload', (event) => _handleBeforeUnload(event));
  }

  void _handleContextMenu(html.Event event) {
    event.preventDefault();
    _showWarningMessage('النقر بزر الماوس الأيمن غير مسموح!');
  }

  void _handleKeyDown(html.Event event) {
    final keyEvent = event as html.KeyboardEvent;
    if (_shouldBlockKeyEvent(keyEvent)) {
      event.preventDefault();
      _showWarningMessage('هذا الاختصار غير مسموح!');
    }
  }

  void _handleDragStart(html.Event event) {
    event.preventDefault();
    _showWarningMessage('السحب والإفلات غير مسموح!');
  }

  void _handleBeforeUnload(html.Event event) {
    _logAttemptedAction('محاولة مغادرة الصفحة');
  }

  bool _shouldBlockKeyEvent(html.KeyboardEvent event) {
    // قائمة الاختصارات المحظورة
    return (event.ctrlKey && event.key == 's') || // Ctrl+S (حفظ)
        (event.ctrlKey && event.key == 'p') || // Ctrl+P (طباعة)
        (event.key == 'F12') || // F12 (أدوات المطور)
        (event.ctrlKey && event.shiftKey && event.key == 'I') || // Ctrl+Shift+I
        (event.ctrlKey && event.shiftKey && event.key == 'C') || // Ctrl+Shift+C
        (event.ctrlKey && event.shiftKey && event.key == 'J') || // Ctrl+Shift+J
        (event.ctrlKey && event.key == 'u') || // Ctrl+U (مصدر الصفحة)
        (event.ctrlKey && event.key == 'c') || // Ctrl+C (نسخ)
        (event.ctrlKey && event.key == 'a') || // Ctrl+A (تحديد الكل)
        (event.ctrlKey && event.key == 'x') || // Ctrl+X (قص)
        (event.ctrlKey && event.key == 'v'); // Ctrl+V (لصق)
  }

  void _injectProtectionScript() {
    final script = html.ScriptElement()
      ..text = '''
        // حماية شاملة للفيديو
        (function() {
          // تعطيل النقر بزر الماوس الأيمن
          document.addEventListener('contextmenu', function(e) {
            e.preventDefault();
            return false;
          });

          // تعطيل التحديد
          document.addEventListener('selectstart', function(e) {
            e.preventDefault();
            return false;
          });

          // تعطيل السحب والإفلات
          document.addEventListener('dragstart', function(e) {
            e.preventDefault();
            return false;
          });

          // حماية الفيديو من التحميل
          document.addEventListener('DOMContentLoaded', function() {
            const videos = document.querySelectorAll('video');
            videos.forEach(function(video) {
              video.setAttribute('controlsList', 'nodownload nofullscreen noremoteplayback');
              video.setAttribute('disablePictureInPicture', 'true');
              video.setAttribute('oncontextmenu', 'return false;');
              
              // منع النقر بزر الماوس الأيمن على الفيديو
              video.addEventListener('contextmenu', function(e) {
                e.preventDefault();
                return false;
              });
            });
          });

          // مراقبة إضافة فيديوهات جديدة
          const observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
              mutation.addedNodes.forEach(function(node) {
                if (node.tagName === 'VIDEO') {
                  node.setAttribute('controlsList', 'nodownload nofullscreen noremoteplayback');
                  node.setAttribute('disablePictureInPicture', 'true');
                  node.setAttribute('oncontextmenu', 'return false;');
                  
                  node.addEventListener('contextmenu', function(e) {
                    e.preventDefault();
                    return false;
                  });
                }
              });
            });
          });

          observer.observe(document.body, {
            childList: true,
            subtree: true
          });

          // تعطيل الطباعة
          window.print = function() {
            alert('الطباعة غير مسموحة!');
            return false;
          };

          // تعطيل أدوات المطور
          let devtools = {
            open: false,
            orientation: null
          };

          const threshold = 160;
          setInterval(function() {
            if (window.outerHeight - window.innerHeight > threshold || 
                window.outerWidth - window.innerWidth > threshold) {
              if (!devtools.open) {
                devtools.open = true;
                alert('أدوات المطور غير مسموحة!');
                window.location.reload();
              }
            } else {
              devtools.open = false;
            }
          }, 500);

          // منع استنساخ الفيديو
          Object.defineProperty(HTMLVideoElement.prototype, 'src', {
            get: function() {
              return this.getAttribute('src');
            },
            set: function(value) {
              if (value.includes('blob:') || value.includes('data:')) {
                console.warn('محاولة تحميل غير مسموحة');
                return;
              }
              this.setAttribute('src', value);
            }
          });
        })();
      ''';

    html.document.head!.append(script);
  }

  void _reinforceProtection() {
    // تعزيز الحماية بشكل دوري
    final videos = html.document.querySelectorAll('video');
    for (final video in videos) {
      video.setAttribute('controlsList', 'nodownload nofullscreen noremoteplayback');
      video.setAttribute('disablePictureInPicture', 'true');
      video.setAttribute('oncontextmenu', 'return false;');
    }
  }

  void _showWarningMessage(String message) {
    if (_context != null && _context!.mounted && !_isShowingSnackBar) {
      _isShowingSnackBar = true;

      // إزالة أي SnackBar حالي
      ScaffoldMessenger.of(_context!).clearSnackBars();

      ScaffoldMessenger.of(_context!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.warning, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(child: Text(message)),
            ],
          ),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // إعادة تعيين الحالة بعد 5 ثوانٍ
      Timer(const Duration(seconds: 5), () {
        _isShowingSnackBar = false;
      });
    }
  }

  void _logAttemptedAction(String action) {
    // يمكن إضافة تسجيل للمحاولات المشبوهة
    print('🚫 محاولة محظورة: $action');
  }

  void disposeProtection() {
    _isProtectionActive = false;
    _protectionTimer?.cancel();

    // إزالة مستمعي الأحداث
    html.document.removeEventListener('contextmenu', _handleContextMenu);
    html.document.removeEventListener('keydown', _handleKeyDown);
    html.document.removeEventListener('dragstart', _handleDragStart);

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }
}


