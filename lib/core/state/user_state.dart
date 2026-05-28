import 'package:flutter/material.dart';

class UserState with ChangeNotifier {
  // 单例模式，方便非 Widget 类访问
  static final UserState instance = UserState._internal();
  UserState._internal();
  factory UserState() => instance;

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
