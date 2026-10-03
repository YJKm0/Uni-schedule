import 'package:flutter/material.dart';
import 'package:uni_schudle_try1/core/constants.dart';
import 'package:uni_schudle_try1/core/locator.dart';
import 'package:uni_schudle_try1/modules/schedule_model.dart';
import 'package:uni_schudle_try1/pages/settings_page.dart';
import 'package:uni_schudle_try1/pages/subject_info.dart';
//import 'package:uni_schudle_try1/pages/week_view_page.dart';
import 'package:uni_schudle_try1/view_models/schedule_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _secNumController = TextEditingController();
  final ScheduleVm vm = locator<ScheduleVm>();
  @override
  void initState() {
    super.initState();
    vm.loadInitialData();
  }

  @override
  void dispose() {
    _secNumController.dispose();
    super.dispose();
  }

  void onListItemeTapped(BuildContext context, Schedule item) {
    showDialog(
      context: context,
      builder: (context) {
        return SubjectInfo(s: item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              ListTile(
                leading: Icon(Icons.settings, color: colorScheme.primary),
                title: const Text(
                  "S E T T I N G S",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingsScreen(),
                    ),
                  );
                  if (context.mounted) {
                    vm.loadDefualts();
                  }
                },
              ),
              const Spacer(),
              ListTile(
                horizontalTitleGap: 0,
                leading: Icon(
                  Icons.copyright_outlined,
                  size: 20,
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
                title: Text(
                  'Built By YJK',
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: const Text(
          'Uni Schedule',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        /*actions: [
          IconButton(
            icon: Icon(
              vm.isWeekView ? Icons.calendar_view_day : Icons.view_week_rounded,
            ),
            tooltip: 'Toggle View',
            onPressed: () {
              vm.toggleViewMode();
            },
          ),
        ],*/
      ),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, _) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (vm.isWeekView) {
            return Placeholder();
            /*
            return WeekViewPage(
              onSectionChanged: (int sectionNumber) {
                setState(() {
                  selectedSection = sectionNumber;
                  _secNumController.text = selectedSection.toString();
                });
              },
              secNumber: selectedSection,
              selectedDate: selectedDate,
              processor: viewModel.getProcessor(), 
              startweek: viewModel.getSaturdayOfWeek(selectedDate),
            );*/
          }
          final items = vm.getSchedule();
          return Column(
            children: [
              MyCalander(),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    Text('${vm.currentSectionNumber}'),
                    SizedBox(width: 10),
                    //Section Number txt Feild
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: colorScheme.onSurface.withValues(alpha: 0.1),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: theme.shadowColor.withValues(alpha: 0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          autofocus: false,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: false,
                            signed: false,
                          ),
                          controller: _secNumController,
                          decoration: InputDecoration(
                            hintText: 'Enter Section Number (e.g. 39)',
                            hintStyle: TextStyle(
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                              fontSize: 14,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: colorScheme.primary,
                            ),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          onTapOutside: (e) {
                            FocusScope.of(context).unfocus();
                          },
                          onSubmitted: (_) {
                            vm.updateSection(_secNumController.text);
                            _secNumController.clear();
                          },
                        ),
                      ),
                    ),
                    // Enter Button
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                      ),
                      onPressed: () {
                        vm.updateSection(_secNumController.text);
                        _secNumController.clear();
                      },
                      child: const Text(
                        'Enter',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Subjscts view
              const SizedBox(height: 6),
              Expanded(
                child: items.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy_outlined,
                              size: 54,
                              color: colorScheme.onSurface.withValues(
                                alpha: 0.4,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'No available Sections or lectures',
                              style: TextStyle(
                                fontSize: 16,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.6,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: items.length,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          final isOnline = item.location == 'Online';

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              onTap: () => onListItemeTapped(context, item),
                              leading: CircleAvatar(
                                backgroundColor: colorScheme.primary.withValues(
                                  alpha: 0.12,
                                ),
                                child: Icon(
                                  isOnline
                                      ? Icons.language_outlined
                                      : Icons.account_balance_sharp,
                                  color: colorScheme.primary,
                                ),
                              ),
                              title: Text(
                                item.subject,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  '${item.location} • ${AcademicConstants.periods[item.period]} • ${item.professor}',
                                  style: TextStyle(
                                    color: colorScheme.onSurface.withValues(
                                      alpha: 0.65,
                                    ),
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              trailing: Icon(
                                Icons.arrow_forward_ios,
                                size: 14,
                                color: colorScheme.onSurface.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class MyCalander extends StatelessWidget {
  final vm = locator<ScheduleVm>();
  MyCalander({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: CalendarDatePicker(
            key: ValueKey(vm.selectedDate),
            firstDate: AcademicConstants.minDate,
            lastDate: AcademicConstants.maxDate,
            initialCalendarMode: DatePickerMode.day,
            initialDate: vm.selectedDate,
            onDateChanged: (DateTime value) {
              vm.updateSelectedDate(value);
            },
          ),
        ),
      ),
    );
  }
}
