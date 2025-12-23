import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FaceUser {
  final String id;
  final String name;
  final List<double> embedding;

  FaceUser({
    required this.id,
    required this.name,
    required this.embedding,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "embedding": embedding,
      };

  factory FaceUser.fromJson(Map<String, dynamic> json) {
    return FaceUser(
      id: json["id"],
      name: json["name"],
      embedding: List<double>.from(json["embedding"]),
    );
  }
}

class FaceStorage {
  static const _key = "face_users";

  static Future<List<FaceUser>> loadUsers() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];

    final list = jsonDecode(raw) as List;
    return list.map((e) => FaceUser.fromJson(e)).toList();
  }

  static Future<void> saveUsers(List<FaceUser> users) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _key,
      jsonEncode(users.map((e) => e.toJson()).toList()),
    );
  }

  static Future<void> addUser(FaceUser user) async {
    final users = await loadUsers();
    users.add(user);
    await saveUsers(users);
  }

  static Future<void> deleteUser(String id) async {
    final users = await loadUsers();
    users.removeWhere((e) => e.id == id);
    await saveUsers(users);
  }
}
