import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';

class EndGame extends StatelessWidget {
  final GAMESTATE _state;
  final int _highscore;
  final int _score;
  bool _brokeHighscore = false;
  EndGame(this._state, this._score, this._highscore);
  String _highscoreBroken() {
    var text;
    if (_score > _highscore) {
      _brokeHighscore = true;
      text = 'Congratulations! You broke your own highscore!';
    } else {
      text = 'Try harder noob';
    };
    return text;
  }

  String _gameStatus() {
    var _status;
    if (_state == GAMESTATE.VICTORY) {
      _status = 'Congratulations! You are the best!';
    } else if (_state == GAMESTATE.DIED) {
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
            _highscoreBroken(),
            style: TextStyle(
              color: Colors.red[300],
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 30,
              fontFamily: 'Comic Sans',
            ),
          ),
          Text(
            _brokeHighscore ? '' : 'Your score: $_score',
            style: TextStyle(
              color: Colors.red[300],
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 30,
              fontFamily: 'Comic Sans',
            ),
          ),
          Text(
            _brokeHighscore ? 'New Highscore: $_score' : 'Highscore: $_highscore',
            style: TextStyle(
              color: Colors.red[300],
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              fontSize: 30,
              fontFamily: 'Comic Sans',
            ),
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
