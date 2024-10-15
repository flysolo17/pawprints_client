import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

void showToast(BuildContext context, String message) {
  FlutterToastr.show(message, context,
      duration: FlutterToastr.lengthShort, position: FlutterToastr.bottom);
}

String generateRandomNumber({int maxLength = 10}) {
  int max = pow(10, maxLength - 1)
      .toInt(); // Adjusted to maxLength - 1 to ensure within bounds
  return (Random().nextInt(max) + max).toString(); // Ensures max digit length
}
