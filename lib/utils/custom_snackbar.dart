import 'package:flutter/material.dart';
import 'package:get/get.dart';


///custom snack bar
void showSnackBar(String title, String subTitle)async{
  await Get.closeCurrentSnackbar();
  Get.snackbar(
    title,
    subTitle,
    duration: const Duration(seconds: 1),
    icon: const Icon(Icons.error, color: Colors.white),
    snackPosition: SnackPosition.BOTTOM,
  );
}