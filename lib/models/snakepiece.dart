import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';

class SnakePiece extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      width: SNAKEPIECE_SIZE,
      height: SNAKEPIECE_SIZE,
      decoration: BoxDecoration(
        color: Colors.blue[300],
        border: Border.all(
          style: BorderStyle.solid,
        ),
      ),
    );
  }
}
