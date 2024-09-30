import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';

void showToast(BuildContext context, String message) {
  FlutterToastr.show(message, context,
      duration: FlutterToastr.lengthShort, position: FlutterToastr.bottom);
}
