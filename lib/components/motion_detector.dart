import 'package:sensors_plus/sensors_plus.dart';

class MotionDetector {
  bool _isMotionDetected = false;
  final double _threshold = 10;

  void initMotionDetection({Function(bool)? onMotionDetected}) {
    accelerometerEvents.listen((AccelerometerEvent event) {
      if (event.x.abs() > _threshold ||
          event.y.abs() > _threshold ||
          event.z.abs() > _threshold) {
        _isMotionDetected = true;
        onMotionDetected?.call(true);
      } else {
        _isMotionDetected = false;
        onMotionDetected?.call(false);
      }
    });
  }

  bool get isMotionDetected => _isMotionDetected;
}
