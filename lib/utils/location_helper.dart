import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class LocationHelper {
  static Future<Position> getCurrentLocationCoordinates() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }
  // static Future<String> getCurrentLocation() async {
  //   try {
  //     bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //     if (!serviceEnabled) {
  //       return 'Location Disabled. Enable GPS.';
  //     }

  //     LocationPermission permission = await Geolocator.checkPermission();
  //     if (permission == LocationPermission.denied) {
  //       permission = await Geolocator.requestPermission();
  //       if (permission == LocationPermission.denied) {
  //         return 'Permission Denied. Allow location access.';
  //       }
  //     }

  //     if (permission == LocationPermission.deniedForever) {
  //       return 'Permission Denied Forever. Change from settings.';
  //     }

  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     return '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
  //   } catch (e) {
  //     return 'Error Fetching Location: $e';
  //   }
  // }

  static Future<String> getCityName(Position position) async {
    try {
      final url =
          'https://api.bigdatacloud.net/data/reverse-geocode-client?latitude=${position.latitude}&longitude=${position.longitude}&localityLanguage=en';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['city'] ?? 'Unknown City'; // Fallback to 'Unknown City'
      } else {
        throw Exception('Failed to fetch city name');
      }
    } catch (e) {
      return 'Error Fetching City: $e';
    }
  }

  static Future<String> getCurrentLocation() async {
    try {
      final position = await getCurrentLocationCoordinates();
      final city = await getCityName(position);
      return city;
    } catch (e) {
      return 'Error Fetching Location: $e';
    }
  }
}
