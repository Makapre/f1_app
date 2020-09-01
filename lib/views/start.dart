import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'dashboard.dart';
import 'drivers.dart';
import 'constructors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StartPage extends StatefulWidget {
  StartPage({Key key}) : super(key: key);

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  // variables
  bool isInternetOn = true;
  int _currentIndex = 0;
  String year = new DateTime.now().year.toString();
  String title = 'F1';

  final List<Widget> _pages = [
    DashboardWidget(),
    DriversWidget(),
    ConstructorsWidget(Colors.green)
  ];

  @override
  void initState() {
    super.initState();
    getConnect();
    getCurrentSeason();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: isInternetOn
            ? connected()
            : notConnected()
    );
  }

  Center notConnected() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            "Bitte überprüfe deine Internetverbindung."
            ),
        ]
      ),
    );
  }

  Scaffold connected() {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          new BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Dashboard'),
          ),
          new BottomNavigationBarItem(
            icon: new Icon(Icons.person),
            title: new Text('Fahrer'),
          ),
          new BottomNavigationBarItem(
            icon: Icon(Icons.supervisor_account),
            title: Text('Teams')
          )
        ],
      )
    );
  }

  void getConnect() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    setState(() {
      if (connectivityResult == ConnectivityResult.none) {
          isInternetOn = false;
      } else {
        isInternetOn = true;
      }
    });
  }

  void getCurrentSeason() async {
    final response = await http.get('http://ergast.com/api/f1/current.json');

    setState(() {
      if (response.statusCode == 200) {
        String currentSeason = fromJsonGetSeason(json.decode(response.body));
        title = 'F1 $currentSeason';
      }
    });
  }

  String fromJsonGetSeason(Map<String, dynamic> json) {
    return json['MRData']['RaceTable']['season'];
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
