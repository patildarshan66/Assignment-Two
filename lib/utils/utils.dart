
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

String getFormattedStringForDouble(String mainString, String v1, String v2) {
  return mainString.replaceAll('%s1', v1).replaceAll('%s2', v2);
}

///for replace specific sub string from main string
String getFormattedString(String mainString, String v1) {
  return mainString.replaceAll('%s1', v1);
}


/// for load json file from assets folder
Future<Map<String,dynamic>> loadJsonFile(String fileName) async {
  String data = await DefaultAssetBundle.of(Get.context!).loadString(fileName);
  return jsonDecode(data);
}