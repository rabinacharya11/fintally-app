import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:google_sign_in/google_sign_in.dart';

/// Provides authentication functionality using Firebase Auth
class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Stream of auth state changes for the current user
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Returns the current signed-in user or null if not signed in
  User? get currentUser => _firebaseAuth.currentUser;

  /// Returns true if user is currently signed in
  bool get isSignedIn => currentUser != null;

  /// Sign in with email and password
  ///
  /// Returns the User object if successful
  /// Throws FirebaseAuthException if sign-in fails
  Future<UserCredential> signInWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'An error occurred during sign in',
      );
    }
  }

  /// Create a new user account with email and password
  ///
  /// Returns the User object if successful
  /// Throws FirebaseAuthException if registration fails
  Future<UserCredential> createUserWithEmailPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'An error occurred during registration',
      );
    }
  }

  /// Sign in with Google account
  ///
  /// Returns the User object if successful
  /// Throws FirebaseAuthException if sign-in fails

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger the Google authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in flow
        return null;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      return await _firebaseAuth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'An error occurred during Google sign in',
      );
    } catch (e) {
      throw FirebaseAuthException(
        code: 'google_sign_in_failed',
        message: 'Google sign in failed: ${e.toString()}',
      );
    }
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Failed to send password reset email',
      );
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    try {
      // await _googleSignIn.signOut(); // Sign out from Google
      await _firebaseAuth.signOut(); // Sign out from Firebase
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Failed to update display name',
      );
    }
  }

  /// Update user profile photo URL
  Future<void> updatePhotoURL(String photoURL) async {
    try {
      await _firebaseAuth.currentUser?.updatePhotoURL(photoURL);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Failed to update profile photo',
      );
    }
  }

  /// Update user email address
  Future<void> updateEmail(String newEmail) async {
    try {
      await _firebaseAuth.currentUser?.updateEmail(newEmail);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Failed to update email',
      );
    }
  }

  /// Update user password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _firebaseAuth.currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Failed to update password',
      );
    }
  }

  /// Verify current user's email
  Future<void> sendEmailVerification() async {
    try {
      await _firebaseAuth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Failed to send email verification',
      );
    }
  }

  /// Delete the current user account
  Future<void> deleteAccount() async {
    try {
      await _firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Failed to delete account',
      );
    }
  }

  /// Reauthenticate user before sensitive operations
  Future<UserCredential> reauthenticateWithCredential(
    AuthCredential credential,
  ) async {
    try {
      return await _firebaseAuth.currentUser!.reauthenticateWithCredential(
        credential,
      );
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(
        code: e.code,
        message: e.message ?? 'Failed to reauthenticate',
      );
    }
  }
}
