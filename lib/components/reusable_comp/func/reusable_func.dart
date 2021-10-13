import 'dart:convert';

import 'package:chatty/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

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

Future<bool> sendNotification(
    {required String userToken,required String msg,required String type, String? title,String? userImage,String? time}) async {
  const postUrl = 'https://fcm.googleapis.com/fcm/send';
  final data = {
    "to": userToken,
    "notification": {
      "title": title??'',
      "body": msg,
      "sound": "default",
    },
    "android": {
      "priority": "HIGH",
      "notification": {
        "notification_priority": "PRIORITY_MAX",
        "sound": "default",
        "default_sound": true,
        "default_vibrate_timings": true,
        "default_light_settings": true,
      }
    },
    "data": {
      "type": type,
      "userImage": userImage??'',
      "time": time??'',
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
    }
  };

  final headers = {
    'content-type': 'application/json',
    'Authorization': Constants.firebaseTokenAPIFCM // 'key=YOUR_SERVER_KEY'
  };

  final response = await http.post(Uri.parse(postUrl),
      body: json.encode(data),
      encoding: Encoding.getByName('utf-8'),
      headers: headers);

  if (response.statusCode == 200) {
    // on success do sth
    print('test ok push CFM');
    return true;
  } else {
    print(' CFM error');
    // on failure do sth
    return false;
  }
}