import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class ProfileRemoteSource {
  Future<void> updateThemeMode({
    required String userId,
    required bool isDarkMode,
  });

  Future<bool> getThemeMode(String userId);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl(this.firestore);

  @override
  Future<void> updateThemeMode({
    required String userId,
    required bool isDarkMode,
  }) async {
    print("Recived $isDarkMode");
    try {
      await firestore.collection('users').doc(userId).update({
        'themeMode': isDarkMode,
      });
    } on FirebaseAuthException catch (e) {
      print("Error:${e}");
    } catch (e) {
      print("Error:${e}");
    }
  }

  @override
  Future<bool> getThemeMode(String userId) async {
    final doc = await firestore.collection('users').doc(userId).get();

    return doc.data()?['themeMode'] ?? false;
  }
}
