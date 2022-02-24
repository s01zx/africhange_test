import 'package:africhange_test/provider/curency_prov.dart';
import 'package:africhange_test/sizeConfig.dart';
import 'package:africhange_test/test_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CurrencyProvider(),
      child: LayoutBuilder(builder: (context, constraints) {
        return OrientationBuilder(builder: (context, orientation) {
          SizeConfig().init(constraints, orientation);
          return MaterialApp(
            title: 'Currency Calc',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: const TestScreen(),
          );
        });
      }),
    );
  }
}
