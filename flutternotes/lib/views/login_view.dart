import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import 'package:flutternotes/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController email;
  late final TextEditingController password;

  @override
  void initState() {
    email = TextEditingController();
    password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Column(children: [
        TextField(
          controller: email,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(hintText: 'Enter your email here'),
        ),
        TextField(
          controller: password,
          obscureText: true,
          autocorrect: false,
          enableSuggestions: false,
          decoration:
              const InputDecoration(hintText: 'Enter your password here'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              final usercredential = await FirebaseAuth.instance
                  .signInWithEmailAndPassword(
                      email: email.text, password: password.text);
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(noteRoute, (route) => false);
            } on FirebaseAuthException catch (e) {
              //catching specific exceptions
              if (e.code == 'user-not-found') {
                devtools.log('User not found');
              } else {
                if (e.code == 'wrong-password') {
                  devtools.log('Wrong Password');
                }
              }
            } catch (ex) {
              devtools.log('something bad happened');
              devtools.log(ex.runtimeType.toString());
            }
          },
          child: const Text('Login'),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(registerRoute, (route) => false);
            },
            child: const Text('Not resgistered yet? Register here'))
      ]),
    );
  }
}
