import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import "package:pull_to_refresh/pull_to_refresh.dart";
import 'package:percent_indicator/percent_indicator.dart';

//import 'package:modern_charts/modern_charts.dart';
//import 'package:modern_charts/modern_charts.dart' as chart_modern;
//import 'dart:math';
//import 'dart:html';

class SecondFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: FutureBuilder<List<OEE>>(
        future: fetchOEE(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OEE> values = snapshot.data;
            return new MySecondFragment(
                listOEE: values); //Text(snapshot.data[1].title);
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          // By default, show a loading spinner
          return CircularProgressIndicator();
        },
      ),
//child: new MySecondFragment(),
    ));
    /*return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MySecondFragment(title: 'Flutter Demo Home Page'),
    );*/
  }
}

class MySecondFragment extends StatefulWidget {
  MySecondFragment({Key key, this.listOEE}) : super(key: key);

  final List<OEE> listOEE;

  @override
  _MySecondFragmentState createState() =>
      new _MySecondFragmentState(listOEE: listOEE);
}

class ClicksPerYear {
  final String year;
  final int clicks;
  final charts.Color color;

  ClicksPerYear(this.year, this.clicks, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class OEEBarChart {
  final String year;
  final double value;
  final charts.Color color;

  OEEBarChart(this.year, this.value, Color color)
      : this.color = new charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

String format(double n) {
  return n.toStringAsFixed(n.truncateToDouble() == n ? 2 : 2);
}

class _MySecondFragmentState extends State<MySecondFragment> {
  _MySecondFragmentState({this.listOEE});

  final List<OEE> listOEE;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    var dataA;
    var dataP;
    var dataQ;

    var dataOeeAPQ;

    var dataOee;

    var dataAPQgood;
    var dataAPQbad;

    for (int i = 1; i <= listOEE.length - 1; i++) {
      if (i == 1) {
        dataA = [
          new OEEBarChart(
              listOEE[1].namedate, listOEE[1].value_a, Colors.green[200]),
          new OEEBarChart(
              listOEE[2].namedate, listOEE[2].value_a, Colors.green[200]),
          new OEEBarChart(
              listOEE[3].namedate, listOEE[3].value_a, Colors.green[200]),
          new OEEBarChart(
              listOEE[4].namedate, listOEE[4].value_a, Colors.green[200]),
        ];
      } else if (i == 2) {
        dataP = [
          new OEEBarChart(
              listOEE[1].namedate, listOEE[1].value_p, Colors.yellow),
          new OEEBarChart(
              listOEE[2].namedate, listOEE[2].value_p, Colors.yellow),
          new OEEBarChart(
              listOEE[3].namedate, listOEE[3].value_p, Colors.yellow),
          new OEEBarChart(
              listOEE[4].namedate, listOEE[4].value_p, Colors.yellow),
        ];
      } else if (i == 3) {
        dataQ = [
          new OEEBarChart(
              listOEE[1].namedate, listOEE[1].value_q, Colors.green),
          new OEEBarChart(
              listOEE[2].namedate, listOEE[2].value_q, Colors.green),
          new OEEBarChart(
              listOEE[3].namedate, listOEE[3].value_q, Colors.green),
          new OEEBarChart(
              listOEE[4].namedate, listOEE[4].value_q, Colors.green),
        ];
      }
    }

    dataOeeAPQ = [
      new OEEBarChart(
          listOEE[1].namedate,
          double.parse(format((((listOEE[1].value_a / 100) *
                  (listOEE[1].value_q / 100) *
                  (listOEE[1].value_p / 100)) *
              100))),
          Colors.red),
      new OEEBarChart(
          listOEE[2].namedate,
          double.parse(format((((listOEE[2].value_a / 100) *
                  (listOEE[2].value_q / 100) *
                  (listOEE[2].value_p / 100)) *
              100))),
          Colors.red),
      new OEEBarChart(
          listOEE[3].namedate,
          double.parse(format((((listOEE[3].value_a / 100) *
                  (listOEE[3].value_q / 100) *
                  (listOEE[3].value_p / 100)) *
              100))),
          Colors.red),
      new OEEBarChart(
          listOEE[4].namedate,
          double.parse(format((((listOEE[4].value_a / 100) *
                  (listOEE[4].value_q / 100) *
                  (listOEE[4].value_p / 100)) *
              100))),
          Colors.red),
    ];

    dataOee = [
      new OEEBarChart(
          "Good",
          double.parse(format((((listOEE[0].value_a / 100) *
                  (listOEE[0].value_q / 100) *
                  (listOEE[0].value_p / 100)) *
              100))),
          Colors.greenAccent),
      new OEEBarChart(
          "Bad",
          (100 -
              double.parse(format((((listOEE[0].value_a / 100) *
                      (listOEE[0].value_q / 100) *
                      (listOEE[0].value_p / 100)) *
                  100)))),
          Colors.grey),
    ];

    dataAPQgood = [
      new OEEBarChart("A", listOEE[0].value_a, Colors.greenAccent),
      new OEEBarChart("P", listOEE[0].value_p, Colors.greenAccent),
      new OEEBarChart("Q", listOEE[0].value_q, Colors.greenAccent),
    ];
    dataAPQbad = [
      new OEEBarChart("A", 100 - listOEE[0].value_a, Colors.grey),
      new OEEBarChart("P", 100 - listOEE[0].value_p, Colors.grey),
      new OEEBarChart("Q", 100 - listOEE[0].value_q, Colors.grey),
    ];

    var series = [
      new charts.Series(
        domainFn: (OEEBarChart clickData, _) => clickData.year,
        measureFn: (OEEBarChart clickData, _) => clickData.value,
        colorFn: (OEEBarChart clickData, _) => clickData.color,
        id: 'Availability',
        data: dataA,
      ),
      new charts.Series(
        domainFn: (OEEBarChart clickData, _) => clickData.year,
        measureFn: (OEEBarChart clickData, _) => clickData.value,
        colorFn: (OEEBarChart clickData, _) => clickData.color,
        id: 'Performance',
        data: dataP,
      ),
      new charts.Series(
        domainFn: (OEEBarChart clickData, _) => clickData.year,
        measureFn: (OEEBarChart clickData, _) => clickData.value,
        colorFn: (OEEBarChart clickData, _) => clickData.color,
        id: 'Quality',
        data: dataQ,
      ),
      new charts.Series(
        domainFn: (OEEBarChart clickData, _) => clickData.year,
        measureFn: (OEEBarChart clickData, _) => clickData.value,
        colorFn: (OEEBarChart clickData, _) => clickData.color,
        id: 'OEE',
        data: dataOeeAPQ,
      )..setAttribute(charts.rendererIdKey, 'customLine'),
    ];

    var seriesPiechart = [
      new charts.Series(
        domainFn: (OEEBarChart clickData, _) => clickData.year,
        measureFn: (OEEBarChart clickData, _) => clickData.value,
        colorFn: (OEEBarChart clickData, _) => clickData.color,
        id: 'datePieOEE',
        data: dataOee,
        labelAccessorFn: (OEEBarChart row, _) =>
            row.year == 'Good' ? '${row.value}' : null, //'${row.value}',
        insideLabelStyleAccessorFn: (OEEBarChart sales, _) {
          final color = (sales.year == 'Good')
              ? charts.MaterialPalette.black
              : charts.MaterialPalette.white;
          return new charts.TextStyleSpec(color: color);
        },
        outsideLabelStyleAccessorFn: (OEEBarChart sales, _) {
          final color = (sales.year == 'Good')
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.white;
          return new charts.TextStyleSpec(color: color);
        },
        //  row.segment == 'Main' ? '${segment.value}' : null,
      ),
    ];

    var seriesHorizontalBar = [
      new charts.Series(
        domainFn: (OEEBarChart clickData, _) => clickData.year,
        measureFn: (OEEBarChart clickData, _) => clickData.value,
        colorFn: (OEEBarChart clickData, _) => clickData.color,
        id: 'dateAPQGood',
        data: dataAPQgood,
        labelAccessorFn: (OEEBarChart clickData, _) =>
            '${format(clickData.value).toString()} %',
        insideLabelStyleAccessorFn: (OEEBarChart sales, _) {
          final color = (sales.year == '2014')
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.green.shadeDefault.darker;
          return new charts.TextStyleSpec(color: color);
        },
        outsideLabelStyleAccessorFn: (OEEBarChart sales, _) {
          final color = (sales.year == '2014')
              ? charts.MaterialPalette.red.shadeDefault
              : charts.MaterialPalette.white;
          return new charts.TextStyleSpec(color: color);
        },
      ),
      new charts.Series(
        domainFn: (OEEBarChart clickData, _) => clickData.year,
        measureFn: (OEEBarChart clickData, _) => clickData.value,
        colorFn: (OEEBarChart clickData, _) => clickData.color,
        id: 'dataAPQbad',
        data: dataAPQbad,
        labelAccessorFn: (OEEBarChart clickData, _) => ' ',
      ),
    ];

    var chart = new charts.OrdinalComboChart(
      series,
      animate: true,
      behaviors: [
        new charts.SeriesLegend(
          // defaultHiddenSeries: ['A Line','P Line','Q Line'],
          // Positions for "start" and "end" will be left and right respectively
          // for widgets with a build context that has directionality ltr.
          // For rtl, "start" and "end" will be right and left respectively.
          // Since this example has directionality of ltr, the legend is
          // positioned on the right side of the chart.
          position: charts.BehaviorPosition.bottom,
          // For a legend that is positioned on the left or right of the chart,
          // setting the justification for [endDrawArea] is aligned to the
          // bottom of the chart draw area.
          //outsideJustification: charts.OutsideJustification.endDrawArea,
          // By default, if the position of the chart is on the left or right of
          // the chart, [horizontalFirst] is set to false. This means that the
          // legend entries will grow as new rows first instead of a new column.
          horizontalFirst: true,
          // By setting this value to 2, the legend entries will grow up to two
          // rows before adding a new column.
          desiredMaxRows: 2,
          // This defines the padding around each legend entry.
          cellPadding: new EdgeInsets.only(left: 4.0, right: 4.0, bottom: 4.0),
          // Render the legend entry text with custom styles.
          entryTextStyle: charts.TextStyleSpec(
              color: charts.Color(r: 150, g: 150, b: 150),
              fontFamily: 'Rock Salt',
              fontSize: 13),
        )
      ],
      defaultRenderer: new charts.BarRendererConfig(
          groupingType: charts.BarGroupingType.grouped),
      customSeriesRenderers: [
        new charts.LineRendererConfig(
            // ID used to link series to this renderer.
            customRendererId: 'customLine'),
      ],

      // barGroupingType: charts.BarGroupingType.grouped,
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 8, // size in Pts.
                  color: charts.MaterialPalette.gray.shade500),
              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.gray.shade500))),

