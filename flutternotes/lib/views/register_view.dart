import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/services/auth/auth_exceptions.dart';
import 'package:flutternotes/services/auth/auth_service.dart';
import '../utilities/error_dialog.dart';

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
              await AuthService.firebase()
                  .createUser(email: email.text, password: password.text);

              AuthService.firebase().currentUser;

              await AuthService.firebase().sendEmailVerification();

              Navigator.of(context).pushNamed(verifyEmailRoute);
            } on WeakPasswordAuthException {
              await showErrorDialog(context, 'Weak Password');
            } on EmailAlreadyInUseAuthException {
              await showErrorDialog(context, 'Email already in use');
            } on InvalidEmailAuthException {
              await showErrorDialog(context, 'Invalid email');
            } on GenericAuthException {
              await showErrorDialog(context, 'Failed to register');
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
