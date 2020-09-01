import 'package:f1_app/main.dart';
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
        Container(
          child: titleCard()
        ),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Card(
                  child: titleCard(),
                  color: mainColor
                )
              ),
              Expanded(
                flex: 2,
                child: Card(
                  child: titleCard(),
                  color: mainColor
                )
              ),
            ],
          )
        ),
        Container(
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Card(
                  child: titleCard(),
                  color: mainColor
                )
              ),
              Expanded(
                flex: 2,
                child: Card(
                  child: titleCard(),
                  color: mainColor
                )
              ),
            ],
          )
        )
      ]
    );
  }

  Widget titleCard() {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: new Center(child: daysUntil()),
            subtitle: new Center(child: nextRaceTitle(nextRaceName)),
          )
        ],
      ),
      color: Colors.grey
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
    var now = new DateTime.now().toLocal();
    var nextRacedate = DateTime.parse(nextRaceDate);
    var difference = nextRacedate.difference(now);
    int differenceDays = difference.inDays;
    int differenceHours = difference.inHours - (differenceDays*24);
    int differenceMinutes = difference.inMinutes - differenceDays*1440 - differenceHours*60 + 1;

    return RichText(
      text: TextSpan(
        children: difference.isNegative ? <TextSpan>[TextSpan(text: 'Jetzt')] : <TextSpan>[
          TextSpan(text: '$differenceDays', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' Tagen '),
          TextSpan(text: '$differenceHours', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' Stunden '),
          TextSpan(text: '$differenceMinutes', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: ' Minuten'),
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
      nextRacename = "Next Race";
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
