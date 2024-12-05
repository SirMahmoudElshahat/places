import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:places/models/place.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  LatLng? _pickedLocation;
  bool _isGettingLocation = false;
  final MapController _mapController = MapController();

  void _selectOnMap() async {
    final selectedLocation = await Navigator.pushNamed(
      context,
      'home/addPlace/selectYourLocation',
    );
    setState(() {
      _isGettingLocation = true;
    });
    if (selectedLocation != null) {
      setState(() {
        _pickedLocation = selectedLocation as LatLng;
      });
      String? address = await _getAddressFromCoordinates(
          _pickedLocation!.latitude, _pickedLocation!.longitude);
      widget.onSelectLocation(PlaceLocation(
        latitude: _pickedLocation!.latitude,
        longitude: _pickedLocation!.longitude,
        address: address!,
      ));
    }
    try {
      _mapController.move(_pickedLocation!, 15.0);
    } catch (e) {
    } finally {
      setState(() {
        _isGettingLocation = false;
      });
    }
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    setState(() {
      _pickedLocation = LatLng(locationData.latitude!, locationData.longitude!);
      _isGettingLocation = false;
    });

    String? address = await _getAddressFromCoordinates(
        locationData.latitude!, locationData.longitude!);

    widget.onSelectLocation(PlaceLocation(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        address: address!));

    _mapController.move(_pickedLocation!, 15.0);
  }

  Future<String?> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<geocoding.Placemark> placemarks =
          await geocoding.placemarkFromCoordinates(latitude, longitude);
      if (placemarks.isNotEmpty) {
        geocoding.Placemark place = placemarks.first;
        return "${place.street}";
      } else {
        return "No address found!";
      }
    } catch (e) {
      return "Error: $e";
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget mapContent = Text(
      'No location chosen',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
    );

    if (_isGettingLocation) {
      mapContent = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_pickedLocation != null) {
      mapContent = FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _pickedLocation!,
          initialZoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _pickedLocation ?? const LatLng(0, 0),
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

    return Column(
      children: [
        Container(
          height: 150,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
            ),
          ),
          child: mapContent,
        ),
        const SizedBox(
          height: 6,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: const Text(
                'Get Current Location',
                style: TextStyle(fontSize: 11),
              ),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              label: const Text(
                'Select on Map',
                style: TextStyle(fontSize: 11),
              ),
              icon: const Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
