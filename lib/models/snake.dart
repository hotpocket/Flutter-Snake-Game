import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';

class Snake extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      width: SNAKE_SIZE,
      height: SNAKE_SIZE,
      decoration: BoxDecoration(
        color: Colors.blue[300],
        border: Border.all(
          style: BorderStyle.solid,
        ),
      ),
    );
  }
}
