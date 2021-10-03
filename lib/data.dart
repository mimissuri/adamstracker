import 'dart:developer';
import 'dart:math' as math;
import 'dart:ui';
import 'package:adamstracker/main.dart' as main;
import 'package:adamstracker/widgets/ftext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:intl/intl.dart';
// Assets
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'globals.dart' as gl;

class Data extends StatefulWidget {
  int exerciseid;
  String title;

  Data(this.exerciseid, this.title);
  @override
  DataState createState() {
    return DataState(exerciseid, title);
  }
}

class DataState extends State<Data> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();

  int exerciseid;
  String title;

  DataState(this.exerciseid, this.title);

  @override
  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      zoomMode: ZoomMode.x,
      enableDoubleTapZooming: true,
      enablePanning: true,
    );

    _trackballBehavior = TrackballBehavior(
        enable: true,
        activationMode: ActivationMode.singleTap,
        markerSettings: TrackballMarkerSettings(
            markerVisibility: TrackballVisibilityMode.hidden),
        tooltipSettings: InteractiveTooltip(
            canShowMarker: false, format: 'point.x - point.y kg'),

        // Display mode of trackball tooltip
        tooltipDisplayMode: TrackballDisplayMode.floatAllPoints);
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getData();
    });
  }

  int s1p = 0;
  int s1r = 12;
  int s2p = 0;
  int s2r = 12;
  int s3p = 0;
  int s3r = 12;

  List<LogsData> chartData = [
    // Bind data source
    //LogsData(DateTime(2015, 1, 1), 30),
  ];

  void refresh() {
    setState(() {});
  }

  List<Map> nsdataDB = [];
  void getData() async {
    log("1:" + exerciseid.toString());
    nsdataDB = await main.model.database
        .rawQuery('SELECT * FROM logs WHERE exercise = $exerciseid');
    log("DAATAAA:" + nsdataDB.toString());
    log("2:" + exerciseid.toString());

    refresh();
  }

  void delete(int id) {}

  @override
  Widget build(BuildContext context) {
    gl.width = MediaQuery.of(context).size.width;
    gl.height = MediaQuery.of(context).size.height;
    gl.statusHeight = MediaQuery.of(context).padding.top;
    final List<Color> color = <Color>[];
    color.add(Color.fromRGBO(200, 0, 230, 1));
    color.add(Color.fromRGBO(255, 200, 0, 1));

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(1);

    final LinearGradient gradientColors =
        LinearGradient(colors: color, stops: stops);

    DateFormat format = new DateFormat("MMMM dd, yyyy");
    chartData = [];
    for (int i = 0; i < nsdataDB.length; i++) {
      List<int> weights = [
        nsdataDB[i]["w1"],
        nsdataDB[i]["w2"],
        nsdataDB[i]["w3"],
      ];
      int weight = weights.reduce(math.max);
      List<int> reps = [
        nsdataDB[i]["r1"],
        nsdataDB[i]["r2"],
        nsdataDB[i]["r3"],
      ];
      int rep = reps.reduce(math.max);
      s1p = weight;
      s2p = weight;
      s3p = weight;
      s1r = rep;
      s2r = rep;
      s3r = rep;
      DateTime date = DateTime.parse(nsdataDB[i]["datetime"]);
      print(date.hour);
      chartData.add(LogsData(
          DateTime(date.year, date.month, date.day, date.hour), weight));
    }
    return Scaffold(
      key: _key,
      resizeToAvoidBottomInset: false,
      backgroundColor: gl.pC,
      body: Column(
        children: [
          // ANCHOR TOP MENU
          Container(
            height: gl.statusHeight,
          ),
          Container(
            width: gl.width,
            height: gl.height * 0.07,
            child: Row(
              children: [
                Container(
                  width: gl.width * 0.2,
                  height: gl.height * 0.07,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_sharp,
                        size: 25.0,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
                Container(
                  width: gl.width * 0.6,
                  height: gl.height * 0.07,
                  child: Center(
                    child: ftext(title, 28.0, Colors.white, FontWeight.w800),
                  ),
                ),
                Container(
                  width: gl.width * 0.2,
                  height: gl.height * 0.07,
                  child: Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.add,
                        size: 25.0,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        await showDialog<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              insetPadding: EdgeInsets.fromLTRB(
                                gl.width * 0.05,
                                gl.height * 0.1,
                                gl.width * 0.05,
                                gl.height * 0.1,
                              ),
                              contentPadding: EdgeInsets.all(0),
                              content: StatefulBuilder(
                                builder: (BuildContext context,
                                    StateSetter setState) {
                                  return Center(
                                    child: Container(
                                      width: gl.width * 0.9,
                                      height:
                                          gl.height * 0.80 - gl.statusHeight,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.white,
                                      ),
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          ftext("Chest - Upper", 30.0,
                                              Colors.black, FontWeight.w700),
                                          Container(height: gl.height * 0.02),
                                          ftext("Add New Log", 20.0,
                                              Colors.black, FontWeight.w700),
                                          Container(height: gl.height * 0.02),
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: gl.height * 0.05),
                                            width: gl.width * 0.8,
                                            height: gl.height * 0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: gl.dC,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: gl.width * 0.2,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      ftext(
                                                        "SET",
                                                        20.0,
                                                        Colors.white,
                                                        FontWeight.w600,
                                                      ),
                                                      ftext(
                                                        "1",
                                                        30.0,
                                                        Colors.white,
                                                        FontWeight.w700,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: gl.width * 0.16,
                                                  ),
                                                  width: gl.width * 0.1,
                                                  color: Colors.red,
                                                  child: Center(
                                                    child: NumberPicker(
                                                      value: s1p,
                                                      minValue: 0,
                                                      maxValue: 100,
                                                      step: 1,
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                      selectedTextStyle:
                                                          TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      itemHeight: 30,
                                                      itemWidth: 40,
                                                      onChanged: (value) =>
                                                          setState(
                                                        () => s1p = value,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: gl.height * 0.015,
                                                    left: gl.width * 0.01,
                                                  ),
                                                  child: ftext(
                                                    "kg",
                                                    25.0,
                                                    Colors.white,
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: gl.width * 0.06,
                                                  ),
                                                  width: gl.width * 0.1,
                                                  color: Colors.blue,
                                                  child: Center(
                                                    child: NumberPicker(
                                                      value: s1r,
                                                      minValue: 0,
                                                      maxValue: 50,
                                                      step: 1,
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                      selectedTextStyle:
                                                          TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      itemHeight: 30,
                                                      itemWidth: 40,
                                                      onChanged: (value) =>
                                                          setState(
                                                        () => s1r = value,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: gl.height * 0.01,
                                                    left: gl.width * 0.01,
                                                  ),
                                                  child: ftext(
                                                    "rep",
                                                    25.0,
                                                    Colors.white,
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: gl.height * 0.05),
                                            width: gl.width * 0.8,
                                            height: gl.height * 0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: gl.dC,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: gl.width * 0.2,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      ftext(
                                                        "SET",
                                                        20.0,
                                                        Colors.white,
                                                        FontWeight.w600,
                                                      ),
                                                      ftext(
                                                        "2",
                                                        30.0,
                                                        Colors.white,
                                                        FontWeight.w700,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: gl.width * 0.16,
                                                  ),
                                                  width: gl.width * 0.1,
                                                  color: Colors.red,
                                                  child: Center(
                                                    child: NumberPicker(
                                                      value: s2p,
                                                      minValue: 0,
                                                      maxValue: 100,
                                                      step: 1,
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                      selectedTextStyle:
                                                          TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      itemHeight: 30,
                                                      itemWidth: 40,
                                                      onChanged: (value) =>
                                                          setState(
                                                        () => s2p = value,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: gl.height * 0.015,
                                                    left: gl.width * 0.01,
                                                  ),
                                                  child: ftext(
                                                    "kg",
                                                    25.0,
                                                    Colors.white,
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: gl.width * 0.06,
                                                  ),
                                                  width: gl.width * 0.1,
                                                  color: Colors.blue,
                                                  child: Center(
                                                    child: NumberPicker(
                                                      value: s2r,
                                                      minValue: 0,
                                                      maxValue: 50,
                                                      step: 1,
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                      selectedTextStyle:
                                                          TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      itemHeight: 30,
                                                      itemWidth: 40,
                                                      onChanged: (value) =>
                                                          setState(
                                                        () => s2r = value,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: gl.height * 0.01,
                                                    left: gl.width * 0.01,
                                                  ),
                                                  child: ftext(
                                                    "rep",
                                                    25.0,
                                                    Colors.white,
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(
                                                bottom: gl.height * 0.05),
                                            width: gl.width * 0.8,
                                            height: gl.height * 0.1,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: gl.dC,
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  width: gl.width * 0.2,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      ftext(
                                                        "SET",
                                                        20.0,
                                                        Colors.white,
                                                        FontWeight.w600,
                                                      ),
                                                      ftext(
                                                        "3",
                                                        30.0,
                                                        Colors.white,
                                                        FontWeight.w700,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: gl.width * 0.16,
                                                  ),
                                                  width: gl.width * 0.1,
                                                  color: Colors.red,
                                                  child: Center(
                                                    child: NumberPicker(
                                                      value: s3p,
                                                      minValue: 0,
                                                      maxValue: 100,
                                                      step: 1,
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                      selectedTextStyle:
                                                          TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      itemHeight: 30,
                                                      itemWidth: 40,
                                                      onChanged: (value) =>
                                                          setState(
                                                        () => s3p = value,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: gl.height * 0.015,
                                                    left: gl.width * 0.01,
                                                  ),
                                                  child: ftext(
                                                    "kg",
                                                    25.0,
                                                    Colors.white,
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                                Container(
                                                  margin: EdgeInsets.only(
                                                    left: gl.width * 0.06,
                                                  ),
                                                  width: gl.width * 0.1,
                                                  color: Colors.blue,
                                                  child: Center(
                                                    child: NumberPicker(
                                                      value: s3r,
                                                      minValue: 0,
                                                      maxValue: 50,
                                                      step: 1,
                                                      textStyle: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 10,
                                                      ),
                                                      selectedTextStyle:
                                                          TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      itemHeight: 30,
                                                      itemWidth: 40,
                                                      onChanged: (value) =>
                                                          setState(
                                                        () => s3r = value,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding: EdgeInsets.only(
                                                    top: gl.height * 0.01,
                                                    left: gl.width * 0.01,
                                                  ),
                                                  child: ftext(
                                                    "rep",
                                                    25.0,
                                                    Colors.white,
                                                    FontWeight.w500,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            height: gl.height * 0.06,
                                            minWidth: gl.width * 0.8,
                                            color: gl.dC,
                                            splashColor: gl.dC,
                                            onPressed: () async {
                                              await main.model.database
                                                  .transaction((txn) async {
                                                int id2 = await txn.rawInsert(
                                                  'INSERT INTO logs(exercise, w1, r1, w2, r2, w3, r3, datetime) VALUES(?, ?, ?,?,?,?,?,?)',
                                                  [
                                                    exerciseid,
                                                    s1p,
                                                    s1r,
                                                    s2p,
                                                    s2r,
                                                    s3p,
                                                    s3r,
                                                    DateTime.now().toString()
                                                  ],
                                                );
                                                try {
                                                  await main.model.conn.query(
                                                      'INSERT INTO logs(g_id, exercise, w1, r1, w2, r2, w3, r3, datetime) VALUES(?,?, ?, ?,?,?,?,?,?)',
                                                      [
                                                        main.model.user?.id,
                                                        exerciseid,
                                                        s1p,
                                                        s1r,
                                                        s2p,
                                                        s2r,
                                                        s3p,
                                                        s3r,
                                                        DateTime.now()
                                                            .toString()
                                                      ]);
                                                } catch (err) {
                                                  EasyLoading.showError(
                                                      err.toString());
                                                }
                                                getData();
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: ftext(
                                              "Submit",
                                              18.0,
                                              Colors.white,
                                              FontWeight.w500,
                                            ),
                                          ),
                                          Container(height: gl.height * 0.02),
                                          MaterialButton(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            height: gl.height * 0.06,
                                            minWidth: gl.width * 0.8,
                                            color: gl.rC,
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: ftext(
                                              "Cancel",
                                              18.0,
                                              Colors.white,
                                              FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Container(
            height: gl.height * 0.4,
            width: gl.width * 0.9,
            padding: EdgeInsets.only(top: 10, left: 0, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: gl.dC,
            ),
            child: Column(
              children: [
                ftext("Weight History", 20.0, Colors.white, FontWeight.w700),
                Container(
                  height: gl.height * 0.36,
                  child: SfCartesianChart(
                    zoomPanBehavior: _zoomPanBehavior,
                    trackballBehavior: _trackballBehavior,
                    primaryXAxis: DateTimeAxis(
                      intervalType: DateTimeIntervalType.days,
                    ),
                    primaryYAxis: NumericAxis(
                      anchorRangeToVisiblePoints: false,
                    ),
                    series: <ChartSeries>[
                      // Initialize line series
                      AreaSeries<LogsData, DateTime>(
                        dataSource: chartData,
                        markerSettings: MarkerSettings(isVisible: true),
                        trendlines: [
                          Trendline(
                            type: TrendlineType.polynomial,
                            color: Colors.white,
                            width: 1,
                          )
                        ],
                        borderWidth: 4,
                        borderGradient: const LinearGradient(
                          colors: [
                            Color.fromRGBO(230, 0, 180, 1),
                            Color.fromRGBO(255, 200, 0, 1)
                          ],
                          stops: [0, 1],
                        ),
                        gradient: gradientColors,
                        xValueMapper: (LogsData sales, _) => sales.date,
                        yValueMapper: (LogsData sales, _) => sales.sales,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: gl.height * 0.06,
            child: Center(
              child: ftext("Data Log", 20.0, Colors.white, FontWeight.w700),
            ),
          ),
          Container(
            width: gl.width * 0.9,
            height: gl.height * 0.405,
            alignment: Alignment.topCenter,
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0),
              shrinkWrap: true,
              reverse: true,
              itemCount: nsdataDB.length,
              itemBuilder: (context, index) {
                print(nsdataDB[index]["datetime"]);
                return GestureDetector(
                  onTap: () {
                    showDialog<String>(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: const Text('Delete log?'),
                        elevation: 20.0,
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {},
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.pop(context);
                              await main.model.database.rawDelete(
                                  'DELETE FROM logs WHERE id = ?',
                                  [nsdataDB[index]["id"]]);

                              await main.model.conn.query(
                                'DELETE FROM logs WHERE g_id = ? and datetime = ?',
                                [
                                  main.model.user?.id,
                                  nsdataDB[index]["datetime"]
                                ],
                              );
                              getData();
                            },
                            child: const Text('Delete'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: gl.height * 0.11,
                    width: gl.width * 0.9,
                    padding: EdgeInsets.only(top: gl.height * 0.015),
                    margin: EdgeInsets.only(bottom: gl.height * 0.02),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: gl.dC,
                    ),
                    child: Column(
                      children: [
                        ftext(
                            format.format(
                                DateTime.parse(nsdataDB[index]["datetime"])),
                            18.0,
                            Colors.white,
                            FontWeight.w500),
                        Container(
                          height: gl.height * 0.015,
                        ),
                        Row(
                          children: [
                            Container(
                              width: gl.width * 0.3,
                              child: Column(
                                children: [
                                  ftext("${nsdataDB[index]["w1"]} kg", 18.0,
                                      Colors.white, FontWeight.w700),
                                  Container(height: gl.height * 0.01),
                                  ftext("${nsdataDB[index]["r1"]} reps", 18.0,
                                      Colors.white, FontWeight.w400),
                                ],
                              ),
                            ),
                            Container(
                              width: gl.width * 0.3,
                              child: Column(
                                children: [
                                  ftext("${nsdataDB[index]["w2"]} kg", 18.0,
                                      Colors.white, FontWeight.w700),
                                  Container(height: gl.height * 0.01),
                                  ftext("${nsdataDB[index]["r2"]} reps", 18.0,
                                      Colors.white, FontWeight.w400),
                                ],
                              ),
                            ),
                            Container(
                              width: gl.width * 0.3,
                              child: Column(
                                children: [
                                  ftext("${nsdataDB[index]["w3"]} kg", 18.0,
                                      Colors.white, FontWeight.w700),
                                  Container(height: gl.height * 0.01),
                                  ftext("${nsdataDB[index]["r3"]} reps", 18.0,
                                      Colors.white, FontWeight.w400),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LogsData {
  LogsData(this.date, this.sales);
  final DateTime date;
  final int? sales;
}
