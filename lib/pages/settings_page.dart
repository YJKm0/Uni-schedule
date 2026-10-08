import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:uni_schudle_try1/core/locator.dart';
import 'package:uni_schudle_try1/view_models/app_view_model.dart';
import 'package:uni_schudle_try1/view_models/settings_view_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsVm settingsVm = locator<SettingsVm>();

  @override
  void initState() {
    super.initState();
    settingsVm.loadInitialSettings();
  }

  void _showSectionPickerDialog() {
    final textController = TextEditingController(
      text: settingsVm.defaultSection.toString(),
    );
    final colorScheme = Theme.of(context).colorScheme;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Set Default Section',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: TextField(
            controller: textController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Enter section number (e.g. 39)',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
              ),
              onPressed: () {
                final newSection = int.tryParse(textController.text);
                if (newSection != null && newSection > 0) {
                  settingsVm.updateDefaultSection(newSection);
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListenableBuilder(
        listenable: settingsVm,
        builder: (context, _) {
          if (settingsVm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                //Section Default
                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.12,
                      ),
                      child: Icon(
                        Icons.group_outlined,
                        color: colorScheme.primary,
                      ),
                    ),
                    title: const Text(
                      'Default Section',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'The section that will be loaded and selected automatically when opening the app.',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${settingsVm.defaultSection}',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    onTap: _showSectionPickerDialog,
                  ),
                ),

                const SizedBox(height: 12),
                //AlwaysTodayToggle
                Card(
                  child: SwitchListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    activeThumbColor: colorScheme.primary,
                    secondary: CircleAvatar(
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.12,
                      ),
                      child: Icon(
                        Icons.today_outlined,
                        color: colorScheme.primary,
                      ),
                    ),
                    title: const Text(
                      'Start with Today\'s Date',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      'Automatically open the calendar to today\'s date every time you open the app.',
                      style: TextStyle(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                    value: settingsVm.alwaysToday,
                    onChanged: settingsVm.updateAlwaysToday,
                  ),
                ),

                Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: CircleAvatar(
                      backgroundColor: colorScheme.primary.withValues(
                        alpha: 0.12,
                      ),
                      child: Icon(
                        Icons.palette_outlined,
                        color: colorScheme.primary,
                      ),
                    ),
                    title: const Text('App Theme'),
                    trailing: PopupMenuButton<ThemeMode>(
                      initialValue: settingsVm.appTheme,
                      tooltip: 'Select Theme',
                      onSelected: (value) {
                        settingsVm.updateApptheme(value);
                        locator<AppVm>().loadtheme();
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<ThemeMode>>[
                            const PopupMenuItem<ThemeMode>(
                              value: ThemeMode.system,
                              child: Row(
                                children: [
                                  Icon(Icons.brightness_auto, size: 20),
                                  SizedBox(width: 10),
                                  Text('System'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<ThemeMode>(
                              value: ThemeMode.light,
                              child: Row(
                                children: [
                                  Icon(Icons.light_mode_outlined, size: 20),
                                  SizedBox(width: 10),
                                  Text('Light'),
                                ],
                              ),
                            ),
                            const PopupMenuItem<ThemeMode>(
                              value: ThemeMode.dark,
                              child: Row(
                                children: [
                                  Icon(Icons.dark_mode_outlined, size: 20),
                                  SizedBox(width: 10),
                                  Text('Dark'),
                                ],
                              ),
                            ),
                          ],
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            settingsVm.appTheme.name.toUpperCase(),
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color: colorScheme.primary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
