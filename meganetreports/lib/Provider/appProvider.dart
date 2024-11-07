import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProviders with ChangeNotifier {
  User? _user;

  User? get user => _user;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthProviders() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}