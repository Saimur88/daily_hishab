import 'package:daily_hishab/screens/auth/signup_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _email = TextEditingController();
final _password = TextEditingController();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: SafeArea(child: Center(
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
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    TextFormField(
                      controller: _password,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      obscureText: true,

                    ),
                    const SizedBox(height: 20,),

                    ElevatedButton(
                      onPressed: () async {
                    try{
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: _email.text.trim(),
                        password: _password.text,
                      );
                    } catch (e){
                      debugPrint(e.toString());
                    }
                    },
                        child: Text('Log In'),
                    ),
                    const SizedBox(height: 20,),
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
                            child: const Text('or log in with'),
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
                          onPressed: (){},),
                        IconButton(
                          icon: Image.asset('assets/images/facebook.png',height: 40,),
                          onPressed: (){},),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't Have an Account"),
                        TextButton(
                            onPressed: (){
                              Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (_) => const SignupScreen()
                                  ));
                            },
                            child: const Text('Sign Up!')),

                      ],
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      )),

    );
  }
}
