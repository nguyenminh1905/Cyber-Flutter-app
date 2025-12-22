
import 'package:flutter/material.dart';
import 'package:flutter_cyber_app/nav/main_navigation.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cyber_app/providers/car_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ChangeNotifierProvider(
      create: (_) => CarProvider(),
      child: MyApp(),
    ),);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(canvasColor: Colors.green),
      home: MainNavigation(),
    );
  }
}


