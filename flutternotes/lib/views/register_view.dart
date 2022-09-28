import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:developer' as devtools show log;

import 'package:flutternotes/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
      appBar: AppBar(title: const Text('Register')),
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
                  .createUserWithEmailAndPassword(
                      email: email.text, password: password.text);
              devtools.log(usercredential.toString());
            } on FirebaseAuthException catch (e) {
              if (e.code == 'weak-password') {
                devtools.log('Weak Password');
              } else if (e.code == 'email-already-in-use') {
                devtools.log('Email already in use');
              } else if (e.code == 'invalid-email') {
                devtools.log('Invalid Email');
              }
            }
          },
          child: const Text('Register'),
        ),
        TextButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text('Already resgistered? Login here'))
      ]),
    );
  }
}
