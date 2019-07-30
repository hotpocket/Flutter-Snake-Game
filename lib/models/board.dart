import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';
import 'package:snake/models/point.dart';
import 'package:snake/models/snake.dart';
import 'package:snake/models/apple.dart';
import 'dart:async';
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
  Point _applePosition;
  Timer _timer;
  Random randomGenerator = Random();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _changeDirection(details);
      },
      child: Container(
        color: Colors.grey[800],
        width: BOARD_WIDTH,
        height: BOARD_HEIGHT,
        child: _getGameState(),
      ),
    );
  }

  Widget _getGameState() {
    var child;
    switch (_gameState) {
      case GAMESTATE.INIT:
        {
          _gameInit();
          break;
        }
      case GAMESTATE.RUNNING:
        {
          List<Positioned> snakeAndApple = List();
          _snakePosition.forEach((i) {
            snakeAndApple.insert(
              0,
              Positioned(
                child: Snake(),
                left: i.x * SNAKE_SIZE,
                top: i.y * SNAKE_SIZE,
              ),
            );
          });
          snakeAndApple.add(_getAppleWidget());
          child = Stack(children: snakeAndApple);
          break;
        }
      case GAMESTATE.VICTORY:
        {
          break;
        }
      case GAMESTATE.DIED:
        {
          break;
        }
    }
    return child;
  }

  void _gameInit() {
    _generateApple();
    _snakePosInit();
    _direction = DIRECTION.UP;
    _gameState = GAMESTATE.RUNNING;
    _timer = new Timer.periodic(Duration(milliseconds: 200), _timerTick);
  }

  void _snakePosInit() {
    var x = randomGenerator.nextInt(BOARD_WIDTH ~/ SNAKE_SIZE - 1).toDouble();
    var y = randomGenerator.nextInt(BOARD_HEIGHT ~/ SNAKE_SIZE - 1).toDouble();
    _snakePosition.insert(0, Point(x, y));
  }

  void _generateApple() {
    var x = randomGenerator.nextInt(BOARD_WIDTH ~/ SNAKE_SIZE - 1).toDouble();
    var y = randomGenerator.nextInt(BOARD_HEIGHT ~/ SNAKE_SIZE - 1).toDouble();
    if (_snakePosition.contains(Point(x,y))) {
      _generateApple();
    } else {
    _applePosition = Point(x, y);
    }
  }

  Widget _getAppleWidget() {
    var appleWidget = Positioned(
      child: Apple(),
      left: _applePosition.x * APPLE_SIZE,
      top: _applePosition.y * APPLE_SIZE,
    );
    return appleWidget;
  }

  void _timerTick(Timer timer) {
    _move();
    if (_appleIsEaten()) {
      _grow();
      _generateApple();
    }
  }

  void _move() {
    setState(() {
      _snakePosition.insert(0, _newHeadPosition());
      _snakePosition.removeLast();
    });
  }

  void _grow() {
    setState(() {
      _snakePosition.insert(0, _newHeadPosition());
    });
  }

  Point _newHeadPosition() {
    var currentHeadPos = _snakePosition.first;
    var x = currentHeadPos.x;
    var y = currentHeadPos.y;
    Point newHead = Point(x,y);
    switch (_direction) {
      case (DIRECTION.RIGHT):
        {
          if (currentHeadPos.x >= GRID_X - 1) {
            newHead.x = 0.0;
          } else {
            newHead.x = currentHeadPos.x + 1;
          }
          break;
        }
      case (DIRECTION.DOWN):
        {
          if (currentHeadPos.y >= GRID_Y - 1) {
            newHead.y = 0.0;
          } else {
            newHead.y = currentHeadPos.y + 1;
          }
          break;
        }
      case (DIRECTION.LEFT):
        {
          if (currentHeadPos.x * SNAKE_SIZE <= 0) {
            newHead.x = BOARD_WIDTH / SNAKE_SIZE - 1;
          } else {
            newHead.x = currentHeadPos.x - 1;
          }
          break;
        }
      case (DIRECTION.UP):
        {
          if (currentHeadPos.y * SNAKE_SIZE <= 0) {
            newHead.y = BOARD_HEIGHT / SNAKE_SIZE - 1;
          } else {
            newHead.y = currentHeadPos.y - 1;
          }
          break;
        }
    }
    return newHead;
  }

  bool _appleIsEaten() {
    var head = _newHeadPosition();
    if (_applePosition == null) {
      // apple init
      return true;
    } else if (head.x == _applePosition.x && head.y == _applePosition.y) {
      return true;
    } else {
      return false;
    }
  }

  void _changeDirection(details) {
    setState(() {
      var _swipe = details.delta.direction;
      if (-pi / 4 < _swipe && _swipe < pi / 4) {
        _direction = DIRECTION.RIGHT;
      } else if (-3 * pi / 4 < _swipe && _swipe > 3 * pi / 4) {
        _direction = DIRECTION.LEFT;
      } else if (-3 * pi / 4 < _swipe && _swipe < -pi / 4) {
        _direction = DIRECTION.UP;
      } else if (pi / 4 < _swipe && _swipe < 3 * pi / 4) {
        _direction = DIRECTION.DOWN;
      }
    });
  }
}
