import 'package:f1_app/views/driver_details.dart';
import 'package:flutter/material.dart';

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildDriver(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class Driver implements ListItem {
  final String givenName;
  final String familyName;
  final String number;
  final String driverId;
  final String dateOfBirth;
  final String nationality;

  Driver(this.givenName, this.familyName, this.number, this.driverId, this.dateOfBirth, this.nationality);

  Widget buildDriver(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(number),
            title: Text("$givenName $familyName"),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DriverDetailsWidget(this),
                  ),
              );
            }
          )
        ],
      )
    );
  }

  String getName(){
    return "$givenName $familyName";
  }

  Widget details(){
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: new Column(
              children: <Widget>[
                new Text(nationality),
                new Text(dateOfBirth),
                new Text(number)
              ]
            )
          )
        ],
      )
    );
  }
}
