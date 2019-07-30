import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';

class Apple extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
      width: APPLE_SIZE,
      height: APPLE_SIZE,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(APPLE_SIZE),
        border: Border.all(
          style: BorderStyle.solid,
        ),
      ),
    );
  }
}
