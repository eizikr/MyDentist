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

  Future<UserCredential> signUp({
    // Create a user with email and password
    required String email,
    required String password,
  }) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<void> signOut() async {
    // Sign out from your user
    await _firebaseAuth.signOut();
  }
}

String getCurrentUserId() {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;
  return user!.uid;
}

String getCurrentUserDisplayName() {
  FirebaseAuth auth = FirebaseAuth.instance;
  final User user = auth.currentUser!;
  return user.displayName!;
}
