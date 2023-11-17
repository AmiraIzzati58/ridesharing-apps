import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'main.dart';

class DriverHistory extends StatefulWidget {
  final String origin;
  const DriverHistory({required this.origin, super.key});

  @override
  State<DriverHistory> createState() => _DriverHistoryState();
}

class _DriverHistoryState extends State<DriverHistory> {
  @override
  Widget build(BuildContext context) {
    final a = FirebaseDatabase.instance
        .ref('ride')
        .orderByChild('origin')
        .equalTo(widget.origin);

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
            itemBuilder: (_, DataSnapshot snapshot, Animation<double> animation,
                int index) {
              print(snapshot.key);
              var value = Map<String, dynamic>.from(snapshot.value as Map);
              var origin = value["origin"];
              var destination = value["destination"];
              var status = value["status"];
              var passengerId = value["passengerId"];
              var driver = value["driverId"] ?? 'PENDING DRIVER';

              var key = snapshot.key;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  trailing: status == "PENDING"
                      ? IconButton(
                          color: Colors.black,
                          icon: const Icon(Icons.approval),
                          tooltip: 'Accept',
                          onPressed: () async {
                            DatabaseReference ref =
                                FirebaseDatabase.instance.ref("ride/$key");
                            await ref.update({
                              "status": "ONGOING",
                              "driverId": sp?.getString('key'),
                            });

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Succesfully updated details'),
                            ));
                          },
                        )
                      : IconButton(
                          color: Colors.black,
                          icon: const Icon(Icons.done),
                          tooltip: 'RIDE COMPLETED',
                          onPressed: () {},
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
                      if (driver != 'PENDING DRIVER' &&
                          driver == sp?.getString("key").toString())
                        GestureDetector(
                          onTap: () async {
                            DatabaseReference ref =
                                FirebaseDatabase.instance.ref("ride/$key");
                            await ref.update({
                              "status": "COMPLETED",
                            });

                            Navigator.pop(context);

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Succesfully completed ride'),
                            ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Text(
                              "COMPLETED",
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ]),
    );
  }
}
