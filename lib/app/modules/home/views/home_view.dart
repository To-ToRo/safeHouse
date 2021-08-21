import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:get/get.dart';

// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  Color screenColor(var temp) {
    if (temp >= 54) {
      return Colors.redAccent;
    } else {
      return Colors.transparent;
    }
  }

  Color powerColor(var power) {
    Color returnColor = Colors.black;

    if (power) {
      returnColor = Colors.amber;
    } else {
      returnColor = Colors.grey;
    }

    return returnColor;
  }

  @override
  Widget build(BuildContext context) {
    final dbRef = FirebaseDatabase.instance.reference();

    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Safe House',
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<Object>(
            stream: dbRef.onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data!.snapshot.value != null) {
                Map data = snapshot.data!.snapshot.value;

                return Column(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            // 온도 인디케이터
                            TemparatureIndicator(dbRef: dbRef),
                            // 습도 인디케이터
                            HumidityIndicator(dbRef: dbRef)
                          ],
                        )),
                    Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            // 미세먼지 인디케이터
                            DustIndicator(dbRef: dbRef),
                            // 가스 인디케이터
                            GasIndicator(dbRef: dbRef),
                          ],
                        )),
                    // 디바이스 버튼
                    Expanded(
                        flex: 2,
                        child: Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('공기청정기'),
                                InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    dbRef
                                        .child('AirPurifier')
                                        .child('Power')
                                        .set(!data['AirPurifier']['Power']);
                                  },
                                  child: Icon(Icons.power_settings_new,
                                      size: 80,
                                      color: powerColor(
                                          data['AirPurifier']['Power'])),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('에어컨'),
                                InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    dbRef
                                        .child('AirConditioner')
                                        .child('Power')
                                        .set(!data['AirConditioner']['Power']);
                                  },
                                  child: Icon(Icons.power_settings_new,
                                      size: 80,
                                      color: powerColor(
                                          data['AirConditioner']['Power'])),
                                ),
                              ],
                            ),
                          ],
                        ))),
                    Expanded(
                        flex: 2,
                        child: Container(
                            child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('난방'),
                                InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    dbRef
                                        .child('Heater')
                                        .child('Power')
                                        .set(!data['Heater']['Power']);
                                  },
                                  child: Icon(Icons.power_settings_new,
                                      size: 80,
                                      color:
                                          powerColor(data['Heater']['Power'])),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('제습기'),
                                InkWell(
                                  borderRadius: BorderRadius.circular(100),
                                  onTap: () {
                                    dbRef
                                        .child('Dehumidifier')
                                        .child('Power')
                                        .set(!data['Dehumidifier']['Power']);
                                  },
                                  child: Icon(Icons.power_settings_new,
                                      size: 80,
                                      color: powerColor(
                                          data['Dehumidifier']['Power'])),
                                ),
                              ],
                            ),
                          ],
                        ))),
                  ],
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }));
  }
}

class TemparatureIndicator extends StatelessWidget {
  const TemparatureIndicator({
    Key? key,
    required this.dbRef,
  }) : super(key: key);

  final DatabaseReference dbRef;

  Color tempColor(var temp) {
    Color returnColor = Colors.green;

    if (temp < 32) {
      returnColor = Colors.green;
    } else if (temp < 41) {
      returnColor = Colors.yellow;
    } else if (temp < 54) {
      returnColor = Colors.orange;
    } else {
      returnColor = Colors.red;
    }

    return returnColor;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: dbRef.child('SensorValues').child('Temparature').onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            var data = snapshot.data!.snapshot.value;
            return Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          top: BorderSide(),
                          end: BorderSide(width: 0.5),
                          bottom: BorderSide())),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Icon(Icons.thermostat,
                                  color: tempColor(data)),
                            ),
                            Text(' 온도')
                          ],
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Center(
                          child: Text(
                            '${data} ' + '\u{2103}',
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
            return Expanded(flex: 1, child: CircularProgressIndicator());
          }
        });
  }
}

class HumidityIndicator extends StatelessWidget {
  const HumidityIndicator({
    Key? key,
    required this.dbRef,
  }) : super(key: key);

  final DatabaseReference dbRef;

