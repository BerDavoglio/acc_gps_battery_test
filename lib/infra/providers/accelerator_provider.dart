import 'dart:math';

import 'package:flutter/material.dart';

import '../../ui/ui.dart';

class AcceleratorProvider with ChangeNotifier {
  final List<List<num>> _data = [];

  get data => _data;

  List<dataModel> batteryData() {
    List<dataModel> gpsChartData = [];
    _data.asMap().forEach((index, element) {
      gpsChartData.add(dataModel(index, element[3].toInt()));
    });
    return gpsChartData;
  }

  Future<void> savePosition(double x, double y, double z, int bat) async {
    _data.add([x, y, z, bat]);
  }

  double averageSpeed() {
    var velX = 0.0;
    var velY = 0.0;
    var velZ = 0.0;
    var counter = 0;

    _data.forEach((element) {
      velX += element[0];
      velY += element[1];
      velZ += element[2];
      counter++;
    });

    return counter != 0
        ? sqrt(((velX / counter) * (velX / counter)) +
            ((velY / counter) * (velY / counter)) +
            ((velZ / counter) * (velZ / counter)))
        : 0;
  }

  double maxBattery() {
    if (_data.isNotEmpty) {
      return _data.first[3].toDouble();
    } else {
      return 0.0;
    }
  }

  double minBattery() {
    if (_data.isNotEmpty) {
      return _data.last[3].toDouble();
    } else {
      return 0.0;
    }
  }

  void cleanData() {
    _data.clear();
  }

  num difBattery() {
    if (_data.isEmpty) return 0;
    return (_data.first[3] - _data.last[3]);
  }
}
