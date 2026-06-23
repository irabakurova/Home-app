import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Stream of the current Firebase user (null = signed out).
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

/// Notifier that wraps sign-in / sign-up / sign-out operations.
class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    return FirebaseAuth.instance.currentUser;
  }

  Future<void> signIn(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user;
    });
  }

  Future<void> signUp(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential.user;
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    state = const AsyncData(null);
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, User?>(() => AuthNotifier());
