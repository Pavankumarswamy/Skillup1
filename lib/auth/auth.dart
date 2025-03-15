import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // Send email verification link
  Future<void> sendEmailVerificationLink() async {
    try {
      User? user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      } else if (user == null) {
        throw Exception("No user is logged in.");
      } else {
        throw Exception("Email is already verified.");
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseAuthError(e));
    } catch (e) {
      throw Exception("An unexpected error occurred: ${e.toString()}");
    }
  }

  // Sign up with email and password
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send email verification automatically after sign-up
      await userCredential.user?.sendEmailVerification();

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseAuthError(e));
    } catch (e) {
      throw Exception("An unexpected error occurred: ${e.toString()}");
    }
  }

  // Log in with email and password
  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Refresh user data
      await userCredential.user?.reload();

      // Check if email is verified
      if (!userCredential.user!.emailVerified) {
        throw Exception("Email is not verified. Please verify your email.");
      }

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseAuthError(e));
    } catch (e) {
      throw Exception("An unexpected error occurred: ${e.toString()}");
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(_handleFirebaseAuthError(e));
    } catch (e) {
      throw Exception("An unexpected error occurred: ${e.toString()}");
    }
  }

  // Log out with session removal
  Future<void> logout() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await _database.ref("users/${user.uid}/session").remove();
      }
      await _auth.signOut();
    } catch (e) {
      throw Exception("Failed to log out: ${e.toString()}");
    }
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Private method to handle Firebase Auth errors
  String _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return "The email address is not valid.";
      case 'user-disabled':
        return "The user account has been disabled.";
      case 'user-not-found':
        return "No user found with this email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'email-already-in-use':
        return "The email is already registered.";
      case 'weak-password':
        return "The password is too weak. Please choose a stronger one.";
      case 'operation-not-allowed':
        return "This operation is not allowed. Contact support.";
      default:
        return "An unknown error occurred: ${e.message}";
    }
  }
}
