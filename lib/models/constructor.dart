import 'package:flutter/material.dart';
import 'package:f1_app/views/constructor_details.dart';

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildConstructor(BuildContext context);
}

/// A ListItem that contains data to display a heading.
class Constructor implements ListItem {
  final String name;
  final String constructorId;
  final String nationality;

  Constructor(this.name, this.constructorId, this.nationality);

  Widget buildConstructor(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(name),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ConstructorDetailsWidget(this),
                  ),
              );
            }
          )
        ],
      )
    );
  }

  Widget details(){
    return Card(
      child: Column(
        children: <Widget>[
          ListTile(
            title: new Column(
              children: <Widget>[
                new Text(nationality)
              ]
            )
          )
        ],
      )
    );
  }
}
