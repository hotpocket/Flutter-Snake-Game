import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';

class EndGame extends StatelessWidget {
  final GAMESTATE _state;
  final int _highscore;
  final int _score;
  EndGame(this._state, this._score, this._highscore);
  String _gameStatus () {
    var _status;
    if (_state == GAMESTATE.VICTORY) {
      _status = 'Congratulations! You are the best!';
    }
    else if (_state == GAMESTATE.DIED) {
      _status = 'Game Over';
    }
    return _status;
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            _gameStatus(),
            style: TextStyle(
              color: Colors.red[200],
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 40,
              fontFamily: 'Comic Sans',
            ),
          ),
          Text(
            'Your score: $_score',
            style: TextStyle(
              color: Colors.red[300],
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 30,
              fontFamily: 'Comic Sans',
            )
          ),
          Text(
            'Highscore: $_highscore',
            style: TextStyle(
              color: Colors.red[300],
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 30,
              fontFamily: 'Comic Sans',
            )
          ),
          Text(
            'Please Tap To Restart',
            style: TextStyle(
              color: Colors.red[200],
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 30,
              fontFamily: 'Comic Sans',
            ),
          ),
        ],
      ),
    );
  }
}
