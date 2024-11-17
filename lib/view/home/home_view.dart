import 'package:demo_map/data/data.dart';
import 'package:demo_map/view/home/model/open_route_service_response.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final data = OpenrouteserviceResponse.fromJson(Data.dataJson);

  Position? currentLocation;

  Future<void> fetchDirections() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    currentLocation = await Geolocator.getCurrentPosition();
    setState(() {});
  }

  MapLibreMapController? mapController;

  void _onMapCreated(MapLibreMapController controller) {
    mapController = controller;
  }

  @override
  void initState() {
    super.initState();
    fetchDirections();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const Text('Demo Map',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          centerTitle: true,
        ),
        body: currentLocation != null
            ? MapLibreMap(
                myLocationEnabled: true,
                compassViewPosition: CompassViewPosition.topLeft,
                styleString: 'https://demotiles.maplibre.org/style.json',
                initialCameraPosition: CameraPosition(
                  target: LatLng(
                      currentLocation?.latitude ?? 0,
                      currentLocation?.longitude ??
                          0), // Example: San Francisco
                  zoom: 10.0,
                ),
                onMapCreated: _onMapCreated,
              )
            : const Align(
                alignment: Alignment.center,
                child: Text('No Map Screen Found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600)),
              ),
      ),
    );
  }
}
