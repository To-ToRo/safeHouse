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
                  TemparatureIndicator(controller: controller, dbRef: dbRef),
                  // 습도 인디케이터
                  HumidityIndicator(controller: controller, dbRef: dbRef)
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

class TemparatureIndicator extends StatelessWidget {
  const TemparatureIndicator({
    Key? key,
    required this.controller,
    required this.dbRef,
  }) : super(key: key);

  final HomeController controller;
  final DatabaseReference dbRef;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: dbRef.onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            // print(snapshot.data.snapshot.value);
            Map data = snapshot.data!.snapshot.value;

            return Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          end: BorderSide(width: 0.5), bottom: BorderSide())),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Icon(Icons.thermostat,
                                  color: data['Temparature'] < 32
                                      ? Colors.green
                                      : data['Temparature'] < 41
                                          ? Colors.yellow
                                          : data['Temparature'] < 54
                                              ? Colors.orange
                                              : Colors.red),
                            ),
                            Text('Temparature')
                          ],
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Center(
                          child: Text(
                            '${data['Temparature']} ' + '\u{2103}',
                            textScaleFactor: 2,
                          ),
                        ),
                        Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

class HumidityIndicator extends StatelessWidget {
  const HumidityIndicator({
    Key? key,
    required this.controller,
    required this.dbRef,
  }) : super(key: key);

  final HomeController controller;
  final DatabaseReference dbRef;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: dbRef.onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            Map data = snapshot.data!.snapshot.value;
            print(data);
            return Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          start: BorderSide(width: 0.5), bottom: BorderSide())),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Icon(Icons.water_damage,
                                  color: data['Humidity'] < 25
                                      ? Colors.red
                                      : data['Humidity'] < 30
                                          ? Colors.orange
                                          : data['Humidity'] < 60
                                              ? Colors.green
                                              : data['Humidity'] < 70
                                                  ? Colors.orange
                                                  : Colors.red),
                            ),
                            Text('Humidity')
                          ],
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Center(
                          child: Text(
                            '${data['Humidity']} ' + '%',
                            textScaleFactor: 2,
                          ),
                        ),
                        Spacer(
                          flex: 2,
                        ),
                      ],
                    ),
                  ),
                ));
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}
