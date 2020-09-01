import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:f1_app/models/driver.dart';

class DriversWidget extends StatefulWidget {
  DriversWidget({Key key}) : super(key: key);

  @override
  _DriversWidgetState createState() => _DriversWidgetState();
}

class _DriversWidgetState extends State<DriversWidget> {
  List<Driver> drivers = [];

  @override
  void initState() {
    super.initState();
    getDriversList();
    titleCard();
  }

  @override
  Widget build(BuildContext context) {
    return driversList();
  }

  Widget driversList() {
    return drivers.isNotEmpty ? ListView.builder(
      // Let the ListView know how many items it needs to build.
      itemCount: drivers.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final driver = drivers[index];

        return ListTile(
          title: driver.buildDriver(context)
        );
      },
    ) : Text("Keine Fahrer zu kriegen");
  }

  Widget titleCard() {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Fahrer", textAlign: TextAlign.center,)
          )
        ],
      ),
      color: Colors.grey
    );
  }

  void getDriversList() async {
    final response = await http.get('http://ergast.com/api/f1/current/drivers.json');

    setState(() {
      if (response.statusCode == 200) {
        var allDrivers = json.decode(response.body)['MRData']['DriverTable']['Drivers'];
        allDrivers.forEach((driver) => drivers.add(new Driver(driver['givenName'], driver['familyName'], driver['permanentNumber'])));
      }
    });
  }
}
