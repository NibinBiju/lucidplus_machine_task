import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

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
}
