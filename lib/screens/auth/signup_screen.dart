import 'package:daily_hishab/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:daily_hishab/main.dart';
import 'package:go_router/go_router.dart';



class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {


  final _email = TextEditingController();
  final _password = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.account_balance_wallet,
                        size: 56,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Daily Hishab',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      const Text('Sign up to create an account',style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w300
                      ),),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _email,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Email cannot be empty';
                          }
                          if(!value.contains('@')){
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _password,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return 'Password cannot be empty';
                          }
                          if(value.length < 6){
                            return 'Password must be at least 6 characters';
                          }
                          if(!value.contains(RegExp(r'[a-zA-Z]')) || !value.contains(RegExp(r'[0-9]'))) {
                            return 'Password must contain at least one Alphabet & Number';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                            labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xff181818),
                            minimumSize: Size(200, 40)
                        ),
                        onPressed: () async {
                          if(_formKey.currentState!.validate()) {
                            try {
                              await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: _email.text.trim(),
                                password: _password.text,
                              );
                            } catch (e) {
                              debugPrint(e.toString());
                            }
                          }
                        },
                        child: Text('Sign Up',style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                        ),),
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
                                  thickness: 2,
                                  color: Colors.grey[400],
                                )),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xff181818),
                              minimumSize: Size(200, 40)
                            ),
                              onPressed: () async {
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
                              child: Row(
                                children: [
                                  Image.asset('assets/images/google.png',
                                    height: 20,),
                                  const SizedBox(width: 10,),
                                  const Text('Google',style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),)
                                ],
                              )),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Already have an account?"),
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
