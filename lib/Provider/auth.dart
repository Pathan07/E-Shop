import 'dart:async';
import 'dart:convert';

import 'package:eshop/Models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class Auth with ChangeNotifier {
  String userId = '';
  String token = '';
  DateTime expiryDate = DateTime.now();
  Timer authTimer = Timer(Duration.zero, () {});

  bool get isAuth {
    return validToken.isNotEmpty;
  }

  String get validToken {
    if (expiryDate.isAfter(DateTime.now())) {
      return token;
    }
    return '';
  }

  String get usrID {
    return userId;
  }

  Future<void> authenticate(
      String email, String password, String urlSegment) async {
    final url =
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=YOUR PLATFORM KEY (eg. android api key or IOS api key that is registered in firebase)';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData.containsKey('error')) {
        final errorMessage = responseData['error']['message'] as String;
        throw HttpExcepption(errorMessage);
      }
      token = responseData['idToken'];
      userId = responseData['localId'];
      expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      autoLogout();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode(
        {
          'token': token,
          'userId': userId,
          'expiryDate': expiryDate.toIso8601String(),
        },
      );
      prefs.setString("userData", userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json
        .decode(prefs.getString('userData').toString()) as Map<String, Object>;
    final expiryDateData =
        DateTime.parse(extractedUserData['expiryDate'].toString());
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    token = extractedUserData['token'].toString();
    userId = extractedUserData['userId'].toString();
    expiryDate = expiryDateData;
    notifyListeners();
    autoLogout();
    return true;
  }

  Future<void> signup(String email, String password) async {
    return authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    return authenticate(email, password, 'signInWithPassword');
  }

  Future<void> logout() async {
    token = '';
    userId = '';
    expiryDate = DateTime.now();
    if (authTimer.isActive) {
      authTimer.cancel();
      authTimer = Timer(Duration.zero, () {});
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void autoLogout() {
    if (authTimer.isActive) {
      authTimer.cancel();
    }
    final timeToExpiry = expiryDate.difference(DateTime.now()).inSeconds;
    authTimer = Timer(Duration(seconds: timeToExpiry), logout);
  }
}
