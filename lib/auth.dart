import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signIn({
    // Sign in to your user with email and password
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // Future<void> signUp({
  //   // Create a user with email and password
  //   required String email,
  //   required String password,
  // }) async {
  //   await _firebaseAuth.createUserWithEmailAndPassword(
  //     email: email.trim(),
  //     password: password.trim(),
  //   );
  // }

  Future<void> signOut() async {
    // Sign out from your user
    await _firebaseAuth.signOut();
  }

  // Future<void> sendPasswordResetEmail({
  //   // Send a password reset to your email
  //   required String email,
  // }) async {
  //   await _firebaseAuth.sendPasswordResetEmail(email: email);
  // }
}
