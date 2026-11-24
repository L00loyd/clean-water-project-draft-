import 'package:flutter/foundation.dart';

import 'water_point.dart';

/// Simple in-memory state shared across screens (no database yet).
/// Data resets when the app restarts.
class PointsStore {
  static final ValueNotifier<List<WaterPoint>> points =
      ValueNotifier<List<WaterPoint>>(List.of(samplePoints));

  static void add(WaterPoint p) => points.value = [...points.value, p];

  /// Points added by the user in this session.
  static List<WaterPoint> get userAdded =>
      points.value.where((p) => p.id.startsWith('user_')).toList();
}

class SavedStore {
  // Pre-filled with two points so the profile screen has something to show.
  static final ValueNotifier<Set<String>> ids =
      ValueNotifier<Set<String>>({'wp1', 'wp4'});

  static bool isSaved(String id) => ids.value.contains(id);

  static void toggle(String id) {
    final next = {...ids.value};
    if (!next.add(id)) next.remove(id);
    ids.value = next;
  }
}

class AppUser {
  final String name;
  final String email;
  const AppUser({required this.name, required this.email});
}

class RegisteredUser {
  final String name;
  final String phone;
  final String password;
  const RegisteredUser({
    required this.name,
    required this.phone,
    required this.password,
  });
}

class UserStore {
  /// null = nobody logged in
  static final ValueNotifier<AppUser?> current = ValueNotifier<AppUser?>(null);

  /// key = lowercase email
  static final Map<String, RegisteredUser> registered = {};

  static bool isRegistered(String email) =>
      registered.containsKey(email.trim().toLowerCase());

  /// Returns the user if email + password match, otherwise null.
  static RegisteredUser? authenticate(String email, String password) {
    final user = registered[email.trim().toLowerCase()];
    if (user == null || user.password != password) return null;
    return user;
  }

  static void login(String email, {String? name}) {
    current.value = AppUser(
      name: name ?? email.split('@').first,
      email: email,
    );
  }

  static void logout() => current.value = null;
}