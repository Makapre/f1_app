import 'package:flutter/material.dart';
import 'package:f1_app/models/driver.dart';

class DriverDetailsWidget extends StatelessWidget {
  final Driver driver;

  DriverDetailsWidget(this.driver);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(driver.getName()),
      ),
      body: driver.details()
    );
  }
}
