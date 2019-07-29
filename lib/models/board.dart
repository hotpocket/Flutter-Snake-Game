import 'package:snake/models/constants.dart';
import 'package:flutter/material.dart';
import 'package:snake/models/snakepiece.dart';
import 'dart:async';
import 'package:snake/models/point.dart';
import 'dart:math';

enum DIRECTION { LEFT, UP, RIGHT, DOWN }
enum GAMESTATE { INIT, RUNNING, VICTORY, DIED }

class Board extends StatefulWidget {
  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> {
  var _gameState = GAMESTATE.INIT;
  var _snakePosition = List();
  var _direction;
  Timer _timer;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _changeDirection(details);
      },
      child: Container(
        child: _getGameState(),
        color: Colors.grey[800],
        width: BOARD_WIDTH,
        height: BOARD_HEIGHT,
      ),
    );
  }

  Widget _getGameState() {
    var child;
    switch (_gameState) {
      case GAMESTATE.INIT:
        _gameInit();
        break;
      case GAMESTATE.RUNNING:
        List<Positioned> snakePieces = List();
        _snakePosition.forEach((i) {
          snakePieces.insert(
            0,
            Positioned(
              child: SnakePiece(),
              left: i.x * SNAKEPIECE_SIZE,
              top: i.y * SNAKEPIECE_SIZE,
            ),
          );
        });
        child = Stack(children: snakePieces);
        break;
      case GAMESTATE.VICTORY:
        break;
      case GAMESTATE.DIED:
        break;
    }
    return child;
  }

  void _gameInit() {
    _snakePosition.insert(
        0,
        Point((BOARD_WIDTH / SNAKEPIECE_SIZE) / 2,
            (BOARD_HEIGHT / SNAKEPIECE_SIZE) / 2));
    _direction = DIRECTION.UP;
    _gameState = GAMESTATE.RUNNING;
    _timer = new Timer.periodic(Duration(milliseconds: 500), _timerTick);
  }

  void _timerTick(Timer timer) {
    _move();
  }

  void _changeDirection(details) {
    setState(() {
      var _swipe = details.delta.direction;
      if (-pi/4 < _swipe && _swipe < pi/4) {
        _direction = DIRECTION.RIGHT;
      }
      else if (-3*pi/4 < _swipe && _swipe > 3*pi/4) {
        _direction = DIRECTION.LEFT;
      }
      else if (-3*pi/4 < _swipe && _swipe < -pi/4) {
        _direction = DIRECTION.UP;
      }
      else if (pi/4 < _swipe && _swipe < 3*pi/4) {
        _direction = DIRECTION.DOWN;
      }
    });
  }

  void _move() {
    setState(() {
      _snakePosition.insert(0, _newHeadPosition());
      _snakePosition.removeLast();
    });
  }

  Point _newHeadPosition() {
    var newHead;
    var currentHeadPos = _snakePosition.first;
    if (currentHeadPos.x * SNAKEPIECE_SIZE < 0) {
      currentHeadPos.x = BOARD_WIDTH / SNAKEPIECE_SIZE;
    } else if (currentHeadPos.x * SNAKEPIECE_SIZE > BOARD_WIDTH) {
      currentHeadPos.x = currentHeadPos.x % BOARD_WIDTH / SNAKEPIECE_SIZE;
    } else if (currentHeadPos.y * SNAKEPIECE_SIZE > BOARD_HEIGHT) {
      currentHeadPos.y = currentHeadPos.y % BOARD_HEIGHT / SNAKEPIECE_SIZE;
    } else if (currentHeadPos.y * SNAKEPIECE_SIZE < 0) {
      currentHeadPos.y = BOARD_HEIGHT / SNAKEPIECE_SIZE;
    }

    switch (_direction) {
      case (DIRECTION.RIGHT):
        newHead = Point(currentHeadPos.x + 1, currentHeadPos.y);
        break;
      case (DIRECTION.DOWN):
        newHead = Point(currentHeadPos.x, currentHeadPos.y + 1);
        break;
      case (DIRECTION.LEFT):
        newHead = Point(currentHeadPos.x - 1, currentHeadPos.y);
        break;
      case (DIRECTION.UP):
        newHead = Point(currentHeadPos.x, currentHeadPos.y - 1);
        break;
    }
    return newHead;
  }
}
