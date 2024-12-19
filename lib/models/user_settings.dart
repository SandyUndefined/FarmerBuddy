class UserSettings {
  String thingspeakApiKey;
  String channelId;
  DateTime? cropDate;
  String? language = 'en';

  UserSettings({
    this.thingspeakApiKey = '',
    this.channelId = '',
    this.cropDate,
    this.language,
  });
}
