import 'package:flutter/material.dart';
import '../models/place.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.palces});

  final List<Place> palces;

  @override
  Widget build(BuildContext context) {
    if (palces.isEmpty) {
      return Center(
        child: Text(
          "No places added yet !",
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
      );
    }
    return ListView.builder(
      itemCount: palces.length,
      itemBuilder: (context, index) => ListTile(
        leading: CircleAvatar(
          radius: 25,
          backgroundImage: FileImage(palces[index].image),
        ),
        title: Text(
          palces[index].title,
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        subtitle: Text(
          palces[index].location.address,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
        ),
        onTap: () => Navigator.pushNamed(context, 'home/placeDetail',
            arguments: palces[index]),
      ),
    );
  }
}
