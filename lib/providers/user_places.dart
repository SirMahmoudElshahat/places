import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:places/models/place.dart';

class UserPlacesNotifier extends StateNotifier<List<Place>> {
  UserPlacesNotifier() : super([]);

  void addPlace(String title) {
    state = [Place(title: title), ...state];
  }
}

final StateNotifierProvider<UserPlacesNotifier, List<Place>>
    userPlacesProvider = StateNotifierProvider<UserPlacesNotifier, List<Place>>(
  (ref) => UserPlacesNotifier(),
);
