import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ride/driver_history.dart';
import 'package:flutter_ride/search_autocomplete_screen.dart';
import 'package:flutter_ride/user_details.dart';

import 'history.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final TextEditingController _pickup = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.white,
      primary: const Color(0xff7B1FA2),
      minimumSize: Size(MediaQuery.of(context).size.width * 0.20,
          MediaQuery.of(context).size.height * 0.02),
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.07,
          vertical: MediaQuery.of(context).size.height * 0.02),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.purple,
        backgroundColor: Colors.purple,
        title: const Text('Driver'),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Succesfully logged out'),
            ));
          },
          child: const Text(
            "LOG OUT",
            style: TextStyle(color: Colors.white),
          ),
        ),
        actions: <Widget>[
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.people_rounded),
            tooltip: 'View Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const UserDetailsScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: MediaQuery.of(context).size.height * 0.065),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 240,
                    height: 60,
                    child: TextField(
                      controller: _pickup,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                SearchAutoCompleteScreen(_pickup)));
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Origin',
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          const SizedBox(
            height: 80.0,
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriverHistory(
                    origin: _pickup.text.toString(),
                  ),
                ),
              );
            },
            child: const Text('FIND REQUEST'),
          ),
        ],
      ),
    );
  }
}
