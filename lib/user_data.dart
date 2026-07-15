import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  static const String key = "users";

  /// Get all users
  static Future<List<Map<String, String>>> getUsers() async {
    final prefs = await SharedPreferences.getInstance();
    String? data = prefs.getString(key);

    if (data == null) return [];

    List list = jsonDecode(data);
    return list.map((e) => Map<String, String>.from(e)).toList();
  }

  /// Save user
  static Future<void> addUser(
      String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();

    List<Map<String, String>> users = await getUsers();

    users.add({
      "name": name,
      "email": email,
      "password": password,
    });

    await prefs.setString(key, jsonEncode(users));
  }

  /// Check login
  static Future<Map<String, String>?> login(
      String email, String password) async {
    List<Map<String, String>> users = await getUsers();

    try {
      return users.firstWhere(
              (user) =>
          user["email"] == email && user["password"] == password);
    } catch (e) {
      return null;
    }
  }

  /// Check email exists
  static Future<bool> emailExists(String email) async {
    List<Map<String, String>> users = await getUsers();
    return users.any((user) => user["email"] == email);
  }

  static Future<void> loadUsers() async {}
}
