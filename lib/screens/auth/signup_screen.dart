import 'package:daily_hishab/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      body: SafeArea(child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            height: 400,
            child: Card(
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
                        await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: _email.text.trim(),
                          password: _password.text,
                        );
                      } catch (e){
                        debugPrint(e.toString());
                      }
                    },
                    child: Text('Sign Up'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account"),
                      TextButton(
                          onPressed: (){
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const LoginScreen()
                                ));
                          },
                          child: const Text('Log In!'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      )),

    );
  }
}
