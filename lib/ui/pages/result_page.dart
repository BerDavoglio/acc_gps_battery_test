import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../ui.dart';

import '../../infra/infra.dart';

class dataModel {
  final int timer;
  final int battery;

  dataModel(this.timer, this.battery);
}

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key}) : super(key: key);

  _criarLinhaTable(String listaNomes) {
    return TableRow(
      children: listaNomes.split(',').map((name) {
        return Container(
          height: 60,
          alignment: Alignment.center,
          child: Text(
            name,
            style: TextStyle(fontSize: 20.0),
          ),
          padding: EdgeInsets.all(8.0),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final GPSProvider gps = Provider.of(context);
    final AcceleratorProvider acc = Provider.of(context);

    List<dataModel> gpsChart() {
      final List<dataModel> gpsChartData = gps.batteryData();
      return gpsChartData;
    }

    List<dataModel> accChart() {
      final List<dataModel> accChartData = acc.batteryData();
      return accChartData;
    }

    double minBat() {
      if (gps.minBattery() < acc.minBattery()) {
        return gps.minBattery();
      } else {
        return acc.minBattery();
      }
    }

    double maxBat() {
      if (gps.maxBattery() < acc.maxBattery()) {
        return acc.maxBattery();
      } else {
        return gps.maxBattery();
      }
    }

    return Scaffold(
      appBar: const AppHeader(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                child: Container(
                  width: 500,
                  height: 400,
                  child: Center(
                    child: Scaffold(
                      body: SfCartesianChart(
                        title: ChartTitle(text: 'Battery vs Time'),
                        series: <ChartSeries>[
                                LineSeries<dataModel, int>(
                                  color: Colors.red,
                                  name: 'GPS',
                                  dataSource: gpsChart(),
                                  xValueMapper: (dataModel sales, _) =>
                                      sales.timer,
                                  yValueMapper: (dataModel sales, _) =>
                                      sales.battery,
                                ),
                                LineSeries<dataModel, int>(
                                  color: Colors.blue,
                                  name: 'Accelerometer',
                                  dataSource: accChart(),
                                  xValueMapper: (dataModel sales, _) =>
                                      sales.timer,
                                  yValueMapper: (dataModel sales, _) =>
                                      sales.battery,
                                ),
                              ],
                        primaryXAxis: NumericAxis(),
                        primaryYAxis: NumericAxis(
                          minimum: minBat(),
                          maximum: maxBat(),
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 7,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
                child: Container(
                  width: 500,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black,
                      width: 7,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Table(
                        columnWidths: const <int, TableColumnWidth>{
                          1: FlexColumnWidth(.4),
                          2: FlexColumnWidth(.4),
                        },
                        border: const TableBorder(
                          horizontalInside: BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                          verticalInside: BorderSide(
                            color: Colors.black,
                            style: BorderStyle.solid,
                            width: 1.0,
                          ),
                        ),
                        children: [
                          _criarLinhaTable("Data, Accelerometer, GPS"),
                          _criarLinhaTable(
                              "Avg. Speed (m/s), ${acc.averageSpeed().toString()}, ${gps.averageSpeed().toString()}"),
                          _criarLinhaTable(
                              "Battery Variation (%), ${acc.difBattery().toString()}, ${gps.difBattery().toString()}"),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
