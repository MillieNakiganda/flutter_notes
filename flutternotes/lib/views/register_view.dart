import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

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
      appBar: AppBar(
        title: const Text('Register'),
      ),
      // future builder delays the building of a widget until the future task is accomplished
      body: FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        //nsnapshot has the states of the future task
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return Column(children: [
                TextField(
                  controller: email,
                  keyboardType: TextInputType.emailAddress,
                  decoration:
                      const InputDecoration(hintText: 'Enter your email here'),
                ),
                TextField(
                  controller: password,
                  obscureText: true,
                  autocorrect: false,
                  enableSuggestions: false,
                  decoration: const InputDecoration(
                      hintText: 'Enter your password here'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      final usercredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email.text, password: password.text);
                      print(usercredential);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'weak-password') {
                        print('Weak Password');
                      } else if (e.code == 'email-already-in-use') {
                        print('Email already in use');
                      } else if (e.code == 'invalid-email') {
                        print('Invalid Email');
                      }
                    }
                  },
                  child: const Text('Register'),
                ),
              ]);
            default:
              return const Text('Loading..');
          }
        },
      ),
    );
  }
}
