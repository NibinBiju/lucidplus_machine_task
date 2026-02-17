import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/user_model.dart';

abstract class ProfileRemoteSource {
  Future<void> updateThemeMode({
    required String userId,
    required bool isDarkMode,
  });

  Future<bool> getThemeMode(String userId);

  Future<Either<String, String>> updateName({
    required String userId,
    required String newName,
  });

  Future<UserModel> fetchUser(String uid);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> updateThemeMode({
    required String userId,
    required bool isDarkMode,
  }) async {
    debugPrint("Recived $isDarkMode");
    try {
      await firestore.collection('users').doc(userId).update({
        'themeMode': isDarkMode,
      });
    } on FirebaseAuthException catch (e) {
      debugPrint("Error:${e}");
    } catch (e) {
      debugPrint("Error:${e}");
    }
  }

  @override
  Future<bool> getThemeMode(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();

    return doc.data()?['themeMode'] ?? false;
  }

  @override
  Future<Either<String, String>> updateName({
    required String userId,
    required String newName,
  }) async {
    try {
      await firestore.collection('users').doc(userId).update({'name': newName});

      return Right("User name updated");
    } on FirebaseAuthException catch (e) {
      debugPrint("Error:${e}");
      return Left("User name updating failed");
    } catch (e) {
      debugPrint("Error:${e}");
      return Left("User name updating failed");
    }
  }

  @override
  Future<UserModel> fetchUser(String uid) async {
    print("UID get:${uid}");
    try {
      final doc = await firestore.collection('users').doc(uid).get();

      if (doc.exists && doc.data() != null) {
        print("Getted");
        return UserModel.fromJson(doc.data()!);
      }
    } on FirebaseAuthException catch (e) {
      print("error:${e}");
    } catch (e) {
      print("error:${e}");
    }

    return UserModel(uid: uid, name: '', email: '', themeMode: false);
  }
}
