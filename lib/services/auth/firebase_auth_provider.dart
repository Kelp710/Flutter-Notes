import 'auth_user.dart';
import 'auth_exceptions.dart';
import 'auth_provider.dart';

import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, FirebaseAuthException;

class FirebaseAuthProvider implements AuthProvider {
  @override
  AuthUser? get currentUser {
    return FirebaseAuth.instance.currentUser == null
        ? null
        : AuthUser.fromUser(FirebaseAuth.instance.currentUser!);
  }

  @override
  Future<AuthUser> LogIn({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return AuthUser.fromUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw UserNotFoundAuthException(e.code);
    }
  }

  @override
  Future<AuthUser> RegisterUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = currentUser;
      if (user != null) {
        return user;
      } else {
        throw UserNotLoggedInAuthException('User not logged in');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw WeakPasswordAuthException(e.message.toString());
      } else if (e.code == 'email-already-in-use') {
        throw EmailAlreadyInUseAuthException(e.message.toString());
      } else if (e.code == 'invalid-email') {
        throw InvalidEmailAuthException(e.message.toString());
      } else {
        throw GenericAuthException(e.message.toString());
      }
    } catch (_) {
      throw GenericAuthException(_.toString());
    }
  }

  @override
  Future<void> LogOut() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseAuth.instance.signOut();
    } else {
      throw UserNotLoggedInAuthException('User not logged in');
    }
  }

  @override
  Future<void> SendEmailVerification() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.sendEmailVerification();
    }
  }
}
