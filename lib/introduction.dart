import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ride/driver_screen.dart';
import 'package:flutter_ride/home.dart';
import 'package:flutter_ride/homepage.dart';
import 'package:flutter_ride/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroductionScreen extends StatelessWidget {
  const IntroductionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController username = TextEditingController();
    final TextEditingController password = TextEditingController();
    final TextEditingController role = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 38.0),
                child: Text(
                  'UiTM Jasin Ridesharing',
                  style: TextStyle(fontSize: 30),
                ),
              ),
              Image.asset('assets/icons/logo.png'),
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
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                  MaterialStateProperty.all<Color>(Colors.white),
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.purple),
                ),
                onPressed: () async {
                  FirebaseDatabase.instance
                      .ref('users')
                      .orderByChild('username')
                      .equalTo(username.text.toString())
                      .get()
                      .then((snapshot) {
                    if (snapshot.exists) {
                      Map<dynamic, dynamic>? values = snapshot.value as Map?;
                      values?.forEach((key, value) async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('key', key);

                        if (value['role'] == "passenger") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyHomePage(title: '',)),
                          );
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const DriverScreen()),
                          );
                        }
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('User does not exist'),
                      ));
                    }
                  });
                },
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text('LOGIN'),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegisterScreen()),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Text('REGISTER'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
