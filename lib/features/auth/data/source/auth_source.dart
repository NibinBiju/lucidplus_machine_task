import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lucidplus_machine_task/core/app_errors.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/auth_model.dart';
import 'package:lucidplus_machine_task/features/auth/data/model/user_model.dart';

abstract class AuthSource {
  Future<Either<AppException, UserModel>> userLogin({
    required AuthModel authModel,
  });
  Future<Either<AppException, UserCredential>> userSignUp({
    required AuthModel authModel,
  });
}

class AuthSourceImplementation extends AuthSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  AuthSourceImplementation({required this.firebaseAuth,required this.firestore});

  @override
  Future<Either<AppException, UserModel>> userLogin({
    required AuthModel authModel,
  }) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: authModel.email.trim(),
        password: authModel.password.trim(),
      );

      final uid = credential.user?.uid;
      final doc = await firestore.collection('users').doc(uid).get();

      if (!doc.exists) {
        return Left(AuthException("User profile not found."));
      }

      final userModel = UserModel.fromJson(doc.data()!);

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (e) {
      return Left(AuthException("Something went wrong. Please try again."));
    }
  }

  @override
  Future<Either<AppException, UserCredential>> userSignUp({
    required AuthModel authModel,
  }) async {
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: authModel.email.trim(),
        password: authModel.password.trim(),
      );

      await firestore.collection('users').doc(result.user!.uid).set({
        "uid": result.user!.uid,
        "name": authModel.name,
        "email": authModel.email,
        "createdAt": FieldValue.serverTimestamp(),
        "themeMode": "light",
      });

      return Right(result);
    } on FirebaseAuthException catch (e) {
      return Left(_mapFirebaseError(e));
    } catch (_) {
      return Left(AuthException("Something went wrong. Please try again."));
    }
  }
}

AppException _mapFirebaseError(FirebaseAuthException e) {
  switch (e.code) {
    case 'user-not-found':
      return AuthException("No account found with this email.");

    case 'wrong-password':
      return AuthException("Incorrect password.");

    case 'invalid-email':
      return AuthException("Invalid email address.");

    case 'user-disabled':
      return AuthException("This account has been disabled.");

    case 'too-many-requests':
      return AuthException("Too many attempts. Try again later.");

    default:
      return AuthException("Authentication failed.");
  }
}
