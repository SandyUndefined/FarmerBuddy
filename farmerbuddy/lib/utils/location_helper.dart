import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<String> getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return 'Location Disabled';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return 'Permission Denied';
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return 'Permission Denied Forever';
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
    } catch (e) {
      return 'Error Fetching Location';
    }
  }
}
