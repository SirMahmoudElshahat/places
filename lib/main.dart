import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:places/screens/add_place.dart';
import 'package:places/screens/map.dart';
import 'package:places/screens/places.dart';

import 'screens/places_detail.dart';

final ColorScheme colorScheme = ColorScheme.fromSeed(
  seedColor: const Color.fromARGB(255, 90, 8, 246),
  brightness: Brightness.dark,
);

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter Demo",
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        colorScheme: colorScheme,
        scaffoldBackgroundColor: colorScheme.surface,
        textTheme: GoogleFonts.ubuntuCondensedTextTheme().copyWith(
          titleSmall: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
          titleMedium: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
          titleLarge: GoogleFonts.ubuntuCondensed(fontWeight: FontWeight.bold),
        ),
      ),
      initialRoute: 'home',
      routes: {
        'home': (context) => const PlacesScreen(),
        'home/addPlace': (context) => const AddPlaceScreen(),
        'home/addPlace/selectYourLocation' : (context) => const MapScreen(),
        'home/placeDetail' : (context) => const PlacesDetailScreen(),
        'home/placeDetail/map' : (context) => const MapScreen(),
      },
    );
  }
}
