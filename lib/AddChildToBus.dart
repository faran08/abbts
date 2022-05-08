// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:abbts/Globals.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddChildToBus extends StatefulWidget {
  const AddChildToBus({Key? key}) : super(key: key);

  @override
  State<AddChildToBus> createState() => AddChildToBusState();
}

class AddChildToBusState extends State<AddChildToBus> {
  CollectionReference studentsInBus =
      FirebaseFirestore.instance.collection('StudentsInBus');
  CollectionReference students =
      FirebaseFirestore.instance.collection('Students');
  GlobalKey<AutoCompleteTextFieldState<String>> schoolKey = GlobalKey();
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController studentRegistrationNumber = TextEditingController();
  TextEditingController studentName = TextEditingController();
  List<QueryDocumentSnapshot<Object?>> schoolSpecificStudents = [];
  List<Map> schoolSpecificStudentsMap = [];
  Widget toShowLoading = Container();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [toShowLoading],
        backgroundColor: mainColor,
        title: Text(
          'Add Children',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: tertiaryColor,
          onPressed: () {
            setState(() {
              toShowLoading = Image.asset("assets/loading.gif");
            });
            for (var item in schoolSpecificStudentsMap) {
              if (item['isSelected'] == true) {
                Map temp = {};
                temp = item;
                temp['busID'] = globalBusRegistrationNumber;
                temp['driverID'] = globalParentID;
                studentsInBus.add(temp).then((value) {
                  students.doc(temp['id']).update({'isRegistered': true});
                  setState(() {
                    schoolSpecificStudentsMap.clear();
                    Navigator.of(context).pop();
                  });
                });
              }
            }
            setState(() {
              toShowLoading = Container();
            });
          },
          label: Row(
            children: [
              Icon(Icons.app_registration),
              Text('  Register Selected')
            ],
          )),
      backgroundColor: secondaryColor,
      body: Column(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child:
                  // ignore: missing_required_param
                  AutoCompleteTextField<String>(
                clearOnSubmit: false,
                decoration: getInputDecoration(
                    'Select School', const Icon(Icons.location_city)),
                itemSorter: (a, b) {
                  return 0;
                },
                itemFilter: (suggestion, input) =>
                    suggestion.toLowerCase().startsWith(input.toLowerCase()),
                itemBuilder: (context, suggestion) => Padding(
                    child: ListTile(
                      leading: Container(
                          child: Center(
                            child: Text(suggestion[0],
                                style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            // The child of a round Card should be in round shape
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [
                              Colors.blue[900]!,
                              Colors.purple[800]!
                            ]),
                          )),
                      title: Text(
                        suggestion,
                        style: const TextStyle(fontSize: 15),
                      ),
                    ),
                    padding: const EdgeInsets.all(5.0)),
                style: TextStyle(fontSize: 18, color: textColor),
                key: schoolKey,
                suggestions: schools,
                controller: schoolNameController,
                itemSubmitted: (item) {
                  setState(() {
                    schoolNameController.text = item;
                  });
                },
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    primary: Colors.black,
                    backgroundColor: tertiaryColor,
                    onSurface: Colors.black,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                onPressed: () {
                  toShowLoading = Image.asset("assets/loading.gif");
                  students
                      .where('schoolName', isEqualTo: schoolNameController.text)
                      .where('isRegistered', isEqualTo: false)
                      .get()
                      .then((value) {
                    setState(() {
                      schoolSpecificStudentsMap.clear();
                      toShowLoading = Container();
                      for (var item in value.docs) {
                        Map temp = {};
                        temp = item.data() as Map;
                        temp['isSelected'] = false;
                        temp['id'] = item.id;
                        schoolSpecificStudentsMap.add(temp);
                      }
                    });
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                  child: Text(
                    'Search Children',
                    style: TextStyle(color: textColor, fontSize: 20),
                  ),
                )),
          ),
          Flexible(
              child: schoolSpecificStudentsMap.isNotEmpty
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: ListView.builder(
                        itemCount: schoolSpecificStudentsMap.length,
                        itemBuilder: ((context, index) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: PhysicalModel(
                              elevation: 1,
                              shadowColor: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              color: backGrColorText,
                              child: Container(
                                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                width: MediaQuery.of(context).size.width / 1,
                                decoration: BoxDecoration(
                                    color: backGrColorText,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20))),
                                child: ListTile(
                                  trailing: Checkbox(
                                      checkColor: textColor,
                                      activeColor: tertiaryColor,
                                      value: schoolSpecificStudentsMap[index]
                                          ['isSelected'],
                                      onChanged: (value) {
                                        setState(() {
                                          if (schoolSpecificStudentsMap[index]
                                                  ['isSelected'] ==
                                              true) {
                                            schoolSpecificStudentsMap[index]
                                                ['isSelected'] = false;
                                          } else {
                                            schoolSpecificStudentsMap[index]
                                                ['isSelected'] = true;
                                          }
                                        });
                                      }),
                                  title: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        schoolSpecificStudentsMap[index]
                                            ['studentName'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: textColor),
                                      ),
                                      Text(
                                        schoolSpecificStudentsMap[index]
                                            ['studentRegistrationNumber'],
                                        style: TextStyle(color: textColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    )
                  : ListTile(
                      title: Padding(
                        padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          'No Student Registered or Search Not Initiated',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: textColor),
                        ),
                      ),
                    ))
        ],
      ),
    );
  }
}
