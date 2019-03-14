import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:drawer_demo/fragments/third_fragment.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
  

class HomePageFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: FutureBuilder<List<OEE>>(
        future: fetchOEE(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<OEE> values = snapshot.data;
            return new MyHomePageFragment(
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
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 10.0,
        color: Color(0xFF999999),
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x99999999),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }

  Future<List<OEE>> fetchOEE() async {
    final response = await http.get(
        'https://us-central1-cpf-innovation-mes.cloudfunctions.net/Test_Consume_HomePage_Flutter');
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
}

class MyHomePageFragment extends StatefulWidget {
  MyHomePageFragment({Key key, this.listOEE}) : super(key: key);

  final List<OEE> listOEE;

  @override
  _MyHomePageFragmentState createState() =>
      new _MyHomePageFragmentState(listOEE: listOEE);
}

class _MyHomePageFragmentState extends State<MyHomePageFragment> {
  _MyHomePageFragmentState({this.listOEE});

  final List<OEE> listOEE;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    List<OEEBarChart> dataA = new List<OEEBarChart>();
    var dataP;
    var dataQ;

    var dataOeeAPQ;

    var dataOee;

    var dataAPQgood;
    var dataAPQbad;

    for (int i = 1; i <= listOEE.length - 1; i++) {
      dataA.add(new OEEBarChart(i.toString(), listOEE[i].value_a, Colors.red));
    }

    final dataGauge = [
      new OEEBarChart('20%', 75, Colors.red[700]),
      new OEEBarChart('40%', 75, Colors.orange[800]),
      new OEEBarChart('60%', 75, Colors.yellow),
      new OEEBarChart('80%', 75, Colors.lightGreenAccent[400]),
      new OEEBarChart('100%', 75, Colors.green[800]),
    ];

    final dataPie = [
      new OEEBarChart('20%', 75, Colors.lightGreenAccent[100]),
      new OEEBarChart('40%', 75, Colors.lightGreen[400]),
      new OEEBarChart('60%', 75, Colors.green[300]),
    ];

    var seriesGauge = [
      new charts.Series(
        domainFn: (OEEBarChart clickData, _) => clickData.year,
        measureFn: (OEEBarChart clickData, _) => clickData.value,
        colorFn: (OEEBarChart clickData, _) => clickData.color,
        id: 'dataGauge',
        labelAccessorFn: (OEEBarChart row, _) => '${row.year}',
        data: dataGauge,
      ),
    ];

    var seriesPie = [
      new charts.Series(
        domainFn: (OEEBarChart clickData, _) => clickData.year,
        measureFn: (OEEBarChart clickData, _) => clickData.value,
        colorFn: (OEEBarChart clickData, _) => clickData.color,
        id: 'dataPie',
        labelAccessorFn: (OEEBarChart row, _) => '${row.year}',
        data: dataPie,
      ),
    ];

    var series = [
      new charts.Series(
        domainFn: (OEEBarChart clickData, _) => clickData.year,
        measureFn: (OEEBarChart clickData, _) => clickData.value,
        colorFn: (OEEBarChart clickData, _) => clickData.color,
        id: 'OEE',
        data: dataA,
      )..setAttribute(charts.rendererIdKey, 'customLine'),
    ];

    var gaugeChart = new charts.PieChart(seriesGauge,
        animate: true,
        // Configure the width of the pie slices to 30px. The remaining space in
        // the chart will be left as a hole in the center. Adjust the start
        // angle and the arc length of the pie so it resembles a gauge.
        defaultRenderer: new charts.ArcRendererConfig(
            arcWidth: 20,
            startAngle: 4 / 5 * (22 / 7),
            arcLength: 7 / 5 * (22 / 7),
            arcRendererDecorators: [
              new charts.ArcLabelDecorator(
                  insideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 7),
                  labelPosition: charts.ArcLabelPosition.inside)
            ]));

    var pieChart = new charts.PieChart(seriesPie,
        animate: true,
        // Configure the width of the pie slices to 30px. The remaining space in
        // the chart will be left as a hole in the center. Adjust the start
        // angle and the arc length of the pie so it resembles a gauge.
          behaviors: [new charts.DatumLegend( position: charts.BehaviorPosition.bottom,   
          cellPadding: new EdgeInsets.only(right: 4.0, bottom: 2.0),
          entryTextStyle: charts.TextStyleSpec(
              color: charts.Color(r: 0, g: 0, b: 0),
              fontFamily: 'Rock Salt',
              fontSize: 8))],
        defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [
          new charts.ArcLabelDecorator(
              insideLabelStyleSpec: new charts.TextStyleSpec(fontSize: 7),
              labelPosition: charts.ArcLabelPosition.inside)
        ]));

    var chart = new charts.OrdinalComboChart(
      series,
      animate: true,

      customSeriesRenderers: [
        new charts.LineRendererConfig(
            // ID used to link series to this renderer.
            customRendererId: 'customLine'),
      ],

      // barGroupingType: charts.BarGroupingType.grouped,
      domainAxis: new charts.OrdinalAxisSpec(
          // Make sure that we draw the domain axis line.
          showAxisLine: true,
          // But don't draw anything else.
          renderSpec: new charts.NoneRenderSpec()),

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
            color: charts.MaterialPalette.black),
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

    var chartWidget = new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new SizedBox(
        height: ((queryData.size.height - 250) / 4),
        width: ((queryData.size.width - 100)),
        child: chart,
      ),
    );

    var chartGaugeWidget = new Padding(
      padding: new EdgeInsets.all(0.0),
      child: new SizedBox(
        height: ((queryData.size.height - 100) / 4),
        width: ((queryData.size.width - 85) / 2),
        child: gaugeChart,
      ),
    );

    var charPieWidget = new Padding(
      padding: new EdgeInsets.all(0.0),
      child: new SizedBox(
        height: ((queryData.size.height - 140) / 4),
        width: ((queryData.size.width - 90) / 2),
        child: pieChart,
      ),
    );

    return new Scaffold(
        body: StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: <Widget>[
        _buildTile(
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Performance Rate',
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w700)),
                      Text('265K',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 34.0)),
                                  new LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 70,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 2500,
                percent: 0.8,
                center: Text("80.0%"),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.green,
              ),
                    ],
                  ),
 
                ]),
          ),
        ),
        _buildTile(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //Padding(padding: EdgeInsets.only(bottom: 16.0)),
                  Text('Product Percentage',
                      style: TextStyle(
                          color: Colors.green[900],
                          fontWeight: FontWeight.w700,
                          fontSize: 17.0)),
                  charPieWidget
                ]),
          ),
        ),
        _buildTile(
          Padding(
              padding: const EdgeInsets.only(
                  left: 10, right: 10, top: 10, bottom: 5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Yield',
                              style: TextStyle(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20.0)),
                          /* Text('${listOEE[listOEE.length - 1].namedate} ',
                              style: TextStyle(
                                  color: Colors.lightGreen[600],
                                  fontSize: 8.0)),*/
                          chartGaugeWidget,
                          Text('Input: xxxx       Output: xxxx',
                              style: TextStyle(
                                  color: Colors.blueGrey, fontSize: 10.0)),
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.only(bottom: 4.0)),
                ],
              )),
        ),
        _buildTile(
          Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Performance OEE',
                              style: TextStyle(
                                  color: Colors.green[900],
                                  fontWeight: FontWeight.w700,
                                  fontSize: 25.0)),
                          Text('${listOEE[listOEE.length - 1].namedate} ',
                              style: TextStyle(
                                  color: Colors.lightGreen[600],
                                  fontSize: 10.0)),
                          chartWidget,
                        ],
                      ),
                    ],
                  ),
                  // Padding(padding: EdgeInsets.only(bottom: 4.0)),
                ],
              )),
        ),
        _buildTile(
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Shop Items',
                          style: TextStyle(color: Colors.redAccent)),
                      Text('173',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                              fontSize: 34.0))
                    ],
                  ),
                  Material(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(24.0),
                      child: Center(
                          child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child:
                            Icon(Icons.store, color: Colors.white, size: 30.0),
                      )))
                ]),
          ),
          onTap: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => ThirdFragment())),
        )
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, ((queryData.size.height) / 6)),
        StaggeredTile.extent(1, ((queryData.size.height) / 3)),
        StaggeredTile.extent(1, ((queryData.size.height) / 3)),
        StaggeredTile.extent(2, ((queryData.size.height - 30) / 3)),
        //StaggeredTile.extent(2, ((queryData.size.height -10 ) / 4)),
      ],
    ));
  }

  Widget _buildTile(Widget child, {Function() onTap}) {
    return Material(
        elevation: 10.0,
        color: Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(12.0),
        shadowColor: Color(0x99999999),
        child: InkWell(
            // Do onTap() if it isn't null, otherwise do print()
            onTap: onTap != null
                ? () => onTap()
                : () {
                    print('Not set yet');
                  },
            child: child));
  }
}

class OEEList {
  List<OEE> listP = new List<OEE>();
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

class OEE {
  final double value_q;
  final double value_a;
  final double value_p;
  final String namedate;

  OEE({this.namedate, this.value_p, this.value_q, this.value_a});

  factory OEE.fromJson(Map<String, dynamic> json) {
    return OEE(
      namedate: json['last_update_date'],
      value_p: double.parse(json['value_p']),
      value_q: double.parse(json['value_q']),
      value_a: double.parse(json['value_a']),
    );
  }
}
