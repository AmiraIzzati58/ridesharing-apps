import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController role = TextEditingController();
  final TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 38.0),
            child: Text(
              'Sign Up',
              style: TextStyle(fontSize: 30),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Username'),
                TextFormField(
                  controller: username,
                  decoration:
                  const InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Name'),
                TextFormField(
                  controller: name,
                  decoration:
                  const InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Password'),
                TextFormField(
                  obscureText: true,
                  controller: password,
                  decoration:
                  const InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Email'),
                TextFormField(
                  controller: email,
                  decoration:
                  const InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Role'),
                TextFormField(
                  controller: role,
                  decoration:
                  const InputDecoration(border: OutlineInputBorder()),
                ),
              ],
            ),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
            ),
            onPressed: () async {
              DatabaseReference ref =
              FirebaseDatabase.instance.ref("users").push();

              await ref.set({
                "username": username.text.toString(),
                "password": password.text.toString(),
                "email": email.text.toString(),
                "role": role.text.toString(),
                "name": name.text.toString(),
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Succesfully registered'),
              ));
            },
            child: const Text('REGISTER'),
          ),
        ],
      ),
    );
  }
}
