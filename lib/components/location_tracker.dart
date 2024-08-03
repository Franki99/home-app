import 'package:geolocator/geolocator.dart';

class LocationTracker {
  Position? _currentPosition;

  Future<void> initLocationTracking() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    Geolocator.getPositionStream().listen((Position position) {
      _currentPosition = position;
    });
  }

  Position? get currentPosition => _currentPosition;
}
