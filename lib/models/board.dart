import 'package:flutter/material.dart';
import 'package:snake/models/constants.dart';
import 'package:snake/models/point.dart';
import 'package:snake/models/score.dart';
import 'package:snake/models/snake.dart';
import 'package:snake/models/apple.dart';
import 'package:snake/models/homepage.dart';
import 'package:snake/models/endgame.dart';
import 'dart:async';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class Board extends StatefulWidget {
  @override
  BoardState createState() => BoardState();
}

class BoardState extends State<Board> {
  var _gameState = GAMESTATE.HOMEPAGE;
  var _snakePosition = List();
  var _direction;
  var _score = 1;
  var _highScore = 0;
  var _tick = 350;
  Timer _timer;
  Point _applePosition;
  Random randomGenerator = Random();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (_direction == DIRECTION.RIGHT || _direction == DIRECTION.LEFT) {
          _changeDirection(details);
        }
      },
      onHorizontalDragUpdate: (details) {
        if (_direction == DIRECTION.UP || _direction == DIRECTION.DOWN) {
          _changeDirection(details);
        }
      },
      onTap: () {
        if (_gameState == GAMESTATE.HOMEPAGE) {
          _changeGameState(GAMESTATE.INIT);
        } else if (_gameState == GAMESTATE.DIED) {
          _reset();
        }
      },
      child: Container(
        color: Colors.blue[100],
        width: BOARD_WIDTH,
        height: BOARD_HEIGHT,
        child: _getGameState(),
      ),
    );
  }

  Widget _getGameState() {
    var child;
    switch (_gameState) {
      case GAMESTATE.HOMEPAGE:
        {
          _getHighScore();
          child = HomePage(_highScore);
          print(_gameState);
          break;
        }
      case GAMESTATE.INIT:
        {
          _getHighScore();
          _gameInit();
          print(_gameState);
          break;
        }
      case GAMESTATE.RUNNING:
        {
          var counter = 0;
          List<Transform> snakeAndApple = List();
          _snakePosition.forEach((i) {
            snakeAndApple.insert(
              0,
              _getSnakeWidget(i, counter),
            );
            counter++;
          });
          snakeAndApple.add(_getAppleWidget());

          Transform scoreWidget = score(_score);
          snakeAndApple.add(scoreWidget);
          child = Stack(children: snakeAndApple);

          print(_gameState);
          break;
        }
      case GAMESTATE.VICTORY:
        {
          child = EndGame(_gameState, _score, _highScore);
          print(_gameState);
          break;
        }
      case GAMESTATE.DIED:
        {
          if (_score > _highScore) {
            _setHighScore(_score);
          }

          _timer.cancel();
          child = EndGame(_gameState, _score, _highScore);

          print(_gameState);
          break;
        }
    }
    return child;
  }

  _getHighScore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int savedHighscore = prefs.getInt('highscore') ?? 0;
    if (savedHighscore > _highScore) {
      setState(() {
        _highScore = savedHighscore;
      });
    }
  }

  _setHighScore(score) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('highscore', score);
  }

  void _gameInit() {
    var _allDirection = DIRECTION.values;
    _direction = _allDirection[randomGenerator.nextInt(_allDirection.length)];
    _getHighScore();
    _changeGameState(GAMESTATE.RUNNING);
    _generateApple();
    _snakePosInit();
    _move();
  }

  void _snakePosInit() {
    var x = randomGenerator.nextInt(BOARD_WIDTH ~/ SNAKE_SIZE - 1).toDouble();
    var y = randomGenerator.nextInt(BOARD_HEIGHT ~/ SNAKE_SIZE - 1).toDouble();
    setState(() {
      _snakePosition.insert(0, Point(x, y, _direction));
    });
  }

  void _generateApple() {
    var x = randomGenerator.nextInt(BOARD_WIDTH ~/ SNAKE_SIZE - 1).toDouble();
    var y = randomGenerator.nextInt(BOARD_HEIGHT ~/ SNAKE_SIZE - 1).toDouble();
    bool _inSnakeBody = false;
    for (var i = 0; i < _snakePosition.length; i++) {
      if (_snakePosition[i].x == x && _snakePosition[i].y == y) {
        _inSnakeBody = true;
        break;
      }
    }
    if (_inSnakeBody) {
      _generateApple();
    } else {
      setState(() {
        _applePosition = Point(x, y, _direction);
      });
    }
  }

  double _getSnakeWidgetAngle(direction) {
    double angle;
    if (direction == DIRECTION.UP) {
      angle = 0;
    } else if (direction == DIRECTION.RIGHT) {
      angle = 90 * pi / 180;
    } else if (direction == DIRECTION.DOWN) {
      angle = pi;
    } else if (direction == DIRECTION.LEFT) {
      angle = -90 * pi / 180;
    }
    return angle;
  }

  Widget _getSnakeWidget(i, counter) {
    print('_getSnakeWidget');
    String choice;
    double angle = _getSnakeWidgetAngle(i.direction);

    if (counter == 0) {
      choice = 'head';
      return Transform(
        alignment: FractionalOffset.center,
        transform:
            Matrix4.translationValues(i.x * SNAKE_SIZE, i.y * SNAKE_SIZE, 1)
              ..rotateZ(angle),
        child: Snake(choice),
      );
    } else if (counter == _snakePosition.length - 1) {
      choice = 'tail';
      return Transform(
        alignment: FractionalOffset.center,
        transform:
            Matrix4.translationValues(i.x * SNAKE_SIZE, i.y * SNAKE_SIZE, 1)
              ..rotateZ(
                  _getSnakeWidgetAngle(_snakePosition[counter - 1].direction)),
        child: Snake(choice),
      );
    } else {
      choice = 'body';
      return Transform(
        alignment: FractionalOffset.center,
        transform:
            Matrix4.translationValues(i.x * SNAKE_SIZE, i.y * SNAKE_SIZE, 1)
              ..rotateZ(angle),
        child: Snake(choice),
      );
    }
  }

  Widget _getAppleWidget() {
    print('_getAppleWidget()');
    return Transform.translate(
      offset:
          Offset(_applePosition.x * APPLE_SIZE, _applePosition.y * APPLE_SIZE),
      child: Apple(),
    );
  }

  // _timerTick(framerate) {
  //   if (_isSelfCollision()) {
  //     _changeGameState(GAMESTATE.DIED);
  //   } else {
  //     _move();
  //   }
  //   // await Future.delayed(Duration(milliseconds: framerate),_timerTick(framerate));
  //   Timer(Duration(milliseconds: framerate),(){_timerTick(framerate);});
  // }

  void _move() {
    try {
      print("_move()");
      var newHead = _newHeadPosition();
      setState(() {
        if (_isSelfCollision()) {
          _changeGameState(GAMESTATE.DIED);
          return;
        }
        if (_appleIsEaten(newHead)) {
          _generateApple();
          _score++;
          _tick <= 10 ? _tick = 10 : _tick -= 1;
          _snakePosition.insert(0, newHead);
        } else {
          _snakePosition.insert(0, newHead);
          _snakePosition.removeLast();
        }
      });
    } catch (e) {
      print(e);
    }
    _timer = Timer(Duration(milliseconds: _tick), () {
      _move();
    });
  }

  bool _appleIsEaten(newHead) {
    if ((newHead.x == _applePosition.x && newHead.y == _applePosition.y) ||
        _applePosition == null) {
      return true;
    }
    return false;
  }

  Point _newHeadPosition() {
    print('_newHeadPosition()');
    var currentHeadPos = _snakePosition.first;
    var x = currentHeadPos.x;
    var y = currentHeadPos.y;
    Point newHead = Point(x, y, _direction);
    print(newHead.direction);
    switch (_direction) {
      case (DIRECTION.RIGHT):
        {
          newHead.x = currentHeadPos.x + 1;
          break;
        }
      case (DIRECTION.DOWN):
        {
          newHead.y = currentHeadPos.y + 1;
          break;
        }
      case (DIRECTION.LEFT):
        {
          newHead.x = currentHeadPos.x - 1;
          break;
        }
      case (DIRECTION.UP):
        {
          newHead.y = currentHeadPos.y - 1;
          break;
        }
    }
    if (newHead.x >= GRID_X) {
      newHead.x = newHead.x % GRID_X;
    } else if (newHead.x < 0) {
      newHead.x = GRID_X - 1;
    }
    if (newHead.y >= GRID_Y) {
      newHead.y = newHead.y % GRID_Y;
    } else if (newHead.y < 0) {
      newHead.y = GRID_Y - 1;
    }
    return newHead;
  }

  // control
  void _changeDirection(details) {
    var _swipe = details.delta.direction;
    if (-pi / 4 < _swipe && _swipe < pi / 4) {
      if (_direction == DIRECTION.LEFT) {
        _direction = DIRECTION.LEFT;
      } else {
        setState(() {
          _direction = DIRECTION.RIGHT;
        });
      }
    } else if (-3 * pi / 4 < _swipe && _swipe > 3 * pi / 4) {
      if (_direction == DIRECTION.RIGHT) {
        _direction = DIRECTION.RIGHT;
      } else {
        setState(() {
          _direction = DIRECTION.LEFT;
        });
      }
    } else if (-3 * pi / 4 < _swipe && _swipe < -pi / 4) {
      if (_direction == DIRECTION.DOWN) {
        _direction = DIRECTION.DOWN;
        return;
      } else {
        setState(() {
          _direction = DIRECTION.UP;
        });
      }
    } else if (pi / 4 < _swipe && _swipe < 3 * pi / 4) {
      if (_direction == DIRECTION.UP) {
        _direction = DIRECTION.UP;
        return;
      } else {
        setState(() {
          _direction = DIRECTION.DOWN;
        });
      }
    }
  }

  bool _isSelfCollision() {
    var head = _snakePosition.first;
    var body = _snakePosition.sublist(1);
    for (var i = 0; i < body.length; i++) {
      var x = body[i].x;
      var y = body[i].y;
      if (head.x == x && head.y == y) {
        return true;
      }
    }
    return false;
  }

  // bool _isWallCollision() {
  //   var head = _snakePosition.first;
  //   if (head.x < 0 || head.x >= GRID_X || head.y < 0 || head.y >= GRID_Y) {
  //     return true;
  //   }
  //   return false;
  // }

  void _changeGameState(gamestate) {
    setState(() {
      _gameState = gamestate;
    });
  }

  void _reset() {
    setState(() {
      _snakePosition = List();
      _gameState = GAMESTATE.HOMEPAGE;
      _applePosition = null;
      _score = 0;
      _direction = DIRECTION
          .values[randomGenerator.nextInt(DIRECTION.values.length - 1)];
      _tick = 500;
    });
  }
}
