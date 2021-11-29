import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../infra/infra.dart';
import '../../ui/ui.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color.fromRGBO(170, 60, 255, 1);
    const primaryColorDark = Color.fromRGBO(170, 50, 220, 1);
    const primaryColorLight = Color.fromRGBO(170, 130, 255, 1);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AcceleratorProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => GPSProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TimerProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TimerProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Denso',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
          primaryColorDark: primaryColorDark,
          primaryColorLight: primaryColorLight,
          backgroundColor: Colors.amber[50],
        ),
        routes: {
          AppRoutes.HOME: (_) => const HomePage(),
          AppRoutes.RESULT: (_) => const ResultPage(),
        },
      ),
    );
  }
}