      primaryMeasureAxis: new charts.NumericAxisSpec(
          /*  tickProviderSpec: new charts.BasicNumericTickProviderSpec(
              desiredTickCount: 10,
            ),*/
          /* tickProviderSpec: new charts.StaticNumericTickProviderSpec(
            <charts.TickSpec<num>>[
              charts.TickSpec<num>(0),
              charts.TickSpec<num>(5),
              charts.TickSpec<num>(10),
              charts.TickSpec<num>(15),
              charts.TickSpec<num>(20),
                 charts.TickSpec<num>(25),
                     charts.TickSpec<num>(30),
            ],
          ), */
          renderSpec: new charts.GridlineRendererSpec(
        labelStyle: new charts.TextStyleSpec(
            fontSize: 12, // size in Pts.
            color: charts.MaterialPalette.gray.shade500),
        // Display the measure axis labels below the gridline.
        //
        // 'Before' & 'after' follow the axis value direction.
        // Vertical axes draw 'before' below & 'after' above the tick.
        // Horizontal axes draw 'before' left & 'after' right the tick.
        labelAnchor: charts.TickLabelAnchor.before,

        // Left justify the text in the axis.
        //
        // Note: outside means that the secondary measure axis would right
        // justify.
        labelJustification: charts.TickLabelJustification.outside,
      )),
    );

    var horizontalchart = new charts.BarChart(
      seriesHorizontalBar,
      vertical: false,
      animate: true,
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.SmallTickRendererSpec(
              // Tick and Label styling here.
              labelStyle: new charts.TextStyleSpec(
                  fontSize: 15, // size in Pts.
                  color: charts.MaterialPalette.white),

              // Change the line colors to match text color.
              lineStyle: new charts.LineStyleSpec(
                  color: charts.MaterialPalette.white))),
      barGroupingType: charts.BarGroupingType.stacked,
    );

    var piechart = new charts.PieChart(seriesPiechart,
        animate: true,
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 40, startAngle: 2 / 4 * (22 / 7),
            //arcLength: 9 / 5 * (22/7),
            arcRendererDecorators: [new charts.ArcLabelDecorator()]));

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new SizedBox(
        height: ((queryData.size.height - 100) / 2),
        child: chart,
      ),
    );

    var horizontalchartOee = new Padding(
      padding: new EdgeInsets.all(5.0),
      child: new SizedBox(
        height: ((queryData.size.height - 50) / 4),
        width: ((queryData.size.width - 10) / 2),
        child: horizontalchart,
      ),
    );

    var piechartOEE = new Padding(
      padding: new EdgeInsets.all(0.0),
      child: new SizedBox(
        height: ((queryData.size.height - 50) / 4),
        width: ((queryData.size.width - 10) / 2),
        child: piechart,
      ),
    );

    return new Scaffold(
      body: new Center(
          child: new Column(
        children: <Widget>[
          Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(' ',
                    style: new TextStyle(
                      fontFamily: "Rock Salt",
                      fontSize: 10.0,
                    )),
                new Text(
                  "Sausage Automation Line",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontFamily: "Rock Salt",
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                    fontSize: 25.0,
                  ),
                ),
                new Text(
                  "  ",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontFamily: "Rock Salt",
                    color: Colors.greenAccent,
                    fontSize: 15.0,
                  ),
                ),
                new Text(
                  " OEE Value @ ${listOEE[0].namedate}  ",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontFamily: "Rock Salt",
                    fontSize: 20.0,
                  ),
                )
              ],
            ),
            //2nd Child
          ),
          Container(
              child: new Row(
            children: [
              Container(
                child: new Padding(
                  padding: new EdgeInsets.all(15.0),
                  child: new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      /*   new Text(
                      'OEE Value ',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        fontFamily: "Rock Salt",
                        fontSize: 20.0,
                      ),
                    ),*/
                      new CircularPercentIndicator(
                        radius: ((queryData.size.width - 100) / 2),
                        animation: true,
                        animationDuration: 1200,
                        lineWidth: 20.0,
                        percent: double.parse(format(
                            (((listOEE[0].value_a / 100) *
                                    (listOEE[0].value_q / 100) *
                                    (listOEE[0].value_p / 100)) *
                                10))),
                        center: new Text(
                          "${double.parse(format((((listOEE[0].value_a / 100) * (listOEE[0].value_q / 100) * (listOEE[0].value_p / 100)) * 100)))} %",
                          style: new TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                        circularStrokeCap: CircularStrokeCap.butt,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.greenAccent[200],
                      ),
                      //piechartOEE,
                    ],
                  ),
                ),
              ),
              Container(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    /*  new Text(
                      'APQ Value',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        fontFamily: "Rock Salt",
                        fontSize: 20.0,
                      ),
                    ),
                                    new Text(
                      '${listOEE[0].namedate}',
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                        fontFamily: "Rock Salt",
                        fontSize: 15.0,
                      ),
                    ),*/
                    //  horizontalchartOee,
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: new LinearPercentIndicator(
                        animation: true,
                        animationDuration: 600,
                        width: ((queryData.size.width - 50) / 2),
                        lineHeight: 25.0,
                        percent:
                            double.parse(format((listOEE[0].value_a))) / 100,
                        center: Text(
                          "A: ${double.parse(format((listOEE[0].value_a)))} %",
                          style: new TextStyle(fontSize: 12.0),
                        ),
                        leading: Icon(Icons.accessible),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.greenAccent[100],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: new LinearPercentIndicator(
                        animation: true,
                        animationDuration: 600,
                        width: ((queryData.size.width - 50) / 2),
                        lineHeight: 25.0,
                        percent:
                            double.parse(format((listOEE[0].value_p))) / 100,
                        center: Text(
                          "P: ${double.parse(format((listOEE[0].value_p)))} %",
                          style: new TextStyle(fontSize: 12.0),
                        ),
                        leading: Icon(Icons.ev_station),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.greenAccent,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: new LinearPercentIndicator(
                        animation: true,
                        animationDuration: 600,
                        width: ((queryData.size.width - 50) / 2),
                        lineHeight: 25.0,
                        percent:
                            double.parse(format((listOEE[0].value_q))) / 100,
                        center: Text(
                          "Q: ${double.parse(format((listOEE[0].value_q)))} %",
                          style: new TextStyle(fontSize: 12.0),
                        ),
                        leading: Icon(Icons.gps_fixed),
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        backgroundColor: Colors.grey,
                        progressColor: Colors.tealAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          )),
          Container(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  " ",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontFamily: "Rock Salt",
                    fontSize: 15.0,
                  ),
                ),
                new Text(
                  "OEE Trend 4 weeks history",
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                    fontFamily: "Rock Salt",
                    fontSize: 20.0,
                  ),
                ),
                chartWidget,
              ],
            ),
            //2nd Child
          ),
        ],
      )),
    );
  }
}

Future<List<OEE>> fetchOEE() async {
  final response = await http.get(
      'https://us-central1-cpf-innovation-mes.cloudfunctions.net/Test_Consume_OEE_Flutter');
  List<OEE> listRet = new List<OEE>();

  if (response.statusCode == 200) {
    // If the call to the server was successful, parse the JSON
    for (int i = 0; i <= json.decode(response.body).length - 1; i++) {
      listRet.add(OEE.fromJson(json.decode(response.body)[i]));
    }
    return listRet;
  } else {
    // If that call was not successful, throw an error.
    throw Exception('Failed to load post');
  }
}

class OEEList {
  List<OEE> listP = new List<OEE>();
}

class OEE {
  final double value_q;
  final double value_a;
  final double value_p;
  final String namedate;

  OEE({this.namedate, this.value_p, this.value_q, this.value_a});

  factory OEE.fromJson(Map<String, dynamic> json) {
    return OEE(
      namedate: json['name_date'],
      value_p: double.parse(json['value_p']),
      value_q: double.parse(json['value_q']),
      value_a: double.parse(json['value_a']),
    );
  }
}
