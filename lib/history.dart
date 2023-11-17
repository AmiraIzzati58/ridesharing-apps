import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class HistoryListing extends StatefulWidget {
  const HistoryListing({super.key});

  @override
  State<HistoryListing> createState() => _HistoryListingState();
}

class _HistoryListingState extends State<HistoryListing> {
  @override
  Widget build(BuildContext context) {
    final a = FirebaseDatabase.instance
        .ref('ride')
        .orderByChild('passengerId')
        .equalTo(sp?.getString("key"));

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        title: const Text('Ride History'),
      ),
      body: Column(children: <Widget>[
        Flexible(
          child: FirebaseAnimatedList(
              query: a,
              itemBuilder: (_, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                var value = Map<String, dynamic>.from(snapshot.value as Map);
                var origin = value["origin"];
                var destination = value["destination"];
                var status = value["status"];
                var passengerId = value["passengerId"];
                var keyRide =snapshot.key;//value["key"];//a?.getString("key");// sp?.getString("key");
                var driver = value["driverId"] ?? 'PENDING DRIVER';
                //  DatabaseReference reference = FirebaseDatabase.instance.ref().child('Students');

                print(snapshot.value);
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            "PassengerId : " + passengerId,
                            style: TextStyle(color: Colors.amber),
                          ),
                        ),
                        Text("Origin : " + origin),
                        Text("Destination : " + destination),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: Text(
                                "Status : " + status,
                                style: TextStyle(
                                  color: status == "PENDING"
                                      ? Colors.blue
                                      : Colors.green,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 18.0),
                              child: InkWell(
                                onTap: (){

                                  showDialog(

                                      builder: (ctxt) {
                                        return AlertDialog(
                                            insetPadding: EdgeInsets.zero,
                                            title: Text("Alert"),
                                            content: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text("Do you Really want to delete?"),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    MaterialButton(
                                                      child: Text("Cancel"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                    MaterialButton(
                                                      child: Text("Yes"),
                                                      onPressed: () {
                                                        FirebaseDatabase.instance.ref()
                                                            .child('ride')
                                                            .child(keyRide!)
                                                            .remove();
                                                        Navigator.pop(context);
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ));
                                      },
                                      context: context);


                                },
                                child: Container(
                                  padding :new EdgeInsets.symmetric(horizontal: 5.0,vertical: 5),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  child: Text("Delete",style: TextStyle(
                                    color: Colors.white,
                                  ),),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ],
                    ),

                  ),
                );
              }),
        )
      ]),
    );
  }
}
