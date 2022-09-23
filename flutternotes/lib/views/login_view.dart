import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
    return Column(children: [
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
        decoration: const InputDecoration(hintText: 'Enter your password here'),
      ),
      ElevatedButton(
        onPressed: () async {
          try {
            final usercredential = await FirebaseAuth.instance
                .signInWithEmailAndPassword(
                    email: email.text, password: password.text);
            print(usercredential);
          } on FirebaseAuthException catch (e) {
            //catching specific exceptions
            if (e.code == 'user-not-found') {
              print('User not found');
            } else {
              if (e.code == 'wrong-password') {
                print('Wrong Password');
              }
            }
          } catch (ex) {
            print('something bad happened');
            print(ex.runtimeType);
            print(ex);
          }
        },
        child: const Text('Login'),
      ),
    ]);
  }
}
