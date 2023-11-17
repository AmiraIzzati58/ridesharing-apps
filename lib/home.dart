import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ride/history.dart';
import 'package:flutter_ride/search_autocomplete_screen.dart';
import 'package:flutter_ride/services/location_services.dart';
import 'package:flutter_ride/user_details.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _pickup = TextEditingController();
  final TextEditingController _destination = TextEditingController();

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
        title: const Text('Home'),
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
          IconButton(
            color: Colors.white,
            icon: const Icon(Icons.history),
            tooltip: 'Booking history',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HistoryListing()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
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
                      decoration: InputDecoration(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Icon(Icons.location_on,
                      size: MediaQuery.of(context).size.height * 0.065),
                ],
              ),
              Column(
                children: [
                  Container(
                    width: 240,
                    height: 60,
                    child: TextField(
                      controller: _destination,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                SearchAutoCompleteScreen(_destination)));
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Destination',
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          const SizedBox(
            height: 80.0,
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.purple),
            ),
            onPressed: () async {
              DatabaseReference ref =
              FirebaseDatabase.instance.ref("ride").push();

              final prefs = await SharedPreferences.getInstance();

              await ref.set({
                "origin": _pickup.text.toString(),
                "destination": _destination.text.toString(),
                "passengerId": prefs.getString('key'),
                "status": "PENDING"
              });

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Succesfully request'),
              ));
            },
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('REQUEST RIDE'),
            ),
          ),
        ],
      ),
    );
  }
}
