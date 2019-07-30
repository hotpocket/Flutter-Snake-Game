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
  var _score = 0;
  var _highScore = 0;
  Point _applePosition;
  Timer _timer;
  Random randomGenerator = Random();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _changeDirection(details);
      },
      onTap: () {
        if (_gameState == GAMESTATE.HOMEPAGE) {
          _changeGameState(GAMESTATE.INIT);
        } else if (_gameState == GAMESTATE.DIED) {
          _reset();
        }
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
    _getHighScore();
    switch (_gameState) {
      case GAMESTATE.HOMEPAGE:
        {
          child = HomePage(_highScore);
          print(_gameState);
          break;
        }
      case GAMESTATE.INIT:
        {
          _gameInit();
          print(_gameState);
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
          /* child = Container( */
          Positioned scoreWidget = score(_score);
          snakeAndApple.add(scoreWidget);
          child = Stack(children: snakeAndApple);
          /* decoration: new BoxDecoration(
            image: DecorationImage(
              image: new AssetImage((
                'assets/assets/'
              ))
            )
          )
          ); */
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
          _timer.cancel();
          if (_highScore < _score) {
            _highScore = _score;
          }

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
    if (savedHighscore < _highScore) {
      await prefs.setInt('highscore', _highScore);
    } else {
      setState(() {
        _highScore = savedHighscore;
      });
    }
  }

  void _gameInit() {
    _changeGameState(GAMESTATE.RUNNING);
    _generateApple();
    _snakePosInit();
    var _allDirection = DIRECTION.values;
    _direction = _allDirection[randomGenerator.nextInt(_allDirection.length)];
    _timer = new Timer.periodic(Duration(milliseconds: 200), _timerTick);
  }

  void _snakePosInit() {
    var x = randomGenerator.nextInt(BOARD_WIDTH ~/ SNAKE_SIZE - 1).toDouble();
    var y = randomGenerator.nextInt(BOARD_HEIGHT ~/ SNAKE_SIZE - 1).toDouble();
    setState(() {
      _snakePosition.insert(0, Point(x, y));
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
        _applePosition = Point(x, y);
      });
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
    if (_appleIsEaten()) {
      _grow();
      _generateApple();
    } else if (_isSelfCollision() || _isWallCollision()) {
      _changeGameState(GAMESTATE.DIED);
    } else {
      _move();
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
    Point newHead = Point(x, y);
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
    return newHead;
  }

  bool _appleIsEaten() {
    var head = _snakePosition.first;
    if (_applePosition == null) {
      // apple init
      return true;
    } else if (head.x == _applePosition.x && head.y == _applePosition.y) {
      setState(() {
        _score++;
      });
      return true;
    } else {
      return false;
    }
  }

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

  bool _isWallCollision() {
    var head = _snakePosition.first;
    if (head.x < 0 || head.x >= GRID_X || head.y < 0 || head.y >= GRID_Y) {
      return true;
    }
    return false;
  }

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
      _direction = null;
    });
  }
}
