import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final dbRef = FirebaseDatabase.instance.reference();
  var data = {'Dust': 20.0, 'Temparature': 25.0, ' Humidity': 50.0}.obs;
  var dataString = ''.obs;
  var tempColor = Colors.green.obs;
  var humiColor = Colors.green.obs;

  void updateTemp(String temp) {
    data['Temparature'] = double.parse(temp);

    update();
  }

  void changeColor() {
    if (data['Temparature']! < 32) {
      tempColor.value = Colors.green;
    } else if (data['Temparature']! < 41) {
      tempColor.value = Colors.yellow;
    } else if (data['Temparature']! < 54) {
      tempColor.value = Colors.orange;
    } else {
      tempColor.value = Colors.red;
    }

    if (data['Humidity']! < 32) {
      humiColor.value = Colors.green;
    } else if (data['Humidity']! < 41) {
      humiColor.value = Colors.yellow;
    } else if (data['Humidity']! < 54) {
      humiColor.value = Colors.orange;
    } else {
      humiColor.value = Colors.red;
    }

    update();
  }

  @override
  void onInit() {
    ever(dataString, (_) {});

    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
