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

  Driver(this.givenName, this.familyName, this.number);

  Widget buildDriver(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            leading: Text(number),
            title: Text("$givenName $familyName")
          )
        ],
      )
    );
  }
}
