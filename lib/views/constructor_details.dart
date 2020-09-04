import 'package:flutter/material.dart';
import 'package:f1_app/models/constructor.dart';

class ConstructorDetailsWidget extends StatelessWidget {
  final Constructor constructor;

  ConstructorDetailsWidget(this.constructor);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(constructor.name),
      ),
      body: constructor.details()
    );
  }
}
