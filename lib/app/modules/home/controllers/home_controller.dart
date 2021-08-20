import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  var temp = 26.0.obs;
  var humi = 50.0.obs;
  var dust = 25.0.obs;
  var gas = 100.0.obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
