class UserSettings {
  String thingspeakApiKey;
  String channelId;
  DateTime? cropDate;
  String? language;
  String? cropType; // Added cropType property

  UserSettings({
    this.thingspeakApiKey = '',
    this.channelId = '',
    this.cropDate,
    this.language = 'en',
    this.cropType, // Initialize as null by default
  });
}
