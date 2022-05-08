// ignore_for_file: prefer_const_constructors

import 'package:abbts/Globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController passwordAgain = TextEditingController();
  TextEditingController busRegistrationNumber = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('Users');
  bool parentOrDriver = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        title: const Text(
          'Sign Up',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      backgroundColor: secondaryColor,
      body: ListView(
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextFormField(
                  style: getTextInputStyle(),
                  maxLength: 20,
                  enabled: true,
                  controller: userName,
                  keyboardType: TextInputType.text,
                  decoration: getInputDecoration(
                      'Enter username',
                      Icon(
                        Icons.person,
                        color: textColor,
                      )))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: TextFormField(
                  style: getTextInputStyle(),
                  maxLength: 20,
                  enabled: true,
                  obscureText: true,
                  controller: password,
                  keyboardType: TextInputType.text,
                  decoration: getInputDecoration(
                      'Enter new password',
                      Icon(
                        Icons.password,
                        color: textColor,
                      )))),
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: TextFormField(
                  style: getTextInputStyle(),
                  maxLength: 20,
                  enabled: true,
                  obscureText: true,
                  controller: passwordAgain,
                  keyboardType: TextInputType.text,
                  decoration: getInputDecoration(
                      'Re-Enter Password',
                      Icon(
                        Icons.password_outlined,
                        color: textColor,
                      )))),
          parentOrDriver
              ? Container()
              : Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: TextFormField(
                      style: getTextInputStyle(),
                      maxLength: 20,
                      enabled: true,
                      controller: busRegistrationNumber,
                      keyboardType: TextInputType.text,
                      decoration: getInputDecoration(
                          'Bus Registration Number',
                          Icon(
                            Icons.bus_alert_outlined,
                            color: textColor,
                          )))),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Text(
              'Register As',
              style: TextStyle(
                  color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: FlutterSwitch(
              activeText: "I'm a Parent",
              activeIcon: Icon(
                Icons.escalator_warning,
                color: textColor,
              ),
              inactiveIcon: Icon(
                Icons.directions_bus,
                color: textColor,
              ),
              activeColor: backGrColorText,
              inactiveColor: backGrColorText,
              inactiveText: "I'm a Driver",
              activeTextColor: textColor,
              inactiveTextColor: textColor,
              width: MediaQuery.of(context).size.width - 40,
              height: 60.0,
              valueFontSize: 18.0,
              toggleSize: 40.0,
              value: parentOrDriver,
              borderRadius: 20.0,
              padding: 10.0,
              toggleColor: secondaryColor,
              showOnOff: true,
              onToggle: (val) {
                setState(() {
                  parentOrDriver = val;
                });
              },
            ),
          ),
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
                  if (password.text == passwordAgain.text &&
                      userName.text.length > 3 &&
                      password.text.length > 3) {
                    EasyLoading.show(
                        maskType: EasyLoadingMaskType.clear,
                        status: 'Registering',
                        indicator: Image.asset(
                          'assets/loading.gif',
                          width: 50,
                        ));
                    users
                        .where('userName', isEqualTo: userName.text)
                        .get()
                        .then((value) {
                      if (value.docs.isNotEmpty) {
                        Fluttertoast.showToast(
                            msg: "User already exist!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.black,
                            fontSize: 16.0);
                      } else {
                        Map<String, dynamic> addData = {
                          'userName': userName.text,
                          'passWord': password.text,
                          'parentOrDriver':
                              parentOrDriver ? "Parent" : "Driver",
                          'createdAt': Timestamp.now(),
                          'busRegistrationNumber': parentOrDriver
                              ? "null"
                              : busRegistrationNumber.text
                        };
                        users.add(addData).then((value) {
                          Fluttertoast.showToast(
                              msg: "New user registered ! You can now sign in",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                              backgroundColor: Colors.grey,
                              textColor: Colors.black,
                              fontSize: 16.0);
                          EasyLoading.dismiss();
                          Navigator.of(context).pop();
                        });
                      }
                    });
                  } else {
                    Fluttertoast.showToast(
                        msg: "Incorrect Data",
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
                    'Sign Up',
                    style: TextStyle(color: textColor, fontSize: 20),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
