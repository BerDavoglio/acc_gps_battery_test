import 'dart:async';
import 'dart:math';

import 'package:battery_info/battery_info_plugin.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:sensors_plus/sensors_plus.dart';

import '../../infra/infra.dart';

class ChronometerPage extends StatefulWidget {
  String name;
  int time;

  ChronometerPage({required this.time, required this.name, Key? key})
      : super(key: key);

  @override
  _ChronometerPageState createState() =>
      _ChronometerPageState(name: name, timeCountDown: time);
}

class _ChronometerPageState extends State<ChronometerPage> {
  int timeCountDown;
  String name;
  Duration duration = const Duration();
  Timer? timer;
  bool countDown = true;
  double velocity = 0;
  double highestVelocity = 0.0;
  var velocityGeneral = 0.0;
  StreamSubscription? _getPositionSubscription;

  _ChronometerPageState({required this.timeCountDown, required this.name});

  get _name => name;
  int batterylevel = 0;

  @override
  void initState() {
    super.initState();

    _onInitGPSAcc();

    reset();
    startTimer();
  }

  @override
  void dispose() {
    _getPositionSubscription?.cancel();
    super.dispose();
  }

  void cleanData() {
    final GPSProvider gps = Provider.of(context);
    final AcceleratorProvider acc = Provider.of(context);

    if (_name == 'GPS') {
      gps.cleanData();
    } else if (_name == 'Accelerometer') {
      acc.cleanData();
    }
  }

  void _onInitGPSAcc() async {
    final GPSProvider gps = Provider.of(context);
    final AcceleratorProvider acc = Provider.of(context);

    if (_name == 'GPS') {
      gps.cleanData();
      _getPositionSubscription = Geolocator.getPositionStream(
        timeLimit: Duration(minutes: timeCountDown),
        intervalDuration: const Duration(seconds: 1),
      ).listen(
        (Position position) async {
          batterylevel =
              (await BatteryInfoPlugin().androidBatteryInfo)!.batteryLevel!;
          var speedInMps = position.speed;
          velocityGeneral = speedInMps;
          gps.savePosition(speedInMps, batterylevel);
        },
      );
    } else if (_name == 'Accelerometer') {
      acc.cleanData();
      userAccelerometerEvents.listen(
        (UserAccelerometerEvent event) async {
          batterylevel =
              (await BatteryInfoPlugin().androidBatteryInfo)!.batteryLevel!;
          velocityGeneral =
              sqrt(event.x * event.x + event.y * event.y + event.z * event.z); // THIS IS A ACCELERATION AVERAGE
          acc.savePosition(event.x, event.y, event.z, batterylevel);
          await Future.delayed(const Duration(seconds: 1));
        },
      );
    }
  }

  Future<void> _finishTask(String string) async {
    Navigator.of(context).pop();
    dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            buildTime(),
            const SizedBox(
              height: 40,
            ),
            Container(
              child: Text(
                '${velocityGeneral.toStringAsFixed(3)} m/s',
                style: const TextStyle(
                  fontSize: 40,
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            buildButtons()
          ],
        ),
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours, header: 'HOURS'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: minutes, header: 'MINUTES'),
      const SizedBox(
        width: 8,
      ),
      buildTimeCard(time: seconds, header: 'SECONDS'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(20)),
          child: Text(
            time,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 50),
          ),
        ),
        const SizedBox(
          height: 24,
        ),
        Text(header, style: const TextStyle(color: Colors.black45)),
      ],
    );
  }

  Widget buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ButtonWidget(
            text: "CANCEL",
            onClicked: () {
              stopTimer();
              _finishTask(name);
              cleanData();
            }),
      ],
    );
  }

  void reset() {
    if (countDown) {
      setState(() => duration = Duration(minutes: timeCountDown));
    } else {
      setState(() => duration = const Duration());
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  void addTime() {
    final addSeconds = countDown ? -1 : 1;
    setState(() {
      final seconds = duration.inSeconds + addSeconds;
      if (seconds < 0) {
        timer?.cancel();
        _finishTask(name);
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void stopTimer({bool resets = true}) {
    if (resets) {
      reset();
    }
    setState(() => timer?.cancel());
  }
}

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color color;
  final Color backgroundColor;
  final VoidCallback onClicked;

  const ButtonWidget(
      {Key? key,
      required this.text,
      required this.onClicked,
      this.color = Colors.white,
      this.backgroundColor = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ElevatedButton.styleFrom(
          primary: backgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
      onPressed: onClicked,
      child: Text(
        text,
        style: TextStyle(fontSize: 20, color: color),
      ));
}
