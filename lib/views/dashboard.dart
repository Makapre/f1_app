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
          color: Colors.grey
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
    var now = new DateTime.now().toUtc();
    var nextRacedate = DateTime.parse(nextRaceDate);
    int differenceDays = nextRacedate.difference(now).inDays;
    int differenceHours = nextRacedate.difference(now).inHours - differenceDays*24;

    return RichText(
      text: TextSpan(
        text: 'Nächstes Rennen ',
        style: TextStyle(
          color: Colors.white
        ),
        // children: difference > 0 ? <TextSpan>[
        //   TextSpan(text: 'in '),
        //   TextSpan(text: '$difference', style: TextStyle(fontWeight: FontWeight.bold)),
        //   TextSpan(text: ' Tagen'),
        // ] : <TextSpan>[TextSpan(text: 'Heute')],
        children: <TextSpan>[
          TextSpan(text: 'in '),
          TextSpan(text: '$differenceDays', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' Tagen & '),
          TextSpan(text: '$differenceHours', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' Stunden'),
        ],
      )
    );
  }

  void getNextRaceName() async {
    final response = await http.get('http://ergast.com/api/f1/current/next.json');
    String nextRacename;
    String nextRacecity;

    if (response.statusCode == 200) {
      nextRacename = json.decode(response.body)['MRData']['RaceTable']['Races'][0]['raceName'];
      nextRacecity = json.decode(response.body)['MRData']['RaceTable']['Races'][0]['Circuit']['Location']['locality'];
    } else {
      nextRacename = json.decode('{ "MRData": { "RaceTable": { "Race": ["raceName": "next Race"] } } }')['MRData']['RaceTable']['Races'][0]['raceName'];
      nextRacecity = "Unknown";
    }

    setState(() {
      nextRaceName = '$nextRacename at $nextRacecity';
    });
  }

  void getNextRaceDate() async {
    final response = await http.get('http://ergast.com/api/f1/current/next.json');
    String nextRacedate;
    String nextRacetime;

    if (response.statusCode == 200) {
      nextRacedate = json.decode(response.body)['MRData']['RaceTable']['Races'][0]['date'];
      nextRacetime = json.decode(response.body)['MRData']['RaceTable']['Races'][0]['time'];
    } else {
      String year = new DateTime.now().year.toString();
      String month = new DateTime.now().month.toString();
      String day = new DateTime.now().day.toString();
      nextRacedate = json.decode('{ "MRData": { "RaceTable": { "Race": ["date": "$year-$month-$day"] } } }')['MRData']['RaceTable']['Races'][0]['date'];
      nextRacetime = "00:00:00Z";
    }

    nextRacedate = nextRacedate + ' ' + nextRacetime;

    setState(() {
      nextRaceDate = '$nextRacedate';
    });
  }
}
