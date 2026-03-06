import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../home_screen.dart';
import 'login_screen.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    const spinkit = SpinKitThreeBounce(
      color: Colors.blue,
      size: 50.0,
    );
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot){
          if (snapshot.connectionState == ConnectionState.waiting){
            return Scaffold(
                body:  Center(child: spinkit));
          }
          final user = snapshot.data;
          if (user == null){
            return const LoginScreen();
          }
          return const HomeScreen();
        });
  }
}
