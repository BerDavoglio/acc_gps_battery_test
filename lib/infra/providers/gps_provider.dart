import 'package:flutter/material.dart';

import '../../ui/ui.dart';

class GPSProvider with ChangeNotifier {
  List<List<num>> _data = [];

  get data => _data;

  List<dataModel> batteryData() {
    List<dataModel> gpsChartData = [];
    _data.asMap().forEach((index, element) {
      gpsChartData.add(dataModel(index, element[1].toInt()));
    });
    return gpsChartData;
  }

  Future<void> savePosition(double vel, int bat) async {
    List<num> mapa = [vel, bat];
    _data.add(mapa);
  }

  double averageSpeed() {
    var vel = 0.0;
    var counter = 0;

    _data.forEach((element) {
      vel += element[0];
      counter++;
    });

    return counter != 0 ? vel / counter : 0;
  }

  double maxBattery() {
    if (_data.isNotEmpty) {
      return _data.first[1].toDouble();
    } else {
      return 0.0;
    }
  }

  double minBattery() {
    if (_data.isNotEmpty) {
      return _data.last[1].toDouble();
    } else {
      return 0.0;
    }
  }

  void cleanData() {
    _data.clear();
  }

  num difBattery() {
    if (_data.isEmpty) return 0;
    return (_data.first[1] - _data.last[1]);
  }
}
