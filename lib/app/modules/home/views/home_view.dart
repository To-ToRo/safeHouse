import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    final dbRef = FirebaseDatabase.instance.reference();

    return Scaffold(
      appBar: AppBar(
        title: Text('Safe House'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
              flex: 1,
              child: Row(
                children: [
                  // 온도 인디케이터
                  Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            border: BorderDirectional(
                                end: BorderSide(width: 0.5),
                                bottom: BorderSide())),
                        child: Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 3.0),
                                      child: Obx(
                                        () => Icon(
                                          Icons.thermostat,
                                          color: controller.tempColor.value,
                                        ),
                                      )),
                                  Text('Temparature')
                                ],
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              StreamValue(
                                dbRef: dbRef,
                                what: 'Temparature',
                              ),
                              Spacer(
                                flex: 2,
                              ),
                            ],
                          ),
                        ),
                      )),
                  // 습도 인디케이터
                  Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            border: BorderDirectional(
                                start: BorderSide(width: 0.5),
                                bottom: BorderSide())),
                        child: Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 3.0),
                                    child: Obx(() => Icon(
                                          Icons.water_damage,
                                          color: controller.humiColor.value,
                                        )),
                                  ),
                                  Text(' Humidity')
                                ],
                              ),
                              Spacer(
                                flex: 1,
                              ),
                              StreamValue(
                                dbRef: dbRef,
                                what: 'Humidity',
                              ),
                              Spacer(
                                flex: 2,
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              )),
          Expanded(
              flex: 3,
              child: Row(
                children: [
                  // 미세먼지 인디케이터
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: BorderDirectional(
                            end: BorderSide(width: 0.5), bottom: BorderSide())),
                    child: Column(
                      children: [],
                    ),
                  )),
                  // 가스 인디케이터
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        border: BorderDirectional(
                            start: BorderSide(width: 0.5),
                            bottom: BorderSide())),
                    child: Column(
                      children: [],
                    ),
                  )),
                ],
              )),
          // 디바이스 cards
          Expanded(flex: 4, child: Container()),
        ],
      ),
    );
  }
}

class StreamValue extends StatelessWidget {
  const StreamValue({
    Key? key,
    required this.dbRef,
    required this.what,
  }) : super(key: key);

  final DatabaseReference dbRef;
  final String what;

  String emoji(String what) {
    if (what == 'Temparature') {
      return '\u{2103}';
    } else if (what == 'Humidity') {
      return '%';
    } else {
      return '%';
    }
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Get.put(HomeController());

    return StreamBuilder(
      stream: dbRef.onValue,
      builder: (context, AsyncSnapshot<Event> snap) {
        if (snap.hasData &&
            !snap.hasError &&
            snap.data!.snapshot.value != null) {
          Map data = snap.data!.snapshot.value;
          print(data);

          return Center(
            child: Text(
              '${data[what]} ' + emoji(what),
              textScaleFactor: 2,
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