  Color humiColor(var humi) {
    Color returnColor = Colors.green;

    if (humi < 25) {
      returnColor = Colors.red;
    } else if (humi < 30) {
      returnColor = Colors.orange;
    } else if (humi < 60) {
      returnColor = Colors.green;
    } else if (humi < 70) {
      returnColor = Colors.orange;
    } else {
      returnColor = Colors.red;
    }

    return returnColor;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: dbRef.child('SensorValues').child('Humidity').onValue,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData &&
              !snapshot.hasError &&
              snapshot.data!.snapshot.value != null) {
            var data = snapshot.data!.snapshot.value;
            return Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      border: BorderDirectional(
                          top: BorderSide(),
                          start: BorderSide(width: 0.5),
                          bottom: BorderSide())),
                  child: Center(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: Icon(Icons.water_damage,
                                  color: humiColor(data)),
                            ),
                            Text(
                              ' 습도',
                            ),
                          ],
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Center(
                          child: Text(
                            '${data} ' + '%',
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
            return Expanded(flex: 1, child: CircularProgressIndicator());
          }
        });
  }
}

class DustIndicator extends StatelessWidget {
  const DustIndicator({Key? key, required this.dbRef}) : super(key: key);
  final DatabaseReference dbRef;

  Color dustColor(var dust100, var dust25) {
    Color returnColor = Colors.blue;
    List dustColorList = [Colors.blue, Colors.green, Colors.orange, Colors.red];
    int dust100Level = 0;
    int dust25Level = 0;

    if (dust100 < 31) {
      dust100Level = 0;
    } else if (dust100 < 81) {
      dust100Level = 1;
    } else if (dust100 < 151) {
      dust100Level = 2;
    } else {
      dust100Level = 3;
    }

    if (dust25 < 16) {
      dust25Level = 0;
    } else if (dust25 < 36) {
      dust25Level = 1;
    } else if (dust25 < 76) {
      dust25Level = 2;
    } else {
      dust25Level = 3;
    }

    if (dust100Level > dust25Level) {
      returnColor = dustColorList[dust100Level];
    } else {
      returnColor = dustColorList[dust25Level];
    }

    return returnColor;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            border: BorderDirectional(
                end: BorderSide(width: 0.5), bottom: BorderSide())),
        child: StreamBuilder(
          stream: dbRef.child('SensorValues').child('Dust').onValue,
          // initialData: ,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data!.snapshot.value != null) {
              var data = snapshot.data!.snapshot.value;
              return Column(
                children: [
                  Text('미세먼지'),
                  Spacer(), // 여기 그림 들어가야함
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                          color: dustColor(data['PM100'], data['PM25']),
                          shape: BoxShape.circle),
                    ),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Spacer(),
                      Column(
                        children: [
                          Text('PM1.0'),
                          Text(
                            data['PM10'].toString(),
                            textScaleFactor: 1.5,
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text('PM2.5'),
                          Text(
                            data['PM25'].toString(),
                            textScaleFactor: 1.5,
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          Text('PM10'),
                          Text(
                            data['PM100'].toString(),
                            textScaleFactor: 1.5,
                          ),
                        ],
                      ),
                      Spacer(),
                    ],
                  ),
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}

class GasIndicator extends StatelessWidget {
  const GasIndicator({Key? key, required this.dbRef}) : super(key: key);
  final DatabaseReference dbRef;

  Color gasColor(var gasValue) {
    Color returnColor = Colors.blue;

    if (gasValue < 5000) {
      returnColor = Colors.blue;
    } else {
      returnColor = Colors.red;
    }

    return returnColor;
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      decoration: BoxDecoration(
          border: BorderDirectional(
              start: BorderSide(width: 0.5), bottom: BorderSide())),
      child: StreamBuilder<Object>(
          stream: dbRef.child('SensorValues').child('Gas').onValue,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData &&
                !snapshot.hasError &&
                snapshot.data!.snapshot.value != null) {
              var data = snapshot.data!.snapshot.value;

              return Column(
                children: [
                  Text('유해가스'),
                  Spacer(),
                  Expanded(
                    flex: 4,
                    child: Container(
                      decoration: BoxDecoration(
                          color: gasColor(data), shape: BoxShape.circle),
                    ),
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        data.toString(),
                        textScaleFactor: 2,
                      ),
                      // Text(' ppm')
                    ],
                  )
                ],
              );
            } else {
              return CircularProgressIndicator();
            }
          }),
    ));
  }
}
