import 'package:abbts/DriverHomePage.dart';
import 'package:abbts/Globals.dart';
import 'package:abbts/ParentHomePage.dart';
import 'package:abbts/SignupPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();

  CollectionReference users = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        title: const Text(
          'Android Based Bus Tracking System',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      backgroundColor: secondaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
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
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: TextFormField(
                  style: getTextInputStyle(),
                  maxLength: 20,
                  enabled: true,
                  controller: password,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: getInputDecoration(
                      'Enter password',
                      Icon(
                        Icons.password,
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
                  EasyLoading.show(
                      maskType: EasyLoadingMaskType.clear,
                      status: 'Loggin in...',
                      indicator: Image.asset(
                        'assets/loading.gif',
                        width: 50,
                      ));
                  users
                      .where('userName', isEqualTo: userName.text)
                      .get()
                      .then((value) {
                    if (value.docs.isNotEmpty) {
                      if (value.docs[0]['passWord'] == password.text) {
                        if (value.docs[0]['parentOrDriver'] == 'Parent') {
                          globalUserName = userName.text;
                          globalParentID = value.docs[0].id;
                          EasyLoading.dismiss();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ParentHomePage()));
                        } else {
                          globalUserName = userName.text;
                          globalParentID = value.docs[0].id;
                          globalBusRegistrationNumber =
                              value.docs[0]['busRegistrationNumber'];
                          EasyLoading.dismiss();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const DriverHomePage()));
                        }
                      } else {
                        EasyLoading.dismiss();
                        Fluttertoast.showToast(
                            msg: "Password incorrect!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey,
                            textColor: Colors.black,
                            fontSize: 16.0);
                      }
                    } else {
                      EasyLoading.dismiss();
                      Fluttertoast.showToast(
                          msg: "User doesnot exist!",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.grey,
                          textColor: Colors.black,
                          fontSize: 16.0);
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(100, 10, 100, 10),
                  child: Text(
                    'Log In',
                    style: TextStyle(color: textColor, fontSize: 20),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
                    primary: Colors.black,
                    backgroundColor: backGrColorText,
                    onSurface: Colors.black,
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)))),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupPage()));
                },
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(50, 10, 50, 10),
                  child: Text(
                    'Sign up',
                    style: TextStyle(color: textColor, fontSize: 20),
                  ),
                )),
          )
        ],
      ),
    );
  }
}
