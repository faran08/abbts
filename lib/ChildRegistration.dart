// ignore_for_file: prefer_const_constructors

import 'package:abbts/Globals.dart';
import 'package:autocomplete_textfield_ns/autocomplete_textfield_ns.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChildRegistration extends StatefulWidget {
  const ChildRegistration({Key? key}) : super(key: key);

  @override
  State<ChildRegistration> createState() => ChildRegistrationState();
}

class ChildRegistrationState extends State<ChildRegistration> {
  CollectionReference students =
      FirebaseFirestore.instance.collection('Students');
  GlobalKey<AutoCompleteTextFieldState<String>> schoolKey = GlobalKey();
  TextEditingController schoolNameController = TextEditingController();
  TextEditingController studentRegistrationNumber = TextEditingController();
  TextEditingController studentName = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          'Child Registration',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
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
              child: TextFormField(
                  style: getTextInputStyle(),
                  maxLength: 10,
                  enabled: true,
                  controller: studentRegistrationNumber,
                  keyboardType: TextInputType.text,
                  decoration: getInputDecoration(
                      'Enter child registration no',
                      Icon(
                        Icons.app_registration,
                        color: textColor,
                      )))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextFormField(
                  style: getTextInputStyle(),
                  maxLength: 20,
                  enabled: true,
                  controller: studentName,
                  keyboardType: TextInputType.text,
                  decoration: getInputDecoration(
                      'Enter child name',
                      Icon(
                        Icons.child_care,
                        color: textColor,
                      )))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    primary: Colors.black,
                    backgroundColor: tertiaryColor,
                    onSurface: Colors.black,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                onPressed: () {
                  if (schoolNameController.text != '' &&
                      studentRegistrationNumber.text.length > 5 &&
                      studentName.text.length > 3) {
                    EasyLoading.show(
                        maskType: EasyLoadingMaskType.clear,
                        status: 'Registration in process',
                        indicator: Image.asset(
                          'assets/loading.gif',
                          width: 50,
                        ));
                    students.add({
                      'schoolName': schoolNameController.text,
                      'studentRegistrationNumber':
                          studentRegistrationNumber.text,
                      'studentName': studentName.text,
                      'createdAt': Timestamp.now(),
                      'parentID': globalParentID,
                      'isRegistered': false
                    }).then((value) {
                      Fluttertoast.showToast(
                          msg: 'Child registered',
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.black,
                          fontSize: 16.0);
                      EasyLoading.dismiss();
                      Navigator.of(context).pop();
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: 'Incorrect Data',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey,
                        textColor: Colors.black,
                        fontSize: 16.0);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                  child: Text(
                    'Register Child',
                    style: TextStyle(color: textColor, fontSize: 20),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
