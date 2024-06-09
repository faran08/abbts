// ignore_for_file: file_names, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:abbts/AddChildToBus.dart';
import 'package:abbts/Globals.dart';
import 'package:abbts/LoginPage.dart';
import 'package:abbts/MyChildren.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import 'ChildRegistration.dart';

class DriverHomePage extends StatefulWidget {
  const DriverHomePage({Key? key}) : super(key: key);

  @override
  State<DriverHomePage> createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  CollectionReference studentsInBus =
      FirebaseFirestore.instance.collection('StudentsInBus');
  CollectionReference locationUpdates =
      FirebaseFirestore.instance.collection('LocationUpdates');
  List<QueryDocumentSnapshot<Object?>> registeredStudents = [];
  bool locationShare = false;
  Location location = Location();

  late bool _serviceEnabled;
  late LocationData _locationData;
  late Timer _timer;
  int _start = 300;

  @override
  void initState() {
    studentsInBus
        .where('busID', isEqualTo: globalBusRegistrationNumber)
        .get()
        .then((value) {
      setState(() {
        registeredStudents.clear();
        registeredStudents = value.docs;
      });
    });
    super.initState();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            _start = 120;
            updateMyLocation({
              'busRegistrationNumber': globalBusRegistrationNumber,
              'driverID': globalParentID,
              'locationUpdatedAt': Timestamp.now(),
            });
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  List<String> getRegisteredStudents(
      List<QueryDocumentSnapshot<Object?>> inputData) {
    List<String> temp = [];
    for (var item in inputData) {
      temp.add(item.id);
    }
    return temp;
  }

  void updateMyLocation(Map<String, dynamic> inputData) async {
    Permission.locationWhenInUse.request().then((value) {
      Permission.locationWhenInUse.isGranted.then((value) async {
        if (value == true) {
          _serviceEnabled = await location.serviceEnabled();
          if (!_serviceEnabled) {
            _serviceEnabled = await location.requestService();
            if (!_serviceEnabled) {
              return;
            }
          }
          location.getLocation().then((value) {
            inputData['locationData'] =
                GeoPoint(value.latitude!, value.longitude!);
            locationUpdates.add(inputData);
          });
        } else {
          openAppSettings();
        }
      });
    });
  }

  List<String> getParentIDList(List<QueryDocumentSnapshot<Object?>> inputData) {
    List<String> tempToReturn = [];
    for (var item in inputData) {
      Map tempMap = item.data() as Map;
      if (tempToReturn.contains(tempMap['parentID']) != true) {
        tempToReturn.add(tempMap['parentID']);
      }
    }
    return tempToReturn;
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
                      value: 0,
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
                              "    Refresh",
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
                if (value == 1) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                } else if (value == 0) {
                  studentsInBus
                      .where('busID', isEqualTo: globalBusRegistrationNumber)
                      .get()
                      .then((value) {
                    setState(() {
                      registeredStudents.clear();
                      registeredStudents = value.docs;
                    });
                  });
                }
              })
        ],
        elevation: 0,
        backgroundColor: mainColor,
        title: Text(
          'Bus No.  ' + globalBusRegistrationNumber,
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
                    builder: ((BuildContext context) => AddChildToBus())));
          },
          label: Row(
            children: [Icon(Icons.add), Text('  Child')],
          )),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: TextButton(
                style: TextButton.styleFrom(
                    enableFeedback: false,
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    primary: Colors.black,
                    backgroundColor: backGrColorText,
                    onSurface: Colors.black,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                onPressed: () {},
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Location Sharing',
                        style: TextStyle(color: textColor, fontSize: 20),
                      ),
                      FlutterSwitch(
                        activeIcon: Icon(
                          Icons.location_on,
                          color: textColor,
                        ),
                        inactiveIcon: Icon(
                          Icons.location_off,
                          color: textColor,
                        ),
                        activeColor: tertiaryColor,
                        inactiveColor: tertiaryColor,
                        activeTextColor: textColor,
                        inactiveTextColor: textColor,
                        width: 100,
                        height: 50.0,
                        valueFontSize: 18.0,
                        toggleSize: 30.0,
                        value: locationShare,
                        borderRadius: 20.0,
                        padding: 10.0,
                        toggleColor: secondaryColor,
                        showOnOff: true,
                        onToggle: (val) {
                          setState(() {
                            locationShare = val;
                            if (locationShare == true) {
                              updateMyLocation({
                                'busRegistrationNumber':
                                    globalBusRegistrationNumber,
                                'driverID': globalParentID,
                                'locationUpdatedAt': Timestamp.now(),
                                'registeredStudents':
                                    getRegisteredStudents(registeredStudents)
                              });
                              startTimer();
                            } else {
                              _timer.cancel();
                            }
                          });
                        },
                      )
                    ],
                  ),
                )),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 0, 0),
            child: Text(
              'Registered Students',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20, color: textColor),
            ),
          ),
          registeredStudents.isNotEmpty
              ? Flexible(
                  child: ListView.builder(
                      itemCount: registeredStudents.length,
                      itemBuilder: ((context, index) {
                        return Padding(
                          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                          child: PhysicalModel(
                            elevation: 8,
                            shadowColor: Colors.black,
                            borderRadius: BorderRadius.circular(20),
                            color: backGrColorText,
                            child: Container(
                              margin: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              width: MediaQuery.of(context).size.width / 1,
                              height: MediaQuery.of(context).size.height / 8,
                              decoration: BoxDecoration(
                                  color: backGrColorText,
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20))),
                              child: Align(
                                alignment: Alignment.center,
                                child: ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text(
                                      registeredStudents[index]['studentName'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: textColor),
                                    ),
                                  ),
                                  subtitle: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        registeredStudents[index]
                                            ['studentRegistrationNumber'],
                                        style: TextStyle(
                                            fontSize: 12, color: textColor),
                                      ),
                                      Text(
                                        registeredStudents[index]['schoolName'],
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      })))
              : Container()
        ],
      ),
    );
  }
}
