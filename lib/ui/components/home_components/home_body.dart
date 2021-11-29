import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../infra/infra.dart';
import '../../../ui/ui.dart';

Widget homeBody(BuildContext context) {
  final TimerProvider time = Provider.of(context);
  final GPSProvider gps = Provider.of(context);
  final AcceleratorProvider acc = Provider.of(context);

  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const TimerCounterClass(),
        iconButtonMainScreen(
          context,
          'GPS',
          const Icon(Icons.gps_fixed),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChronometerPage(name: 'GPS', time: time.counter),
              ),
            );
            // SAVE DATA FOR GPS PROVIDER!
          },
        ),
        iconButtonMainScreen(
          context,
          'Accelerometer',
          const Icon(Icons.sensors),
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ChronometerPage(name: 'Accelerometer', time: time.counter),
              ),
            );
            // SAVE DATA FOR ACC PROVIDER!
          },
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.RESULT);
            },
            child: const Text(
              'Results',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    ),
  );
}
