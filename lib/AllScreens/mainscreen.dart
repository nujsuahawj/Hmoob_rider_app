import 'dart:async';
import 'dart:ffi';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/AllScreens/searchScreen.dart';
import 'package:rider_app/AllWidgets/Divider.dart';
import 'package:rider_app/AllWidgets/progressDialog.dart';
import 'package:rider_app/Assistants/assistantMethods.dart';
import 'package:rider_app/DataHandler/appData.dart';
import 'package:rider_app/Models/directDetails.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class MainScreen extends StatefulWidget {
  static const String idScreen = "mainScreen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  // ignore: unused_field
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  // ignore: unused_field
  late GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  late DirectionDetails tripDirectionDetails;

  // ntawm nos yog polyline hauv day 4
  List<LatLng> pLineCoordinates = [];
  Set<Polyline> polylineSet = {};

  late Position currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingOfMap = 0;

  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  double rideDetailsContainerHeight = 0;
  double searchContainerHeight = 300.0;

  bool drawerOpen = true;

  get colorizeColors => null;
  resetApp() {
    setState(() {
      drawerOpen = true;

      searchContainerHeight = 300.0;
      rideDetailsContainerHeight = 0;
      bottomPaddingOfMap = 230.0;

      polylineSet.clear();
      markersSet.clear();
      circlesSet.clear();
      pLineCoordinates.clear();
    });
    locatePosition();
  }

  void displayRideDetailsContainer() async {
    await getPlaceDirection();
    setState(() {
      searchContainerHeight = 0;
      rideDetailsContainerHeight = 240.0;
      bottomPaddingOfMap = 230.0;
      drawerOpen = false;
    });
  }

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;
    // ignore: unused_local_variable
    LatLng latLatPosition = LatLng(position.latitude, position.longitude);
    // ignore: unused_local_variable
    CameraPosition cameraPosition =
        new CameraPosition(target: latLatPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // ignore: unused_local_variable
    String address =
        await AssistantMethods.searchCoordinateAddress(position, context);
    print("this is your address" + address);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  @override
  Widget build(BuildContext context) {
    var colorizeTextStyle;
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("ໜ້າລັກ"),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png",
                          height: 65.0, width: 65.0),
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "ໂປຣໄຟ",
                            style: TextStyle(
                                fontSize: 16.0, fontFamily: "Brand-Bold"),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text("ເບິ່ງໂປຣໄຟ"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              DividerWidget(),
              SizedBox(
                height: 12.0,
              ),
              ListTile(
                leading: Icon(Icons.history),
                title: Text(
                  "ປະຫວັດການເຂົ້າ",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "ເບິ່ງໂປຣໄຟ",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text(
                  "ຂໍ້ມູນ",
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            polylines: polylineSet,
            markers: markersSet,
            circles: circlesSet,
            onMapCreated: (GoogleMapController controller) {
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 300.0;
              });

              locatePosition();
            },
          ),
          Positioned(
            top: 38.0,
            left: 22.0,
            child: GestureDetector(
              onTap: () {
                if (drawerOpen) {
                  scaffoldKey.currentState!.openDrawer();
                } else {
                  resetApp();
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    (drawerOpen) ? Icons.menu : Icons.close,
                    color: Colors.black,
                  ),
                  radius: 20.0,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: searchContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 6.0,
                      ),
                      Text(
                        "ສະບາຍດີ",
                        style: TextStyle(fontSize: 12.0),
                      ),
                      Text(
                        "ຈະໄປໃສ?",
                        style:
                            TextStyle(fontSize: 20.0, fontFamily: "Brand Bold"),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          // ignore: unused_local_variable
                          var res = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SeachScreen()));
                          if (res == "obtainDirection") {
                            displayRideDetailsContainer();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black54,
                                blurRadius: 6.0,
                                spreadRadius: 0.5,
                                offset: Offset(0.7, 0.7),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                Icon(Icons.search, color: Colors.blueAccent),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text("ຊອກຫາສະຖານທີ"),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 24.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.home,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(
                              //     // ignore: unnecessary_null_comparison
                              //     Provider.of<AppData>(context).pickUpLocation !=
                              //             null
                              //         ? Provider.of<AppData>(context)
                              //             .pickUpLocation
                              //             .placeName
                              //         : "ເພີ່ມໃສ່ໜ້າລັກ"),
                              Text("ເພີ່ມໃສ່ໜ້າລັກ"),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "ທີ່ຢູ່ປະຈຸບັນຂອງທ່ານ",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      DividerWidget(),
                      SizedBox(
                        height: 16.0,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.work,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: 12.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ເພີ່ມໃສ່ວຽກ"),
                              SizedBox(
                                height: 4.0,
                              ),
                              Text(
                                "ທີ່ເຮັດວຽກປະຈຸບັນຂອງທ່ານ",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 12.0),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0.0,
            left: 0.0,
            right: 0.0,
            child: AnimatedSize(
              vsync: this,
              curve: Curves.bounceIn,
              duration: new Duration(milliseconds: 160),
              child: Container(
                height: rideDetailsContainerHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0),
                      topRight: Radius.circular(16.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black,
                      blurRadius: 16.0,
                      spreadRadius: 0.5,
                      offset: Offset(0.7, 0.7),
                    )
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 17.0),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        color: Colors.tealAccent[100],
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [
                              Image.asset(
                                "images/taxi.png",
                                height: 70.0,
                                width: 80.0,
                              ),
                              SizedBox(
                                width: 16.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "car",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontFamily: "Brand-Bold"),
                                  ),
                                  Text(
                                    // ignore: unnecessary_null_comparison
                                    ((tripDirectionDetails != null)
                                        ? tripDirectionDetails.distanceText
                                        : ''),
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.grey),
                                  ),
                                ],
                              ),
                              Expanded(child: Container()),
                              // Text(
                              //   // ignore: unnecessary_null_comparison
                              //   ((tripDirectionDetails != null)
                              //       ? '\$${AssistantMethods.calculateFares(tripDirectionDetails)}'
                              //       : ''),
                              //   style: TextStyle(
                              //     fontFamily: "Brand-Bold",
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          children: [
                            Icon(
                              FontAwesomeIcons.moneyCheckAlt,
                              size: 18.0,
                              color: Colors.black54,
                            ),
                            SizedBox(
                              width: 16.0,
                            ),
                            Text("chash"),
                            SizedBox(
                              width: 6.0,
                            ),
                            Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.black54,
                              size: 16.0,
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 24.0),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          onPressed: () {
                            print("clicked");
                          },
                          color: Theme.of(context).accentColor,
                          child: Padding(
                            padding: EdgeInsets.all(17.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Request",
                                  style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Icon(
                                  FontAwesomeIcons.taxi,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0.5,
                  blurRadius: 16.0,
                  color: Colors.black54,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            height: 250.0,
            child: Column(
              children: [
                SizedBox(
                  height: 12.0,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 0.5,
                  blurRadius: 16.0,
                  color: Colors.black54,
                  offset: Offset(0.7, 0.7),
                ),
              ],
            ),
            height: 150.0,
            child: Column(
              children: [
                SizedBox(
                  height: 12.0,
                ),
                // SizedBox(
                //   width: double.infinity,
                //   // ignore: deprecated_member_use
                //   child: ColorizeAnimatedTextKit(
                //     onTap: () {
                //       print("Tap Event");
                //     },
                //     text: [
                //       "Requestinga dide...",
                //       "Please wait...",
                //       "Finding a driver",
                //     ],
                //     textStyle: TextStyle(
                //       fontSize: 55.0,
                //       fontFamily: "Band-Bold",
                //     ),
                //     colors: [
                //       Colors.green,
                //       Colors.purple,
                //       Colors.pink,
                //       Colors.blue,
                //       Colors.yellow,
                //       Colors.red,
                //     ],
                //     textAlign: TextAlign.center,
                //     // alignment: AlignmentDirectional.topStart,
                //   ),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async {
    // ignore: unused_local_variable
    var initialPos =
        Provider.of<AppData>(context, listen: false).pickUpLocation;
    // ignore: unused_local_variable
    var finalPos = Provider.of<AppData>(context, listen: false).dropOffLocation;
    // ignore: unused_local_variable

    // var pickUpLaptLng = LatLng(initialPos.latitude, initialPos.longitude);
    // var dropOffLatpLng = LatLng(finalPos.latitude, finalPos.longitude);

    showDialog(
        context: context,
        builder: (BuildContext context) =>
            ProgressDialog(message: "plase wait..."));
    // ignore: unused_local_variable
    // var details = await AssistantMethods.obtainPlaceDirectionDetails(
    //     pickUpLaptLng, dropOffLatpLng);
    setState(() {
      // tripDirectionDetails = details;
    });
    Navigator.pop(context);
    print("this is encoded points::");
    // print(details!.encodedPoints);

    // ignore: unused_local_variable
    PolylinePoints polylinePoints = PolylinePoints();
    // ignore: unused_local_variable
    var details;
    // tus var details nos mam ua zoo saib vim tau phog ib cos code lawm
    List<PointLatLng> decodePolyLinePointsResult =
        polylinePoints.decodePolyline(details.encodedPoints);

    pLineCoordinates.clear();

    if (decodePolyLinePointsResult.isNotEmpty) {
      decodePolyLinePointsResult.forEach((PointLatLng pointLatLng) {
        pLineCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      });
    }
    polylineSet.clear();
    setState(() {
      // ignore: unused_local_variable
      Polyline polyline = Polyline(
        color: Colors.pink,
        polylineId: PolylineId("PolylineID"),
        jointType: JointType.round,
        points: pLineCoordinates,
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );
      polylineSet.add(polyline);
    });

    // ignore: unused_local_variable
    LatLngBounds latLngBounds;
    // if (pickUpLatLng.latitude > dropOffLatLng.latitude &&
    //     pickUpLatLng.longitude > dropOffLatLng.longitude) {
    //   latLngBounds =
    //       LatLngBounds(southwest: dropOffLatLng, northeast: pickUpLatLng);
    // } else if (pickUpLatLng.longitude > dropOffLatLng.longitude) {
    //   latLngBounds = LatLngBounds(
    //       southwest: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude),
    //       northeast: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude));
    // } else if (pickUpLatLng.latitude > dropOffLatLng.latitude) {
    //   latLngBounds = LatLngBounds(
    //       southwest: LatLng(dropOffLatLng.latitude, pickUpLatLng.longitude),
    //       northeast: LatLng(pickUpLatLng.latitude, dropOffLatLng.longitude));
    // } else {
    //   latLngBounds =
    //       LatLngBounds(southwest: pickUpLatLng, northeast: dropOffLatLng);
    // }

    // newGoogleMapController
    //     .animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 70));

    // ignore: unused_local_variable
    Marker pickUpLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      infoWindow:
          InfoWindow(title: initialPos.placeName, snippet: "my location"),
      // position: pickUpLatLng,
      markerId: MarkerId("pickUpId"),
    );
    // ignore: unused_local_variable
    Marker dropOffLocMarker = Marker(
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow:
          InfoWindow(title: finalPos.placeName, snippet: "dropOff location"),
      // position: dropOffLatLng,
      markerId: MarkerId("dropOffId"),
    );
    setState(() {
      markersSet.add(pickUpLocMarker);
      markersSet.add(dropOffLocMarker);
    });
    // ignore: unused_local_variable
    Circle pickUpLocCircle = Circle(
      fillColor: Colors.blueAccent,
      // center: pickUpLatLng,
      radius: 12,
      strokeColor: Colors.blueAccent,
      circleId: CircleId("pickUpId"),
    );
    // ignore: unused_local_variable
    Circle dropOffLocCircle = Circle(
      fillColor: Colors.deepPurple,
      // center: dropOffLatLng,
      radius: 12,
      strokeColor: Colors.deepPurple,
      circleId: CircleId("dropOffId"),
    );
    setState(() {
      circlesSet.add(pickUpLocCircle);
      circlesSet.add(dropOffLocCircle);
    });
  }
}
