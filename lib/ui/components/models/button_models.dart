import 'package:denso_test/infra/infra.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


Widget iconButtonMainScreen(
    BuildContext context,
    String text,
    Icon icon,
    Function func,
    ) {
  final GPSProvider gps = Provider.of(context);

  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: SizedBox(
      width: 420,
      height: 100,
      child: ElevatedButton.icon(
        icon: icon,
        label: Text(
          gps.data != [] ? text : 'Remake $text',
          style: const TextStyle(fontSize: 30, color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all(Theme.of(context).primaryColorDark),
        ),
        onPressed: () {
          func();
        },
      ),
    ),
  );
}