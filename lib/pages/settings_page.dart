import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _defaultSection = 1;
  bool _alwaysToday = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  // تحميل القيم المحفوظة
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _defaultSection = prefs.getInt('default_section') ?? 1;
      _alwaysToday = prefs.getBool('always_today') ?? true;
      _isLoading = false;
    });
  }

  // حفظ حالة تاريخ اليوم (bool)
  Future<void> _updateAlwaysToday(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('always_today', value);
    setState(() {
      _alwaysToday = value;
    });
  }

  // حفظ رقم السكشن الافتراضي (int)
  Future<void> _updateDefaultSection(int section) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('default_section', section);
    setState(() {
      _defaultSection = section;
    });
  }

  // نافذة لاختيار رقم السكشن
  void _showSectionPickerDialog() {
    final textController = TextEditingController(text: _defaultSection.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFF7F5FA),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'تحديد السكشن الافتراضي',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'أدخل رقم السكشن (مثلاً 47)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF673AB7),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final newSection = int.tryParse(textController.text);
                if (newSection != null && newSection > 0) {
                  _updateDefaultSection(newSection);
                }
                Navigator.pop(context);
              },
              child: const Text('حفظ'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFBCAAA4),
      appBar: AppBar(
        title: const Text('الإعدادات', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF673AB7),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF673AB7)))
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. خيار السكشن الافتراضي
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: const CircleAvatar(
                      backgroundColor: Color(0xFFEDE7F6),
                      child: Icon(Icons.group_outlined, color: Color(0xFF673AB7)),
                    ),
                    title: const Text(
                      'السكشن الافتراضي',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: const Text(
                      'السكشن الذي سيتم تحميل جدوله وتحديده تلقائياً عند فتح التطبيق.',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE7F6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_defaultSection',
                        style: const TextStyle(
                          color: Color(0xFF673AB7),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    onTap: _showSectionPickerDialog,
                  ),
                ),

                const SizedBox(height: 12),

                // 2. خيار تاريخ اليوم التلقائي
                Card(
                  elevation: 1,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    activeThumbColor: const Color(0xFF673AB7),
                    secondary: const CircleAvatar(
                      backgroundColor: Color(0xFFEDE7F6),
                      child: Icon(Icons.today_outlined, color: Color(0xFF673AB7)),
                    ),
                    title: const Text(
                      'البدء بتاريخ اليوم',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    subtitle: const Text(
                      'فتح التقويم تلقائياً على تاريخ اليوم الحالي في كل مرة تفتح فيها التطبيق.',
                      style: TextStyle(color: Colors.black54, fontSize: 13),
                    ),
                    value: _alwaysToday,
                    onChanged: _updateAlwaysToday,
                  ),
                ),
              ],
            ),
    );
  }
}