import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
      (Route<dynamic> route) => false,
);

void showToast({
  required String text,
  required ToastColors color,
}) {
  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: setToastColor(color),
    textColor: Colors.white,
    fontSize: 16.0,
  );
}

enum ToastColors {
  SUCCESS,
  ERROR,
  WARNING,
}

Color setToastColor(ToastColors color) {
  Color c;

  switch (color) {
    case ToastColors.ERROR:
      c = Colors.red;
      break;
    case ToastColors.SUCCESS:
      c = Colors.green;
      break;
    case ToastColors.WARNING:
      c = Colors.amber;
      break;
  }

  return c;
}

String getDateTimeFormatted(){
  var now = DateTime.now();
  return "${now.year
      .toString()}-${now.month.toString().padLeft(
      2, '0')}-${now.day.toString().padLeft(
      2, '0')} ${now.hour.toString().padLeft(
      2, '0')}-${now.minute.toString().padLeft(
      2, '0')}";
}