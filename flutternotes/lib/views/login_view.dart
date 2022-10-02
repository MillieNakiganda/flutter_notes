import 'package:flutter/material.dart';
import 'package:flutternotes/constants/routes.dart';
import 'package:flutternotes/services/auth/auth_exceptions.dart';
import '../services/auth/auth_service.dart';
import '../utilities/error_dialog.dart';

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
              await AuthService.firebase().logIn(
                email: email.text,
                password: password.text,
              );

              final user = AuthService.firebase().currentUser;

              if (user?.isEmailVerified ?? false) {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil(noteRoute, (route) => false);
              } else {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    verifyEmailRoute, (route) => false);
              }
            } on UserNotFoundAuthException {
              await showErrorDialog(context, 'User not found');
            } on WrongPasswordAuthException {
              await showErrorDialog(context, 'Wrong credentials');
            } on GenericAuthException {
              await showErrorDialog(context, 'Authentication Password');
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
