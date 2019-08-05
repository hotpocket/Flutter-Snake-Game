import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';

class Snake extends StatelessWidget {
  final String choice;
  Snake(this.choice);

  Widget _getImage() {
    if (choice == 'head') {
      return Image.asset(
        'assets/sprite/head.png',
        fit: BoxFit.contain,
      );
    } else if (choice == 'tail') {
      return Image.asset(
        'assets/sprite/tail.png',
        fit: BoxFit.contain,
      );
    } else {
      return Image.asset(
        'assets/sprite/body.png',
        fit: BoxFit.contain,
      );
    }
  }

  Widget build(BuildContext context) {
    return Container(
      child: _getImage(),
      width: SNAKE_SIZE,
      height: SNAKE_SIZE,
    );
  }
}
