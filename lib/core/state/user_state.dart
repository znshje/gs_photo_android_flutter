import 'package:flutter/material.dart';

class UserState with ChangeNotifier {
  String? _username;
  String? _token;
  bool _isLoggedIn = false;

  String? get username => _username;
  String? get token => _token;
  bool get isLoggedIn => _isLoggedIn;

  void login(String username, String token) {
    _username = username;
    _token = token;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _username = null;
    _token = null;
    _isLoggedIn = false;
    notifyListeners();
  }
}
