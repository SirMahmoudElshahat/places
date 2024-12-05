import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:places/models/place.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  PlaceLocation _placeLocation = PlaceLocation(
    latitude: 30.0330,
    longitude: 31.2330,
    address: 'Cairo, Egypt',
  );
  LatLng _selectedLocation = const LatLng(30.0330, 31.2330);

  void _saveNewLocation() {
    Navigator.pop(context, _selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = ModalRoute.of(context)?.settings.name;

    if (currentRoute == 'home/placeDetail/map') {
      _placeLocation =
          ModalRoute.of(context)!.settings.arguments as PlaceLocation;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(currentRoute == 'home/addPlace/selectYourLocation'
            ? 'Select Your Location'
            : 'Your Location'),
        actions: [
          if (currentRoute == 'home/addPlace/selectYourLocation')
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveNewLocation,
            ),
        ],
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: currentRoute == 'home/addPlace/selectYourLocation'
            ? _widgetLocationUnSelected()
            : _widgetLocationSelected(),
      ),
    );
  }

  Widget _widgetLocationUnSelected() {
    return FlutterMap(
      options: MapOptions(
        initialCenter: _selectedLocation,
        initialZoom: 14.7,
        onTap: (tapPosition, point) {
          setState(() {
            _selectedLocation = point;
          });
        },
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: _selectedLocation,
              width: 30,
              height: 30,
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 30,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _widgetLocationSelected() {
    return FlutterMap(
      options: MapOptions(
        initialCenter:
            LatLng(_placeLocation.latitude, _placeLocation.longitude),
        initialZoom: 14.7,
      ),
      children: [
        TileLayer(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: const ['a', 'b', 'c'],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: LatLng(_placeLocation.latitude, _placeLocation.longitude),
              child: const Icon(
                Icons.location_pin,
                color: Colors.red,
                size: 30,
              ),
              width: 30,
              height: 30,
            ),
          ],
        ),
      ],
    );
  }
}
