import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:next_chat/app/data/models/user_profile_model.dart';

class FirebaseUserProfileService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

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

  Future<List<UserProfileModel>> getAllUsers() async {
    final currentUSer = firebaseAuth.currentUser;

    final doc = await firestore.collection('users').get();

    final users = doc.docs
        .map((doc) => UserProfileModel.fromMap(doc.data()))
        .where((user) => user.uid != currentUSer?.uid)
        .toList();
    return users;
  }
}
