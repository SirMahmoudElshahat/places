import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/providers/user_places.dart';
import 'package:places/widgets/places_list.dart';

class PlacesScreen extends ConsumerWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Places"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "home/addPlace");
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: PlacesList(palces: ref.watch(userPlacesProvider)),
    );
  }
}
