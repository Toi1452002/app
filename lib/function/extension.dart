import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension Bool on String{
  bool get toBool=> int.parse(this)==0?false:true;
}

extension Numeric on String {
  bool get isNumeric => num.tryParse(this) != null ? true : false;
}

extension E on String {
  String lastChars(int n) => substring(length - n);
}

Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup('example.com');
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    return false;
  }
}

void Alert({required String title, required String message}){
  Get.snackbar(title,message ,
      backgroundColor: Colors.black.withOpacity(.5),
      colorText: Colors.white,
      dismissDirection: DismissDirection.startToEnd,
      maxWidth: 300,
      margin: const EdgeInsets.only(top: 10)
  );
}

Future<String> idDevice()async{
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
  return androidInfo.id;
}