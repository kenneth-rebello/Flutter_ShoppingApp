import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/models/http_exception.dart';

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;
  Timer authTimer;

  bool get isAuth {
    return token != null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_token != null &&
        _expiryDate != null &&
        _expiryDate.isAfter(DateTime.now())) {
      return _token;
    }
  }

  Future<void> signUp(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCT2AM6bq7n6ZiC5ynCeXIkXTnejOOcgN4";
    final res = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    var data = json.decode(res.body);

    await _authenticate(data);
  }

  Future<void> signIn(String email, String password) async {
    const url =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCT2AM6bq7n6ZiC5ynCeXIkXTnejOOcgN4";
    final res = await http.post(
      url,
      body: json.encode({
        "email": email,
        "password": password,
        "returnSecureToken": true,
      }),
    );

    var data = json.decode(res.body);

    await _authenticate(data);
  }

  Future<void> _authenticate(Map<String, dynamic> data) async {
    if (data['error'] != null) {
      throw HttpException(data['error']['message']);
    } else {
      _token = data['idToken'];
      _userId = data['localId'];
      _expiryDate = DateTime.now().add(
        Duration(seconds: int.parse(data['expiresIn'])),
      );
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'expiryDate': _expiryDate.toIso8601String(),
      });
      prefs.setString('userData', userData);
    }
  }

  Future<bool> autoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) return false;
    final userData =
        json.decode(prefs.getString('userData')) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(userData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) return false;
    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDate = expiryDate;
    autoLogout();
    notifyListeners();
    return true;
  }

  void logout() async {
    if (authTimer != null) {
      authTimer.cancel();
      authTimer = null;
    }
    _token = null;
    _userId = null;
    _expiryDate = null;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    notifyListeners();
  }

  void autoLogout() {
    if (authTimer != null) {
      authTimer.cancel();
    }
    final timeToExpire = _expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeToExpire), logout);
  }
}
