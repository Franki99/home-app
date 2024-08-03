import 'package:light/light.dart';

class LightSensor {
  late Light _light;
  int _luxValue = 0;

  void initLightSensor({Function(int)? onLightChanged}) {
    _light = Light();
    try {
      _light.lightSensorStream.listen((int luxValue) {
        _luxValue = luxValue;
        onLightChanged?.call(luxValue);
      });
    } on LightException catch (exception) {
      print(exception);
    }
  }

  int get currentLuxValue => _luxValue;
}
