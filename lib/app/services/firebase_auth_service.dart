import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<UserCredential> loginUser({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    debugPrint("CREDENTIAL  LOGIN USER $credential ");
    return credential;
  }

  Future<void> registorUser({
    required String email,
    required String password,
    required String name,
  }) async {
    final credentials = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final userUID = credentials.user?.uid;
    await _firebaseFirestore.collection('users').doc(userUID).set({
      'uid': userUID,
      'name': name,
      'email': email,
      'photoUrl': null,
      'isOnline': false,
      'lastSeen': null,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> logoutUser() async {
    await _firebaseAuth.signOut();
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();
}
