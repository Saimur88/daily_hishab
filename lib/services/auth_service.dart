import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  Future<void> initialize() async {
    await _googleSignIn.initialize();
  }

  Future<GoogleSignInAccount?> signInWithGoogle()async{
    try {
      final GoogleSignInAccount account =
          await _googleSignIn.authenticate();
      return account;
    }catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }
  Future<void> signOut () async {
    await _googleSignIn.signOut();
  }


}