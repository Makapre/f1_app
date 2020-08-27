import 'package:flutter/material.dart';
import 'views/start.dart';

void main() => runApp(MainApp());

Map<int, Color> f1Color = {
  50:Color.fromRGBO(225,6,0, .1),
  100:Color.fromRGBO(225,6,0, .2),
  200:Color.fromRGBO(225,6,0, .3),
  300:Color.fromRGBO(225,6,0, .4),
  400:Color.fromRGBO(225,6,0, .5),
  500:Color.fromRGBO(225,6,0, .6),
  600:Color.fromRGBO(225,6,0, .7),
  700:Color.fromRGBO(225,6,0, .8),
  800:Color.fromRGBO(225,6,0, .9),
  900:Color.fromRGBO(225,6,0, 1),
};

MaterialColor mainColor = MaterialColor(0xFFE10600, f1Color);

class MainApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'F1 by Makapre',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: mainColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.green,
      ),
      home: StartPage(),
    );
  }
}
