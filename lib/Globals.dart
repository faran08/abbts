library fwmd.globals;

import 'package:flutter/material.dart';

Color textColor = Colors.grey.shade100;
Color backGrColorText = Colors.blueGrey;
String globalUserName = '';
Color mainColor = const Color(0xFFFE5F55);
Color secondaryColor = const Color(0xFF4F6367);
Color tertiaryColor = Colors.redAccent;
String globalParentID = '';
String globalBusRegistrationNumber = '';

TextStyle getTextInputStyle() {
  return TextStyle(color: textColor, fontSize: 15);
}

InputDecoration getInputDecoration(String hint, Icon icon) {
  return InputDecoration(
      counterStyle: const TextStyle(color: Colors.white),
      // labelText: 'From',
      hintText: hint,
      hintStyle: TextStyle(color: Colors.grey[100], fontSize: 15),
      labelStyle: TextStyle(color: textColor, fontSize: 15),
      contentPadding:
          const EdgeInsets.only(top: 20, bottom: 20, left: 20, right: 20),
      fillColor: backGrColorText,
      filled: true,
      disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: backGrColorText, width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(20)),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: backGrColorText, width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(20)),
      focusColor: Colors.grey[100],
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: backGrColorText, width: 2, style: BorderStyle.solid),
          borderRadius: BorderRadius.circular(20)),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
              color: backGrColorText, width: 2, style: BorderStyle.solid)),
      suffixIcon: icon);
}

List<String> schools = [
  'All Saints Secondary School',
  'Batu Pahat High School',
  'Muar High School',
  'Bukit Mertajam High School',
  'Catholic High School',
  'Chinese High School (Batu Pahat)',
  'Kajang High School',
  'Klang High School',
  'Kluang High School',
  'Kota Kinabalu High School',
  'Kuala Selangor High School',
  'Kuching High School',
  'Lake Gardens High School',
  'Malacca High School',
  'Malacca Chinese High School',
  'Malacca Girls High School',
  'Port Dickson High School',
  'Sabah Chinese High School',
  'Sarikei High School',
  'Segamat High School',
  'Setapak High School',
  'St. Davids High School, Malacca',
  'Foon Yew High School',
  'St. John Institution'
];
