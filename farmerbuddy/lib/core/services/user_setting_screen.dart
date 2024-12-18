import 'package:farmerbuddy/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_settings_provider.dart';

class UserSettingScreen extends StatefulWidget {
  @override
  _UserSettingScreenState createState() => _UserSettingScreenState();
}

class _UserSettingScreenState extends State<UserSettingScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _channelIdController = TextEditingController();

  @override
  void dispose() {
    _apiKeyController.dispose();
    _channelIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userSettingsProvider =
        Provider.of<UserSettingsProvider>(context, listen: false);
    final userSettings = userSettingsProvider.userSettings;

    _apiKeyController.text = userSettings.thingspeakApiKey;
    _channelIdController.text = userSettings.channelId;

    return Scaffold(
      appBar: AppBar(title: Text('User Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            ProfileWidget(),
            SizedBox(height: 20),

            // ThingSpeak API Key
            TextField(
              controller: _apiKeyController,
              decoration: InputDecoration(
                labelText: 'ThingSpeak API Key',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                userSettingsProvider.updateThingspeakApiKey(value);
              },
            ),
            SizedBox(height: 20),

            // Channel ID
            TextField(
              controller: _channelIdController,
              decoration: InputDecoration(
                labelText: 'Channel ID',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                userSettingsProvider.updateChannelId(value);
              },
            ),
            SizedBox(height: 20),

            // Crop Date Picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Crop Date: ${userSettings.cropDate != null ? userSettings.cropDate!.toLocal().toString().split(' ')[0] : 'Not selected'}',
                  style: TextStyle(fontSize: 16),
                ),
                ElevatedButton(
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: userSettings.cropDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      userSettingsProvider.updateCropDate(selectedDate);
                    }
                  },
                  child: Text('Select Date'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
