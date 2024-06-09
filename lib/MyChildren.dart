// ignore_for_file: prefer_const_constructors

import 'package:abbts/Globals.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MyChildren extends StatefulWidget {
  const MyChildren({Key? key}) : super(key: key);

  @override
  State<MyChildren> createState() => _MyChildrenState();
}

class _MyChildrenState extends State<MyChildren> {
  CollectionReference students =
      FirebaseFirestore.instance.collection('Students');
  Widget toShowLoading = Image.asset("assets/loading.gif");
  List<QueryDocumentSnapshot<Object?>> myChildren = [];
  @override
  void initState() {
    students.where('parentID', isEqualTo: globalParentID).get().then((value) {
      setState(() {
        myChildren = value.docs;
        toShowLoading = Container();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [toShowLoading],
        title: Text(
          'My Children',
          style: TextStyle(
              fontSize: 20, color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: mainColor,
      ),
      backgroundColor: secondaryColor,
      body: myChildren.isNotEmpty
          ? ListView.builder(
              itemCount: myChildren.length,
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20))),
                      child: Align(
                        alignment: Alignment.center,
                        child: ListTile(
                          title: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Text(
                              myChildren[index]['studentName'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: textColor),
                            ),
                          ),
                          subtitle: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                myChildren[index]['studentRegistrationNumber'],
                                style:
                                    TextStyle(fontSize: 12, color: textColor),
                              ),
                              Text(
                                myChildren[index]['schoolName'],
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
              }))
          : Container(),
    );
  }
}
