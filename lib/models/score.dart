import 'package:flutter/material.dart';

Positioned score(_score) {
  return Positioned(
    right: 10.0,
    top: 10.0,
    child: Text(
      '$_score',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 25,
        color: Colors.amberAccent,
      ),
    ),
  );
}
