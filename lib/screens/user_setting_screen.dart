import 'package:farmerbuddy/providers/user_settings_provider.dart';
import 'package:farmerbuddy/utils/constants.dart';
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
  String? _selectedCrop; // Stores the selected crop
  DateTime? _selectedDate; // Stores the selected crop date

  @override
  void initState() {
    super.initState();
    final settingsProvider =
        Provider.of<UserSettingsProvider>(context, listen: false);
    _apiKeyController.text = settingsProvider.userSettings.thingspeakApiKey;
    _channelIdController.text = settingsProvider.userSettings.channelId;
    _selectedLanguage = settingsProvider.userSettings.language ?? 'en';
    _selectedCrop = settingsProvider.userSettings.cropType;

    // Ensure the selected crop matches a value in the cropList
    if (_selectedCrop != null && !cropList.contains(_selectedCrop)) {
      _selectedCrop = null;
    }
    _selectedDate = settingsProvider.userSettings.cropDate;
  }

  Future<void> _pickDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
      Provider.of<UserSettingsProvider>(context, listen: false)
          .updateCropDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<UserSettingsProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('User Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              const SizedBox(height: 20),
              const Text(
                'Crop Type',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedCrop,
                isExpanded: true,
                items: cropList
                    .map((crop) =>
                        DropdownMenuItem(value: crop, child: Text(crop)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCrop = value;
                  });
                  settingsProvider.updateCropType(value!);
                },
                decoration: InputDecoration(
                  labelText: 'Select Crop',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Crop Date',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate != null
                          ? _selectedDate!.toLocal().toString().split(' ')[0]
                          : 'No date selected',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Select Date'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
