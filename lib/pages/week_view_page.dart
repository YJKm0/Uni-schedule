import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_schudle_try1/modules/schedule_model.dart';
import 'package:uni_schudle_try1/pages/subject_info.dart';
import 'package:uni_schudle_try1/services/processor.dart';

class WeekViewPage extends StatefulWidget {
   int secNumber;
  final DateTime startweek;
  final DateTime selectedDate;
  final Processor _processor;
   final Function(int) onSectionChanged;
   WeekViewPage({super.key, required this.secNumber, required this.selectedDate, required this._processor, required this.startweek, required this.onSectionChanged });
  @override
  State<WeekViewPage> createState() => _WeekViewPageState();
}
 
class _WeekViewPageState extends State<WeekViewPage> {
  @override
    void initState() {
      super.initState();
   }
  void changeSection(int newSec) {
    setState(() {
      widget.secNumber = newSec; 
    });
    widget.onSectionChanged(newSec);
    // يحدث صفحة الهوم في الخلفية
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        spacing: 5,
        children: [
          _WeekViewHeader(startOfTheWeek: widget.startweek, selectedSection: widget.secNumber, onSectionChanged: changeSection,),
          Expanded(child: _WeekviewBody(
            startOfTheWeek : widget.startweek,
            processor: widget._processor, selectedSection: widget.secNumber,
          )),
        ],
      ),
    );
  }
}

class _WeekViewHeader extends StatelessWidget {
  final DateTime startOfTheWeek;
  final int selectedSection;
  final Function(int) onSectionChanged;
  const _WeekViewHeader({required this.startOfTheWeek, required this.selectedSection, required this.onSectionChanged});

  @override
  Widget build(BuildContext context) {
    return  Container(
      alignment:AlignmentGeometry.topCenter,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 0),
      child: Row(
        spacing: 5,
        children: [
        IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back)),
        Text('${startOfTheWeek.day} to ${startOfTheWeek.add(const Duration(days: 6)).day}'),
        IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_forward)),
        TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: ( context) {
                TextEditingController secNumController=TextEditingController();
                return AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                     title: const Text(
                    'Change Section',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  content: TextField(
                    controller: secNumController,
                    keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  autofocus: true,
                  decoration: const InputDecoration(
                  hintText: 'Enter section number (e.g. 39)',
                  border: OutlineInputBorder(),
                ),
              ),
                  actions: [
                    //Cancel button
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                       child: Text('Cancel', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)))),
                    ElevatedButton(
                      onPressed: (){
                        // validating SectinNumber
                        int? parsedSection = int.tryParse(secNumController.text.trim());
                        if (parsedSection == null) {
                        secNumController.clear();
                              return;
                        }
                        onSectionChanged(parsedSection);
                        Navigator.pop(context);
                      },
                       child:  const Text('Save'))
                  ]
          );
      }
    );
 }, 
          child: const Text('Change Section', style: TextStyle(fontSize: 15) ,),
          ),
        Text('Section: $selectedSection',
        )
      ]
      ),
    );
  }
}

class _WeekviewBody extends StatelessWidget {
 final DateTime startOfTheWeek ;
  final Processor processor;
  final int selectedSection;
  final Map<int,String> dayOfTheWeek = {
    DateTime.saturday: 'Sat',
    DateTime.sunday: 'Sun',
    DateTime.monday: 'Mon',
    DateTime.tuesday: 'Tue',
    DateTime.wednesday: 'Wed',
    DateTime.thursday: 'Thu',
    DateTime.friday: 'Fri',
  };
   _WeekviewBody( {required this.startOfTheWeek, required this.processor, required this.selectedSection});
  
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return  ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: 7,
      itemBuilder: (BuildContext context, int index) {
        var day = startOfTheWeek.add(Duration(days: index));
        var items = processor.getScheduleForSection(selectedSection,day);
        return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(
                      minWidth: 54,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.onSurface.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    dayOfTheWeek[day.weekday] ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 3),
                items.isEmpty
                    ? Text(
                        'No Sections or Lectures ',
                        style: TextStyle(color: colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 12),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: items.map((lecture) {
                            final chipColor = lecture.type == 2 ? colorScheme.primary : colorScheme.error;
                            return Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: ActionChip(
                                backgroundColor: chipColor.withValues(alpha: 0.1),
                                side: BorderSide(color: chipColor.withValues(alpha: 0.3)),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                label: Text(
                                  lecture.subject,
                                  style: TextStyle(
                                    color: chipColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                                onPressed: () {
                                  _showLectureDetails(context, lecture);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ],
            ),
      ),
    );
  },
);
}

  void _showLectureDetails(BuildContext context, Schedule lecture) {
    showDialog(
    context: context
    , builder: (context) {
      return SubjectInfo(
         s: lecture,
      );
    }
    );
  }
}