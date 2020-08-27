import 'package:flutter/material.dart';

class ConstructorsWidget extends StatelessWidget {
  final Color color;

  ConstructorsWidget(this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
    );
  }
}
