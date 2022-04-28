import 'package:flutter/material.dart';

import '../constants.dart' as constants;

InputDecoration getInputDecoration({
  String? hintText,
  String? errorText,
  Widget? suffixIcon,
}) {
  return InputDecoration(
    hintText: hintText,
    fillColor: Colors.white,
    filled: true,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.white,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        color: constants.thirdColor,
      ),
    ),
    errorText: errorText,
    suffixIcon: suffixIcon,
  );
}
