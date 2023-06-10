import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Account"),
              ListTile(
                title: const Text('Account Sync'),
                leading: const Icon(Icons.account_circle),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Notification & Reminders'),
                leading: const Icon(Icons.notifications_active),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Themes'),
                leading: const Icon(Icons.color_lens),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Sync System Calendar Events'),
                leading: const Icon(Icons.calendar_today),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Task Completion Tone'),
                leading: const Icon(Icons.music_note),
                trailing: Switch(value: true, onChanged: (value) {}),
                onTap: () {},
              ),
              const Divider(),
              const SizedBox(
                height: 12,
              ),
              const Text("Date & Time"),
              ListTile(
                title: const Text('First Day of Week'),
                subtitle: const Text("System Default"),
                leading: const Icon(Icons.calendar_today),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Time Format'),
                subtitle: const Text("System Default"),
                leading: const Icon(Icons.timelapse),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Date Format'),
                subtitle: const Text("2023/06/10"),
                leading: const Icon(Icons.date_range),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Due Date'),
                subtitle: const Text("Today"),
                leading: const Icon(Icons.timelapse),
                onTap: () {},
              ),
              const Divider(),
              const SizedBox(
                height: 12,
              ),
              const Text("Task Apperaence Customize"),
              ListTile(
                title: const Text('Time Range Sort'),
                subtitle: const Text("Previous, Today, Future"),
                leading: const Icon(Icons.sort),
                onTap: () {},
              ),
              const Divider(),
              const SizedBox(
                height: 12,
              ),
              const Text("About"),
              ListTile(
                title: const Text('Language'),
                leading: const Icon(Icons.language),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Help Us Translate'),
                leading: const Icon(Icons.translate),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Rate Us'),
                leading: const Icon(Icons.star),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Share App'),
                leading: const Icon(Icons.share),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Feedback'),
                leading: const Icon(Icons.feedback),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Privacy Policy'),
                leading: const Icon(Icons.privacy_tip),
                onTap: () {},
              ),
              ListTile(
                title: const Text('Version: 1.0.0'),
                leading: const Icon(Icons.info),
                onTap: () {},
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
