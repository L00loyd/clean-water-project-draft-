import 'package:material_ui/material_ui.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SimpleMapScreen extends StatelessWidget {
  const SimpleMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(3.1390, 101.6869), // Kuala Lumpur
          initialZoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://openstreetmap.org{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app', // Replace with your package name
          ),
        ],
      ),
    );
  }
}
