import 'package:farmerbuddy/providers/user_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettingScreen extends StatefulWidget {
  @override
  _UserSettingScreenState createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
  final _apiKeyController = TextEditingController();
  final _channelIdController = TextEditingController();
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    final settingsProvider =
        Provider.of<UserSettingsProvider>(context, listen: false);
    _apiKeyController.text = settingsProvider.userSettings.thingspeakApiKey;
    _channelIdController.text = settingsProvider.userSettings.channelId;
    _selectedLanguage = settingsProvider.userSettings.language ?? 'en';
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<UserSettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('User Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _apiKeyController,
              decoration:
                  const InputDecoration(labelText: 'Thingspeak API Key'),
              onChanged: (value) {
                settingsProvider.updateThingspeakApiKey(value);
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _channelIdController,
              decoration: const InputDecoration(labelText: 'Channel ID'),
              onChanged: (value) {
                settingsProvider.updateChannelId(value);
              },
            ),
            const SizedBox(height: 20),
            const Text(
              'Language',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedLanguage,
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'hi', child: Text('Hindi')),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedLanguage = value!;
                });
                settingsProvider.updateLanguage(value!);
              },
            ),
          ],
        ),
      ),
    );
  }
}
