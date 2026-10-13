import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:next_chat/app/data/models/user_profile_model.dart';

class FirebaseUserProfileService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  Future<UserProfileModel?> getUserProfile() async {
    final currentUSer = firebaseAuth.currentUser;
    if (currentUSer == null) {
      return null;
    }

    final doc = await firestore.collection('users').doc(currentUSer.uid).get();

    if (!doc.exists) {
      return null;
    }
    return UserProfileModel.fromMap(doc.data()!);
  }

  Stream<UserProfileModel?> watchUserProfile() {
    final user = firebaseAuth.currentUser;

    if (user == null) return Stream.value(null);

    return firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserProfileModel.fromMap(doc.data()!);
    });
  }

  Future<List<UserProfileModel>> getAllUsers() async {
    final currentUSer = firebaseAuth.currentUser;

    final doc = await firestore.collection('users').get();

    final users = doc.docs
        .map((doc) => UserProfileModel.fromMap(doc.data()))
        .where((user) => user.uid != currentUSer?.uid)
        .toList();
    return users;
  }

  Future<void> updateUserProfile({
    required String name,
    String? photoUrl,
  }) async {
    final user = firebaseAuth.currentUser;

    if (user == null) {
      throw Exception('User is not logged in');
    }

    final userRef = firestore.collection('users').doc(user.uid);

    final data = {'name': name.trim()};

    if (photoUrl != null) {
      data['photoUrl'] = photoUrl;
    }

    await userRef.update(data);
  }
}
