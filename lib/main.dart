import 'package:flutter/material.dart';
import 'package:week_organizer/di/service_locator.dart';
import 'package:week_organizer/view/cornflower_theme.dart';
import 'package:week_organizer/view/mainPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: cornflowerBlueTheme,
      home:  const Mainpage()
    );
  }
}

