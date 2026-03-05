import 'package:daily_hishab/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daily_hishab/main.dart';
import 'package:go_router/go_router.dart';


final _email = TextEditingController();
final _password = TextEditingController();


class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 400,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _email,
                        decoration: const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      TextFormField(
                        controller: _password,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        onPressed: () async {
                          try {
                            await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                                  email: _email.text.trim(),
                                  password: _password.text,
                                );
                          } catch (e) {
                            debugPrint(e.toString());
                          }
                        },
                        child: Text('Sign Up'),
                      ),
                      const SizedBox(height: 20),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                                child: Divider(
                                  thickness: 2,
                                  color: Colors.grey[400],
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: const Text('or sign up with'),
                            ),
                            Expanded(
                                child: Divider(
                                  thickness: 1,
                                  color: Colors.grey[400],
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Image.asset('assets/images/google.png',height: 40,),
                            onPressed:() async {
                              try {
                                await authService.signInWithGoogle();
                                if (!context.mounted) return;
                              } catch (e, st) {
                                debugPrint('Google sign-in failed: $e');
                                debugPrintStack(stackTrace: st);

                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Google sign-in failed: $e')),
                                );
                              }
                            },
                          ),
                          IconButton(
                            icon: Image.asset('assets/images/facebook.png',height: 40,),
                            onPressed: (){},),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account"),
                          TextButton(
                            onPressed: () {
                             context.go('/login');
                            },
                            child: const Text('Log In!'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
