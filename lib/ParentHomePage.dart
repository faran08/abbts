// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:abbts/ChildRegistration.dart';
import 'package:abbts/Globals.dart';
import 'package:abbts/LoginPage.dart';
import 'package:abbts/MyChildren.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class ParentHomePage extends StatefulWidget {
  const ParentHomePage({Key? key}) : super(key: key);

  @override
  State<ParentHomePage> createState() => _ParentHomePageState();
}

class _ParentHomePageState extends State<ParentHomePage> {
  CollectionReference students =
      FirebaseFirestore.instance.collection('StudentsInBus');
  List<String> myChildIDs = [];
  Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> markers = Set();
  CollectionReference locationUpdates =
      FirebaseFirestore.instance.collection('LocationUpdates');
  List<QueryDocumentSnapshot<Object?>> allLocations = [];
  late BitmapDescriptor myIcon;
  List<Map> allLocationsMap = [];
  List<Map> studentsLatestLocations = [];
  late Timer _timer;
  int _start = 120;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  LatLngBounds boundsFromLatLngList(List<LatLng> list) {
    assert(list.isNotEmpty);
    double x0 = 0.0;
    double x1 = 0.0;
    double y0 = 0.0;
    double y1 = 0.0;
    for (LatLng latLng in list) {
      if (x0 == 0.0) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1) y1 = latLng.longitude;
        if (latLng.longitude < y0) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(northeast: LatLng(x1, y1), southwest: LatLng(x0, y0));
  }

  static final CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);

  Future<void> goToSpecificPoint(List<Map> inputData) async {
    markers.clear();
    List<LatLng> tempList = [];
    for (var item in inputData) {
      LatLng temp =
          LatLng(item['locationData'].latitude, item['locationData'].longitude);
      tempList.add(temp);
      setState(() {
        markers.add(Marker(
            position: temp,
            infoWindow: InfoWindow(
              //popup info
              title: item['busRegistrationNumber'],
              snippet: DateFormat('dd MMM kk:mm a').format(
                  DateTime.fromMillisecondsSinceEpoch(
                      item['locationUpdatedAt'].millisecondsSinceEpoch)),
            ),
            icon: myIcon,
            markerId: MarkerId(
              temp.toString(),
            )));
      });
    }
    // GeoPoint tempLoc = inputData[0]['locationData'] as GeoPoint;
    LatLngBounds latLngBounds = boundsFromLatLngList(tempList);
    // CameraPosition tempCameraPosition = CameraPosition(
    //   target: inputLatLng,
    //   zoom: 14.4746,
    // );
    GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newLatLngBounds(latLngBounds, 100));
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _start = 120;
            getUpdatedStudentLocations();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  void getUpdatedStudentLocations() {
    students.where('parentID', isEqualTo: globalParentID).get().then((value) {
      late QuerySnapshot<Object?> valueReceived;
      myChildIDs.clear();
      studentsLatestLocations.clear();
      for (var item in value.docs) {
        myChildIDs.add(item.id);
      }
      for (var item in myChildIDs) {
        locationUpdates
            .where('registeredStudents', arrayContains: item)
            .orderBy('locationUpdatedAt', descending: true)
            .limit(1)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            EasyLoading.show(
                maskType: EasyLoadingMaskType.clear,
                status: 'Loading Student Location',
                indicator: Image.asset(
                  'assets/loading.gif',
                  width: 50,
                ));
            studentsLatestLocations.add(value.docs.first.data() as Map);
            setState(() {
              goToSpecificPoint(studentsLatestLocations);
              EasyLoading.dismiss();
            });
          } else {
            // EasyLoading.dismiss();
          }
        });
      }
    });
  }

  @override
  void initState() {
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration(size: Size(60, 60)), 'assets/bus-icon.png')
        .then((onValue) {
      setState(() {
        myIcon = onValue;
      });
    });
    getUpdatedStudentLocations();

    // locationUpdates
    //     .where('parentID', arrayContains: globalParentID)
    //     .snapshots()
    //     .forEach((element) {
    //   allLocationsMap.clear();
    //   allLocations.clear();
    //   List<String> checkParentsIdRepetition = [];
    //   List<Map> finalData = [];

    //   for (var item in element.docs) {
    //     allLocations.add(item);
    //     // Map temp = {};
    //     // temp = item.data() as Map;
    //     // temp['ownID'] = item.id;
    //     // checkIdData.add(item.id);
    //     allLocationsMap.add(item.data() as Map);
    //   }
    //   allLocationsMap.sort(((a, b) => Timestamp.fromMicrosecondsSinceEpoch(
    //           a['locationUpdatedAt'])
    //       .compareTo(
    //           Timestamp.fromMicrosecondsSinceEpoch(a['locationUpdatedAt']))));
    //   for (var item in allLocationsMap) {
    //     if (!checkParentsIdRepetition.contains(item['parentID'])) {
    //       checkParentsIdRepetition.add(item['parentID']);
    //       finalData.add(item);
    //     } else {}
    //   }
    //   goToSpecificPoint(allLocationsMap).then((value) {
    //     EasyLoading.dismiss();
    //   });
    // });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      appBar: AppBar(
        actions: [
          PopupMenuButton(
              color: secondaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              // add icon, by default "3 dot" icon
              icon: Icon(
                Icons.more_vert,
                color: textColor,
                size: 30,
              ),
              itemBuilder: (context) {
                return [
                  PopupMenuItem<int>(
                      value: 2,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.refresh,
                              color: mainColor,
                            ),
                            Text(
                              "    Refresh Location",
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                  PopupMenuItem<int>(
                      value: 0,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.child_care,
                              color: mainColor,
                            ),
                            Text(
                              "    My Children",
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                  PopupMenuItem<int>(
                      value: 1,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 20, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.logout,
                              color: mainColor,
                            ),
                            Text(
                              "    Log Out",
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((BuildContext context) => MyChildren())));
                } else if (value == 1) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                } else if (value == 2) {
                  getUpdatedStudentLocations();
                }
              })
        ],
        elevation: 0,
        backgroundColor: mainColor,
        title: const Text(
          'Parents Home Page',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: tertiaryColor,
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((BuildContext context) => ChildRegistration())));
          },
          label: Row(
            children: [
              Icon(Icons.app_registration),
              Text('  Register your child')
            ],
          )),
      body: GoogleMap(
        markers: markers,
        mapType: MapType.normal,
        initialCameraPosition: _kGooglePlex,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
