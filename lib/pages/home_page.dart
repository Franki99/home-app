import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:home_app/components/light_sensor.dart';
import 'package:home_app/components/location_tracker.dart';
import 'package:home_app/components/motion_detector.dart';
import 'package:home_app/services/notification_service.dart';

class HomeMonitorPage extends StatefulWidget {
  @override
  _HomeMonitorPageState createState() => _HomeMonitorPageState();
}

class _HomeMonitorPageState extends State<HomeMonitorPage> {
  final LightSensor _lightSensor = LightSensor();
  final MotionDetector _motionDetector = MotionDetector();
  final LocationTracker _locationTracker = LocationTracker();
  List<FlSpot> _lightData = [];

  @override
  void initState() {
    super.initState();
    _initSensors();
  }

  void _initSensors() {
    _lightSensor.initLightSensor(onLightChanged: _onLightChanged);
    _motionDetector.initMotionDetection(onMotionDetected: _onMotionDetected);
    _locationTracker.initLocationTracking();
  }

  void _onLightChanged(int luxValue) {
    setState(() {
      _lightData.add(FlSpot(_lightData.length.toDouble(), luxValue.toDouble()));
      if (_lightData.length > 20) {
        _lightData.removeAt(0);
      }
    });
    if (luxValue > 1000) {
      NotificationService.showNotification('High Light Level',
          'The current light level is very bright: $luxValue lux');
    }
  }

  void _onMotionDetected(bool isDetected) {
    setState(() {});
    if (isDetected) {
      NotificationService.showNotification('Motion Detected',
          'Significant motion has been detected in your home.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Home Monitor'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildLightSection(),
              SizedBox(height: 20),
              _buildMotionSection(),
              SizedBox(height: 20),
              _buildLocationSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Light Level',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text('Current: ${_lightSensor.currentLuxValue} lux'),
        SizedBox(height: 10),
        Container(
          height: 200,
          child: _lightData.isNotEmpty
              ? LineChart(
                  LineChartData(
                    gridData: FlGridData(show: false),
                    titlesData: FlTitlesData(show: false),
                    borderData: FlBorderData(show: true),
                    minX: 0,
                    maxX: _lightData.length.toDouble(),
                    minY: 0,
                    maxY: _lightData.isNotEmpty
                        ? _lightData
                            .map((spot) => spot.y)
                            .reduce((max, value) => value > max ? value : max)
                        : 1000,
                    lineBarsData: [
                      LineChartBarData(
                        spots: _lightData,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 2,
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                    ],
                  ),
                )
              : Center(child: Text("No light data available")),
        ),
      ],
    );
  }

  Widget _buildMotionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Motion Detection',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(_motionDetector.isMotionDetected
            ? 'Motion Detected!'
            : 'No Motion'),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Location',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Text(_locationTracker.currentPosition != null
            ? 'Lat: ${_locationTracker.currentPosition!.latitude}, Lon: ${_locationTracker.currentPosition!.longitude}'
            : 'Location not available'),
      ],
    );
  }
}
