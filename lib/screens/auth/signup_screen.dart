import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Sign Up'),
        centerTitle: true,
      ),
      body: SafeArea(child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  obscureText: true,

                ),
                const SizedBox(height: 20,),

                ElevatedButton(onPressed: (){
                },
                    child: Text('Sign Up'))
              ],
            ),
          ),
        ),
      )),

    );
  }
}
