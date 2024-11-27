import 'package:flutter/material.dart';
import 'package:places/models/place.dart';

class PlacesDetailScreen extends StatelessWidget {
  const PlacesDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final placeName = ModalRoute.of(context)!.settings.arguments as Place;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          placeName.title,
        ),
      ),
    );
  }
}
