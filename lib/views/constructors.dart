import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:f1_app/models/constructor.dart';

class ConstructorsWidget extends StatefulWidget {
  ConstructorsWidget({Key key}) : super(key: key);

  @override
  _ConstructorsWidgetState createState() => _ConstructorsWidgetState();
}

class _ConstructorsWidgetState extends State<ConstructorsWidget> {
  List<Constructor> constructors = [];

  @override
  void initState() {
    super.initState();
    getConstructorsList();
  }

  @override
  Widget build(BuildContext context) {
    return constructorsList();
  }

  Widget constructorsList() {
    return constructors.isNotEmpty ? ListView.builder(
      // Let the ListView know how many items it needs to build.
      itemCount: constructors.length,
      // Provide a builder function. This is where the magic happens.
      // Convert each item into a widget based on the type of item it is.
      itemBuilder: (context, index) {
        final constructor = constructors[index];

        return ListTile(
          title: constructor.buildConstructor(context)
        );
      },
    ) : Text("Keine Teams zu kriegen");
  }

  void getConstructorsList() async {
    final response = await http.get('http://ergast.com/api/f1/current/constructors.json');

    setState(() {
      if (response.statusCode == 200) {
        var allConstructors = json.decode(response.body)['MRData']['ConstructorTable']['Constructors'];
        allConstructors.forEach((constructor) => constructors.add(new Constructor(constructor['name'], constructor['constructorId'], constructor['nationality'])));
      }
    });
  }
}
