import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_schudle_try1/core/constants.dart';
import 'package:uni_schudle_try1/modules/schedule_model.dart';
import 'package:url_launcher/url_launcher.dart';

class SubjectInfo extends StatelessWidget {
  final Schedule s;

  const SubjectInfo({super.key, required this.s});

  Future<void> _openLink(BuildContext context, String urlString) async {
    final Uri url = Uri.parse(urlString);
    try {
      final bool launched = await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open the link')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error opening the link: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isLinkAvailable =
        s.teamsLink.trim().isNotEmpty &&
        s.teamsLink != 'Not Available' &&
        s.teamsLink.startsWith('http');

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        spacing: 8,
        children: [
          Icon(Icons.menu_book_rounded, color: colorScheme.primary),
          Expanded(
            child: Text(
              s.subject,
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
            Text(
              'Professor: ${s.professor}',
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text('Place: ${s.location}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 8),
            Text(
              'Period: ${AcademicConstants.periods[s.period]}',
              style: const TextStyle(fontSize: 14),
            ),
            if (s.location == 'Online') ...[
              const Divider(height: 24),
              Text(
                'Teams Link:',
                style: TextStyle(
                  fontSize: 13,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              if (isLinkAvailable)
                InkWell(
                  onTap: () => _openLink(context, s.teamsLink),
                  borderRadius: BorderRadius.circular(6),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      spacing: 6,
                      children: [
                        Icon(
                          Icons.link_rounded,
                          color: colorScheme.primary,
                          size: 20,
                        ),
                        Expanded(
                          child: Text(
                            'Click here to join Teams meeting',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontSize: 12.7,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            await Clipboard.setData(
                              ClipboardData(text: s.teamsLink),
                            );
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          icon: Icon(
                            Icons.copy,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Row(
                  children: [
                    Icon(
                      Icons.link_off_rounded,
                      color: colorScheme.onSurface.withValues(alpha: 0.5),
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Link is Not available right now',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
            ] else ...[
              const Divider(),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
