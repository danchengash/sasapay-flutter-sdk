import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:logger/logger.dart';

showASnackbar(
    {required String message, required BuildContext context, int? duration}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    // backgroundColor: Colors.,
    content: Text(message),
    duration: Duration(seconds: duration ?? 1),
  ));
}

showErrorSnackbar(
    {required String message, required BuildContext context, int? duration}) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Color(0xFFFC6868),
    content: Text(message),
    duration: Duration(seconds: duration ?? 2),
  ));
}

Logger logg = Logger();

showGetSnackBar(
    {required String message1,
    String? message2,
    SnackPosition? snackPosition,
    int? duration}) {
  return Get.snackbar(message1, message2 ?? '',
      isDismissible: true,
      duration: Duration(seconds: duration ?? 3),
      snackPosition: snackPosition ?? SnackPosition.BOTTOM);
}
