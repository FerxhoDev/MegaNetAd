import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProviders with ChangeNotifier {
  User? _user;
  bool _isAuthorized = false;

  User? get user => _user;
  bool get isAuthorized => _isAuthorized;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void setUser(User? user) {
    _user = user;
    notifyListeners();
  }


  AuthProviders() {
    _auth.authStateChanges().listen((User? user) async {
      _user = user;
      if (user != null) {
        await _checkAuthorization(user.email);
      } else {
        _isAuthorized = false;
      }
      notifyListeners();
    });
  }



  Future<void> _checkAuthorization(String? email) async {
    if (email != null) {
      final QuerySnapshot result = await _firestore
          .collection('usersperm')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      _isAuthorized = result.docs.isNotEmpty;
    } else {
      _isAuthorized = false;
    }
  }


  
  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}