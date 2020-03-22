import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

const AUTH_KEY = 'AIzaSyDR26Z3zrFGGVcviA_uWjkCx_F1R9_LENk';

class Auth with ChangeNotifier {

  String _token;
  DateTime _expiryTime;
  String _userId;
  Timer _authTimer;

  bool get isAuth {
    return token!=null;
  }

  String get userId {
    return _userId;
  }

  String get token {
    if (_expiryTime != null && _expiryTime.isAfter(DateTime.now()) && _token!=null)
      return _token;
    else
      return null;
  }

  Future<void> signUp(String email, String password) async {
    const url = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=$AUTH_KEY';
    try {
      final response = await http.post(url, body: json.encode({
        'email' : email,
        'password' : password,
        'returnSecureToken' : true,
      }));
      final data = json.decode(response.body);
      if (data['error'] != null) {
        Fluttertoast.showToast(msg: data['error']['message'].toString());
      }
      _token = data['idToken'];
      _userId = data['localId'];
      _expiryTime = DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));
      logOutAutomatically();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _expiryTime.toIso8601String(),
      });
      prefs.setString("userData", userData);
    } catch (error) {
      Fluttertoast.showToast(msg: "Authentication problem!");
    }
  }

  Future<void> logIn(String email, String password) async {
    const url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$AUTH_KEY';
    try {
      final response = await http.post(url, body: json.encode({
        'email' : email,
        'password' : password,
        'returnSecureToken' : true,
      }));
      final data = json.decode(response.body);
      if (data['error'] != null) {
        Fluttertoast.showToast(msg: data['error']['message'].toString());
      }
      _token = data['idToken'];
      _userId = data['localId'];
      _expiryTime = DateTime.now().add(Duration(seconds: int.parse(data['expiresIn'])));
      logOutAutomatically();
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token' : _token,
        'userId' : _userId,
        'expiryDate' : _expiryTime.toIso8601String(),
      });
      prefs.setString("userData", userData);
    } catch (error) {
      Fluttertoast.showToast(msg: "Authentication problem!");
    }
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryTime = null;
    _authTimer.cancel();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData"); //prefs.clear() removes everything
  }

  void logOutAutomatically() {
    if (_authTimer != null)
      _authTimer.cancel();
    final timeToExpiry = _expiryTime.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), logOut);
  }

  Future<bool> tryAutoLogIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("userData")) {
      return false;
    }
    final extractedUserData = json.decode(prefs.get("userData")) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);
    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryTime = expiryDate;
    notifyListeners();
    logOutAutomatically();
    return true;
  }
}