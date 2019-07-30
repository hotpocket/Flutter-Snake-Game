import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final int _highscore;
  HomePage(this._highscore);
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Snake Game',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red[400],
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 40,
              fontFamily: 'Comic Sans',
            ),
          ),
          Text(
            'Highscore: $_highscore',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red[300],
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 40,
              fontFamily: 'Comic Sans',
            ),
          ),
          Text(
            'Please Click to Continue',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.red[400],
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 30,
              fontFamily: 'Comic Sans',
            ),
          )
        ],
      ),
    );
  }

  Widget _highScoreWidget () {
    if (_highscore==0) {
      
    }
  }
}
