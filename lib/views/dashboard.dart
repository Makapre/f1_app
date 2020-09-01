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
  String firstDriver = "";
  String secondDriver = "";
  String thirdDriver = "";
  String firstConstructor = "";
  String secondConstructor = "";
  String thirdConstructor = "";

  @override
  void initState() {
    super.initState();
    getNextRaceName();
    getNextRaceDate();
    getTopThreeDrivers();
    getTopThreeConstructors();
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        titleCard(),
        driverStandingsCard(),
        constructorStandingsCard(),
        upcomingRacesCard(),
        pastRacesCard()
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

  Widget driverStandingsCard() {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: new Text("Fahrer", style: TextStyle(fontWeight: FontWeight.bold)),
            title: new Column(
              children: <Widget>[
                new Text(firstDriver),
                new Text(secondDriver),
                new Text(thirdDriver)
              ]
            )
          )
        ],
      ),
      color: Colors.grey
    );
  }

  Widget constructorStandingsCard() {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: new Text("Teams", style: TextStyle(fontWeight: FontWeight.bold)),
            title:  new Column(
              children: <Widget>[
                new Text(firstConstructor),
                new Text(secondConstructor),
                new Text(thirdConstructor)
              ]
            ),
          )
        ],
      ),
      color: Colors.grey
    );
  }

  Widget upcomingRacesCard() {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: new Icon(Icons.arrow_forward_ios),
            title: Text("Nächste Rennen", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
      color: Colors.grey
    );
  }

  Widget pastRacesCard() {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: new Icon(Icons.arrow_back_ios),
            title: Text("Letzte Rennen", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold)),
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
    if(differenceMinutes == 60) differenceHours += 1;

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

    setState(() {
      if (response.statusCode == 200) {
        String nextRacename = json.decode(response.body)['MRData']['RaceTable']['Races'][0]['raceName'];
        String nextRacecity = json.decode(response.body)['MRData']['RaceTable']['Races'][0]['Circuit']['Location']['locality'];

        nextRaceName = '$nextRacename at $nextRacecity';
      }
    });
  }

  void getTopThreeDrivers() async {
    final response = await http.get('http://ergast.com/api/f1/current/driverStandings.json');

    setState(() {
      if (response.statusCode == 200) {
        // #1
        String givenName1 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'][0]['Driver']['givenName'];
        String familyName1 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'][0]['Driver']['familyName'];
        String points1 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'][0]['points'];
        // #2
        String givenName2 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'][1]['Driver']['givenName'];
        String familyName2 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'][1]['Driver']['familyName'];
        String points2 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'][1]['points'];
        // #3
        String givenName3 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'][2]['Driver']['givenName'];
        String familyName3 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'][2]['Driver']['familyName'];
        String points3 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['DriverStandings'][2]['points'];

        firstDriver = "$points1 : $givenName1 $familyName1";
        secondDriver = "$points2 : $givenName2 $familyName2";
        thirdDriver = "$points3 : $givenName3 $familyName3";
      }
    });
  }

  void getTopThreeConstructors() async {
    final response = await http.get('http://ergast.com/api/f1/current/constructorStandings.json');

    setState(() {
      if (response.statusCode == 200) {
        // #1
        String name1 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'][0]['Constructor']['name'];
        String points1 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'][0]['points'];
        // #2
        String name2 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'][1]['Constructor']['name'];
        String points2 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'][1]['points'];
        // #3
        String name3 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'][2]['Constructor']['name'];
        String points3 = json.decode(response.body)['MRData']['StandingsTable']['StandingsLists'][0]['ConstructorStandings'][2]['points'];

        firstConstructor = "$points1 : $name1";
        secondConstructor = "$points2 : $name2";
        thirdConstructor = "$points3 : $name3";
      }
    });
  }

  void getNextRaceDate() async {
    final response = await http.get('http://ergast.com/api/f1/current/next.json');

    setState(() {
      if (response.statusCode == 200) {
        String nextRacedate = json.decode(response.body)['MRData']['RaceTable']['Races'][0]['date'];
        String nextRacetime = json.decode(response.body)['MRData']['RaceTable']['Races'][0]['time'];

        nextRaceDate = '$nextRacedate $nextRacetime';
      }
    });
  }
}
