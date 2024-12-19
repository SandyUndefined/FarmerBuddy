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
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    final settingsProvider =
        Provider.of<UserSettingsProvider>(context, listen: false);
    _apiKeyController.text = settingsProvider.userSettings.thingspeakApiKey;
    _channelIdController.text = settingsProvider.userSettings.channelId;
    _selectedDate = settingsProvider.userSettings.cropDate;
  }

  void _selectDate(BuildContext context) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
      Provider.of<UserSettingsProvider>(context, listen: false)
          .updateCropDate(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Provider.of<UserSettingsProvider>(context, listen: false)
                    .updateThingspeakApiKey(value);
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _channelIdController,
              decoration: const InputDecoration(labelText: 'Channel ID'),
              onChanged: (value) {
                Provider.of<UserSettingsProvider>(context, listen: false)
                    .updateChannelId(value);
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Crop Date: ${_selectedDate != null ? _selectedDate!.toLocal().toString().split(' ')[0] : 'Not set'}',
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  child: const Text('Select Date'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
