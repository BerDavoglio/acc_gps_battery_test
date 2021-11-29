import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../infra/infra.dart';

class TimerCounterClass extends StatefulWidget {
  const TimerCounterClass({Key? key}) : super(key: key);

  @override
  _TimerCounterClassState createState() => _TimerCounterClassState();
}

class _TimerCounterClassState extends State<TimerCounterClass> {
  @override
  Widget build(BuildContext context) {
    return timerCounter(context);
  }
}

Widget timerCounter(BuildContext context) {
  final TimerProvider time = Provider.of(context);

  return Padding(
    padding: const EdgeInsets.all(15.0),
    child: Center(
      child: SizedBox(
        width: 250,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            littleContainer(
              context,
              Center(
                child: Text(
                  '${time.counter.toString()} min',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              wid: 120,
              hei: 60,
            ),
            littleContainer(
              context,
              IconButton(
                onPressed: () => time.incrementCounter(),
                icon: const Icon(
                  Icons.add_circle_outline,
                  color: Colors.white,
                ),
              ),
            ),
            littleContainer(
              context,
              IconButton(
                onPressed: () => time.decrementCounter(),
                icon: const Icon(
                  Icons.remove_circle_outline,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget littleContainer(BuildContext context, Widget childWidget,
    {double wid = 60, double hei = 60}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(6),
      color: Theme.of(context).primaryColor,
    ),
    width: wid,
    height: hei,
    child: childWidget,
  );
}
