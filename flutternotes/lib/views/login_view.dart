import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutternotes/constants/routes.dart';
import '../utilities/show_error_dialog.dart';

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
                await showErrorDialog(
                  context,
                  'User not found',
                );
              } else if (e.code == 'wrong-password') {
                await showErrorDialog(
                  context,
                  'Wrong password',
                );
              } else {
                await showErrorDialog(
                  context,
                  'Error: ${e.code}',
                );
              }
            } catch (e) {
              await showErrorDialog(
                context,
                'Error: ${e.toString()}',
              );
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
