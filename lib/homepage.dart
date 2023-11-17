import 'package:flutter/material.dart';
import 'package:flutter_ride/home.dart';
import 'package:flutter_ride/map2.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("UiTM Jasin Ridesharing Mobile Application"),
        backgroundColor: Colors.purple,
        centerTitle: true,
      ),
      body: ListView(
        children: [


          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Column(

                children: [
                  const SizedBox(height: 70),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple, // background
                        onPrimary: Colors.white, // foreground
                        side: BorderSide(width:3, color:Colors.white), //border width and color
                        elevation: 3, //elevation of button
                        shape: RoundedRectangleBorder( //to set border radius to button
                            borderRadius: BorderRadius.circular(30)
                        ),
                        padding: EdgeInsets.all(20),
                        minimumSize: const Size(200, 50),
                        maximumSize: const Size(200, 100),
                      ),
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen())
                        );
                      }, child: const Text("Request Ride")),

                  const SizedBox(height: 70),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.purple, // background
                        onPrimary: Colors.white, // foreground
                        side: BorderSide(width:3, color:Colors.white), //border width and color
                        elevation: 3, //elevation of button
                        shape: RoundedRectangleBorder( //to set border radius to button
                            borderRadius: BorderRadius.circular(30)
                        ),
                        padding: EdgeInsets.all(20),
                        minimumSize: const Size(200, 50),
                        maximumSize: const Size(200, 100),
                      ),
                      onPressed: (){
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => MapScreen())
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ListPageMap())

                        );
                      }, child: const Text("Track Current Location")),



                ],
              ),
            ),
          ),
        ],
      ),

    ); // This trailing comma makes auto-formatting nicer for build methods.
  }
}