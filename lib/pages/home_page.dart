import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uni_schudle_try1/modules/schedule_model.dart';
import 'package:uni_schudle_try1/pages/settings_page.dart';
import 'package:uni_schudle_try1/pages/subject_info.dart';
import 'package:uni_schudle_try1/services/processor.dart';

class HomePage extends StatefulWidget {
  final Processor processor;

  const HomePage({super.key, required this.processor});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Map<int, String> periods = {
    1: "8:30 Am => 10:10 Am",
    2: "10:20 Am => 12:00 Pm",
    3: "12:20 Pm => 2:00 Pm",
    4: "2:10 Pm => 3:50 Pm",
    5: "4:00 Pm => 5:40 Pm",
    6: "5:50 pm => 7:30",
    7: "7:30 Pm => 9:00 Pm",
    8: "9:00 Pm => 10:30 Pm",
  };

  final TextEditingController _secNumController = TextEditingController();

  int? selectedSection ;
  
  List<Schedule>? items;
  DateTime selectedDate = DateTime(2026, 9, 19);
  final DateTime _minDate = DateTime(2026, 9, 19);
  final DateTime _maxDate = DateTime(2027, 1, 1);

  @override
  void initState() {
    super.initState();
    _loadSavedSettingsAndFetch();
  }

  @override
  void dispose() {
    _secNumController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedSettingsAndFetch() async {
    final prefs = await SharedPreferences.getInstance();
    final defaultSec = prefs.getInt('default_section') ?? 1;
    final alwaysToday = prefs.getBool('always_today') ?? true;

    DateTime initialDate = _minDate;
    if (alwaysToday) {
      final now = DateTime.now();
      if (now.isAfter(_minDate.subtract(const Duration(days: 1))) &&
          now.isBefore(_maxDate.add(const Duration(days: 1)))) {
        initialDate = now;
      }
    }

    setState(() {
      selectedSection = defaultSec;
      _secNumController.text = defaultSec.toString();
      selectedDate = initialDate;
      items = widget.processor.getScheduleForSection(selectedSection!, selectedDate);
    });
  }
  void _validateAndFetch() {
  final parsedSection = int.tryParse(_secNumController.text.trim());
  
  if (parsedSection == null) {
    _secNumController.clear();
    return;
  }

  setState(() {
    selectedSection = parsedSection;
    items = widget.processor.getScheduleForSection(parsedSection, selectedDate);
  });
}
  void onButtonPressed() {
    _validateAndFetch();
  }

  void onListItemeTapped(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return SubjectInfo(
          name: items![index].subject,
          prof: items![index].professor,
          period: periods[items![index].period],
          place: items![index].location ?? 'online',
          link: items![index].teamsLink,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
     
      backgroundColor: const Color(0xFFF7F5FA),
      drawer: Drawer(
        backgroundColor: const Color(0xFF1E102F),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              ListTile(
                leading: const Icon(Icons.settings, color: Color(0xFFD8B4FE)),
                title: const Text(
                  "S E T T I N G S",
                  style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsScreen()),
                  );
                  _loadSavedSettingsAndFetch();
                },
              ),
              const Spacer(),
              const ListTile(
                horizontalTitleGap: 0,
                leading: Icon(Icons.copyright_outlined, size: 20, color: Colors.white60),
                title: Text('Built By YJK', style: TextStyle(fontSize: 11, color: Colors.white60)),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF673AB7),
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Uni Schedule',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Card(
              elevation: 0.5,
              color: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CalendarDatePicker(
                  key: ValueKey(selectedDate),
                  firstDate: _minDate,
                  lastDate: _maxDate,
                  initialCalendarMode: DatePickerMode.day,
                  initialDate: selectedDate,
                  onDateChanged: (DateTime value) {
                    setState(() {
                      selectedDate = value;
                      if (_secNumController.text.isNotEmpty) {
                        _validateAndFetch();
                      }
                    });
                  },
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      keyboardType: const TextInputType.numberWithOptions(decimal: false, signed: false),
                      controller: _secNumController,
                      decoration: InputDecoration(
                        hintText: 'Enter Section Number (e.g. 39)',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: const Icon(Icons.search, color: Color(0xFF673AB7)),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      ),
                      onSubmitted: (_) => _validateAndFetch(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF673AB7),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  onPressed: onButtonPressed,
                  child: const Text('Enter', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 6),
          Expanded(
  child: items == null
      
      ? const Center(
          child: CircularProgressIndicator(color: Color(0xFF673AB7)),
        )
    
      : items!.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.event_busy_outlined, size: 54, color: Colors.grey.shade400),
                  const SizedBox(height: 10),
                  Text(
                    'No available Sections or lectures',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            )
         
          : ListView.builder(
              itemCount: items!.length,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              itemBuilder: (context, index) {
                final item = items![index];
                final isOnline = item.location == null || item.location!.isEmpty;

                return Card(
                  elevation: 0.5,
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    onTap: () => onListItemeTapped(index),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFFEDE7F6),
                      child: Icon(
                        isOnline ? Icons.language_outlined : Icons.account_balance_sharp,
                        color: const Color(0xFF673AB7),
                      ),
                    ),
                    title: Text(
                      item.subject,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${item.location ?? 'Online'} • ${periods[item.period]} • ${item.professor}',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                      ),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  ),
                );
              },
            ),
)
        ],
      ),
    );
  }
}