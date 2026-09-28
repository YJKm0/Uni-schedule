import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class SubjectInfo extends StatelessWidget {
  final dynamic name;
  final dynamic place;
  final dynamic prof;
  final dynamic period;
  final String? link; 

  const SubjectInfo({
    super.key,
    this.name,
    this.place,
    this.prof,
    this.period,
    this.link,
  });
  Future<void> _openLink(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تعذر فتح الرابط')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('خطأ في الرابط: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isLinkAvailable = link != null && 
        link!.trim().isNotEmpty && 
        link != 'Not Available' && 
        link!.startsWith('http');

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        spacing: 8,
        children: [
          const Icon(Icons.menu_book_rounded, color: Colors.deepPurple),
          Expanded(
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('المحاضر: $prof', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text('المكان: $place', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text('الفترة: $period', style: const TextStyle(fontSize: 14)),
            if (place=='online')...[
               const Divider(height: 24),
               const Text(
                    'رابط الفترة (Teams):',
                  style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 4),
                if (isLinkAvailable)
                InkWell(
                  onTap: () => _openLink(context, link!),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                    spacing: 6,
                    children: [
                      const Icon(Icons.link_rounded, color: Colors.blue, size: 20),
                      const Expanded(
                        child: Text(
                          'اضغط هنا للانضمام للفترة',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                      IconButton(onPressed: () async {
                         await Clipboard.setData(
                            ClipboardData(text:  link?? ''),);
                             if (context.mounted) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                 const SnackBar(
                                  content: Text('تم النسخ إلى الحافظة!'),
                                   duration: Duration(seconds: 2),
                                  ),
                                );
                            } 
                          },
                      icon: Icon(Icons.copy,color: Colors.blue, size: 20))
                    ],
                  ),
                ),
              )
                else
                 const Row(
                   children: [
                    Icon(Icons.link_off_rounded, color: Colors.grey, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'الرابط غير متاح حالياً',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                ],
              ),
           ] else ...[
            const Divider(),
           ]
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}