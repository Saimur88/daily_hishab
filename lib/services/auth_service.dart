import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  AuthService({
    FirebaseAuth? auth,
    FirebaseFirestore? db,
    GoogleSignIn? googleSignIn,
  }) : _auth = auth ?? FirebaseAuth.instance,
       _db = db ?? FirebaseFirestore.instance,
       _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  final GoogleSignIn _googleSignIn;

  bool _initialized = false;

  /// Call once in main() before runApp (you already do this).
  Future<void> initialize() async {
    if (_initialized) return;

    await _googleSignIn.initialize(
      // In 7.x, Android requires serverClientId for ID token flows
      serverClientId:
          '513587967590-h5ra0m19liii6qr0h26hiertb5781nhp.apps.googleusercontent.com',
    );

    _initialized = true;
  }

  Future<UserCredential> signInWithGoogle() async {
    if (!_initialized) {
      // fails fast; prevents “works sometimes” bugs
      throw StateError(
        'AuthService.initialize() must be called before sign-in.',
      );
    }

    // On Android/iOS this should work. (Web has different UX requirements.)
    final GoogleSignInAccount googleAccount = await _googleSignIn
        .authenticate();

    final GoogleSignInAuthentication googleAuth =
        await googleAccount.authentication;

    final OAuthCredential firebaseCredential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    final UserCredential userCred = await _auth.signInWithCredential(
      firebaseCredential,
    );

    final user = userCred.user;
    if (user == null) {
      throw StateError('FirebaseAuth returned null user after Google sign-in.');
    }

    // Create/update Firestore profile (merge so you don’t wipe future fields)
    await _db.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName,
      'photoUrl': user.photoURL,
      'providerIds': user.providerData.map((p) => p.providerId).toList(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    return userCred;
  }

  Future<void> signOut() async {
    await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
  }
}
