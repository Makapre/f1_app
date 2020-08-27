import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardWidget extends StatefulWidget {
  DashboardWidget({Key key}) : super(key: key);

  @override
  _DashboardWidgetState createState() => _DashboardWidgetState();
}

class _DashboardWidgetState extends State<DashboardWidget> {
  String nextRaceName = "";
  String nextRaceDate = new DateTime.now().toString();

  @override
  void initState() {
    super.initState();
    getNextRaceName();
    getNextRaceDate();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Card(
          child: Column(
            children: <Widget>[
              ListTile(
                title: new Center(child: daysUntil()),
                subtitle: new Center(child: nextRaceTitle(nextRaceName)),
              ),
            ],
          ),
          color: Colors.blueGrey,
        ),
      ]
    );
  }

  Widget nextRaceTitle(nextRace) {
    return Text(
      nextRace,
      style: TextStyle(
        color: Colors.white
      )
    );
  }

  Widget daysUntil() {
    var now = new DateTime.now();
    var year = now.year.toString();
    var month = now.month.toString().padLeft(2, '0');
    var day = now.day.toString();
    var today = DateTime.parse('$year-$month-$day');

    var nextRace = DateTime.parse(nextRaceDate);
    int difference = today == nextRace ? 0 : (nextRace.difference(today).inDays);

    return RichText(
      text: TextSpan(
        text: 'Näschtes Rennen ',
        style: TextStyle(
          color: Colors.white
        ),
        children: difference > 0 ? <TextSpan>[
          TextSpan(text: 'in '),
          TextSpan(text: '$difference', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' Tagen'),
        ] : <TextSpan>[TextSpan(text: 'Heute')],
      )
    );
  }

  void getNextRaceName() async {
    final response = await http.get('http://ergast.com/api/f1/current/next.json');
    String nextRacename;

    if (response.statusCode == 200) {
      nextRacename = json.decode(response.body)['MRData']['RaceTable']['Races'][0]['raceName'];
    } else {
      nextRacename = json.decode('{ "MRData": { "RaceTable": { "Race": ["raceName": "next Race"] } } }')['MRData']['RaceTable']['Races'][0]['raceName'];
    }

    setState(() {
      nextRaceName = '$nextRacename';
    });
  }

  void getNextRaceDate() async {
    final response = await http.get('http://ergast.com/api/f1/current/next.json');
    String nextRacedate;

    if (response.statusCode == 200) {
      nextRacedate = json.decode(response.body)['MRData']['RaceTable']['Races'][0]['date'];
    } else {
      String year = new DateTime.now().year.toString();
      String month = new DateTime.now().month.toString();
      String day = new DateTime.now().day.toString();
      nextRacedate = json.decode('{ "MRData": { "RaceTable": { "Race": ["date": "$year-$month-$day"] } } }')['MRData']['RaceTable']['Races'][0]['date'];
    }

    setState(() {
      nextRaceDate = '$nextRacedate';
    });
  }
}
