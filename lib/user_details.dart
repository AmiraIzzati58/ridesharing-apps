import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  late String usernameStr, emailStr, passwordStr, nameStr;

  Future<String> key() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('key').toString();
  }

  @override
  initState() {
    super.initState();

    usernameStr = '';
    emailStr = '';
    passwordStr = '';
    nameStr = '';

    FirebaseDatabase.instance
        .ref('users/${sp?.getString('key')}')
        .get()
        .then((snapshot) {
      if (snapshot.exists) {
        var value = Map<String, dynamic>.from(snapshot.value as Map);
        setState(() {
          usernameStr = value["username"];
          emailStr = value["email"];
          passwordStr = value["password"];
          nameStr = value["name"];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController username =
    TextEditingController(text: usernameStr);
    final TextEditingController email = TextEditingController(text: emailStr);
    final TextEditingController password =
    TextEditingController(text: passwordStr);
    final TextEditingController name = TextEditingController(text: nameStr);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text('User profile'),
        actions: <Widget>[
          GestureDetector(
            onTap: () async {
              DatabaseReference ref = FirebaseDatabase.instance
                  .ref("users/${sp?.getString('key')}");
              await ref.update({
                "username": username.text.toString(),
                "password": password.text.toString(),
                "email": email.text.toString(),
                "name": name.text.toString(),
              });

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Succesfully updated details'),
              ));

              Navigator.pop(context);
            },
            child: const Text(
              "Save",
              style: TextStyle(color: Colors.purple),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(children: [
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
                  style: TextStyle(color: Colors.black),
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
                  style: TextStyle(color: Colors.black),
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
        ]),
      ),
    );
  }
}
