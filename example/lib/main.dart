import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hybrid_map_marker/hybrid_map_marker.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final HybridMapMarker _hybridMapMarker = HybridMapMarker.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: _map(),
      ),
    );
  }

  Widget _map() {
    final position = const LatLng(39.481785683754346, -0.35585001671455546);
    return FutureBuilder<Set<Marker>>(
      future: _createMarkers(),
      builder: (context, snapshot) {
        return GoogleMap(
          compassEnabled: false,
          myLocationButtonEnabled: false,
          markers: snapshot.data ?? {},
          initialCameraPosition: CameraPosition(
            zoom: 17,
            target: position,
          ),
        );
      },
    );
  }

  Widget _locationMarker() {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber,
        shape: .circle,
      ),
      child: Icon(Icons.location_on_outlined, color: Colors.white),
    );
  }

  Widget _svgMarker() {
    return Container(
      margin: const EdgeInsets.all(2),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.amber,
        shape: .circle,
      ),
      child: SvgPicture.asset(
        'assets/user.svg',
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }

  Future<Set<Marker>> _createMarkers() async {
    await _hybridMapMarker.cacheSvg(path: 'assets/user.svg');

    final size = const Size(64, 64);
    final locationIcon = await _hybridMapMarker.createIcon(
      _locationMarker(),
      size: size,
    );
    final svgIcon = await _hybridMapMarker.createIcon(_svgMarker(), size: size);

    return {
      Marker(
        markerId: MarkerId('location'),
        position: const LatLng(39.481785683754346, -0.35585001671455546),
        icon: locationIcon,
      ),
      Marker(
        markerId: MarkerId('svg'),
        position: const LatLng(39.482232741106344, -0.3567805203800181),
        icon: svgIcon,
      ),
    };
  }
}
