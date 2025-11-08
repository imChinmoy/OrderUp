import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

abstract class LocationDataSource {
  Future<Map<String, String>> getCurrentCityAndCountry();
}

class LocationDataSourceImpl implements LocationDataSource {
  @override
  Future<Map<String, String>> getCurrentCityAndCountry() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return {'city': 'Location Off', 'country': ''};
      }

      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return {'city': 'Unknown', 'country': ''};
        }
      }
      if (permission == LocationPermission.deniedForever) {
        return {'city': 'Unknown', 'country': ''};
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Get placemark info
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        
        String cityName = place.locality ?? 
                         place.subAdministrativeArea ?? 
                         'Unknown';
        
        String areaDetails = [
          if (place.name != null && place.name!.isNotEmpty) place.name,
          if (place.subAdministrativeArea != null && 
              place.subAdministrativeArea!.isNotEmpty) 
            place.subAdministrativeArea,
        ].join(', ');

        return {
          'city': cityName,
          'country': areaDetails,
        };
      } else {
        return {'city': 'Unknown', 'country': ''};
      }
    } catch (e) {
      print("Error getting location: $e");
      return {'city': 'Error', 'country': ''};
    }
  }
}