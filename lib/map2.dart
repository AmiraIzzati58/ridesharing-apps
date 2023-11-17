
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:flutter_polyline_points/flutter_polyline_points.dart';

import 'package:location/location.dart' as loc;
//import 'package:location/location.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';


import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class ListPageMap extends StatefulWidget {
  const ListPageMap({ Key? key }) : super(key: key);

  @override
  _ListPageMapState createState() => _ListPageMapState();
}

class _ListPageMapState extends State<ListPageMap> {

  Completer<GoogleMapController> _controller = Completer();
  double zoomVal=500.0;
  Set<Marker> _markers = {};
  var selectedDistance;
  var selectedLat;
  var selectedLog;
  late List ridesharingdata=[];


  //final Completer<GoogleMapController?> _controller = Completer();
  Map<PolylineId, Polyline> polylines = {};
  // PolylinePoints polylinePoints = PolylinePoints();
  //Location location = Location();
  Marker? sourcePosition, destinationPosition;
  //loc.LocationData? _currentPosition;
  LatLng curLocation = LatLng(2.2254069, 102.4539467);//(23.0525, 72.5667);
  StreamSubscription<loc.LocationData>? locationSubscription;


  String? _currentAddress;
  Position? _currentPosition;

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      // _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    _getCurrentPosition();
    // setCustomMarker();
  }

  var _isLoading=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("Track Location"),
          backgroundColor: Colors.purple,
          centerTitle: true,
        ),
        body:Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                GoogleMap(
                    padding: EdgeInsets.only(
                        bottom:MediaQuery.of(context).size.height*0.75),
                    scrollGesturesEnabled: true,
                    zoomGesturesEnabled: true,
                    myLocationButtonEnabled: false,
                    myLocationEnabled: false,
                    mapType: MapType.normal,
                    polylines: Set<Polyline>.of(polylines.values),
                    initialCameraPosition:  CameraPosition(target: curLocation, zoom: 12),
                    gestureRecognizers: < Factory < OneSequenceGestureRecognizer >> {
                      Factory < OneSequenceGestureRecognizer > (
                            () =>  EagerGestureRecognizer(),
                      ),
                    },
                    onMapCreated: (GoogleMapController controller) async{
                      //final GoogleMapController controller = await _controller.future;
                      _markers.add(
                          Marker(
                            markerId: MarkerId("cl"),
                            position: curLocation,
                            infoWindow: InfoWindow(title: "Your Location"),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueOrange,
                            ),
                          )
                      );

                      // controller.showMarkerInfoWindow(MarkerId("cl"));
                      _controller.complete(controller);


                    },

                    markers: _markers//{
                  //for (var i = 0; i < 10; i++) {
                  /* Marker(
              markerId: MarkerId('bluehill'),
              position: LatLng(6.1796454,100.5246638),
              infoWindow: InfoWindow(title: 'Blue Hillx'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueViolet,
              ),
            )*/
                  //}

                  // newyork1Marker,newyork2Marker,newyork3Marker,gramercyMarker,bernardinMarker,blueMarker
                  //},
                ),
                /*Positioned(
            top: 30,
            left: 15,
            child: GestureDetector(
              onTap: () {

              },
              child: Icon(Icons.arrow_back),
            ),
          ),*/


                InkWell(
                  onTap: ()async{
                    await _gotoLocation(_currentPosition!.latitude, _currentPosition!.longitude);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin :new EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5),
                      ),
                    ),
                    height: 50,
                    width: 200,
                    child: Text(
                      'Get Current Location',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            )
        )

    ); // This trailing comma makes auto-formatting nicer for build methods.
  }







  httpJob(AnimationController controller) async {
    controller.forward();
    print("delay start");
    await Future.delayed(Duration(seconds: 3), () {});
    print("delay stop");
    controller.reset();
  }















  void _onMapCreated() async{
    _markers.clear();

    for (var i = 0; i < ridesharingdata.length; i++) {
      print("ooooootttooooooo");
      print(ridesharingdata[i]['rsID']);
      setState(() {

        _markers.add(
            Marker(
              markerId: MarkerId(ridesharingdata[i]['rsID']),
              position: LatLng(double.parse(ridesharingdata[i]['mapLatitude']),double.parse(ridesharingdata[i]['mapLongitude'])),
              infoWindow: InfoWindow(title: ridesharingdata[i]['rsName']),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueYellow,
              ),
            )
        );
      });
    }
  }

  Future<void> _gotoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;

    controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(lat, long), zoom: 15,tilt: 90.0,
              bearing: 20.0,)));

    setState(() {
      _markers.add(
          Marker(
            markerId: MarkerId("cl"),
            position: LatLng(lat, long),
            infoWindow: InfoWindow(title: "Your Location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          )
      );

    });
    //controller.showMarkerInfoWindow(MarkerId("cl"));

  }





}







/*
Marker gramercyMarker = Marker(
  markerId: MarkerId('gramercy'),
  position: LatLng(40.738380, -73.988426),
  infoWindow: InfoWindow(title: 'Gramercy Tavern'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

Marker bernardinMarker = Marker(
  markerId: MarkerId('bernardin'),
  position: LatLng(6.1796454,100.5246638),
  infoWindow: InfoWindow(title: 'Le Bernardin'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker blueMarker = Marker(
  markerId: MarkerId('bluehill'),
  position: LatLng(6.1796454,100.5246638),
  infoWindow: InfoWindow(title: 'Blue Hillx'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker newyork1Marker = Marker(
  markerId: MarkerId('newyork1'),
  position: LatLng(6.147453, 100.514643),
  infoWindow: InfoWindow(title: 'Los Tacos'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker newyork2Marker = Marker(
  markerId: MarkerId('newyork2'),
  position: LatLng(6.1636668,100.516703),
  infoWindow: InfoWindow(title: 'Tree Bistro'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker newyork3Marker = Marker(
  markerId: MarkerId('newyork3'),
  position: LatLng(6.167789,100.47176278),
  infoWindow: InfoWindow(title: 'Le Coucou'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);*/
