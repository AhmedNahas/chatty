import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget defaultTextFormField(
        {required controller,
        required String? Function(String? v) validate,
        required inputType,
        required label,
        required icon,
        suffix,
        obscure = false}) =>
    TextFormField(
      controller: controller,
      keyboardType: inputType,
      obscureText: obscure,
      onFieldSubmitted: (String value) {
        log(value);
      },
      onChanged: (String value) {
        log(value);
      },
      validator: validate,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: icon,
        suffixIcon: suffix,
        border: const OutlineInputBorder(),
      ),
    );

Widget defaultButton({
  required double width,
  required Color background,
  required Color textColor,
  required Function()? onPress,
  required String label,
}) =>
    Container(
      width: width,
      color: background,
      child: MaterialButton(
        onPressed: onPress,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
          ),
        ),
      ),
    );
