import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:snake_game/control_panel.dart';
import 'package:snake_game/direction.dart';
import 'package:snake_game/piece.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late int upperBoundX, upperBoundY, lowerBoundX, lowerBoundY;
  late double screenWidth, screenHeight;
  int step = 20;
  int length = 5;
  List<Offset> positions = [];
  Direction direction = Direction.right;
  late Timer timer;
  late Offset foodPosition;
  late Piece food;
  int score = 0;
  double speed = 1.0;
  void changeSpeed() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {});
    });
  }

  Widget getControls() {
    return ControlPanel(onTapped: (Direction newDirection) {
      direction = newDirection;
    });
  }

  void restart() {
    changeSpeed();
  }

  @override
  void initState() {
    super.initState();
    restart();
  }

  int getNearestTens(int num) {
    int output;
    output = (num ~/ step) * step;
    if (output == 0) {
      output += step;
    }
    return output;
  }

  Offset getRandomPosition() {
    Offset position;
    int posX = Random().nextInt(upperBoundX) + lowerBoundX;
    int posY = Random().nextInt(upperBoundY) + lowerBoundY;
    position = Offset(
        getNearestTens(posX).toDouble(), getNearestTens(posY).toDouble());
    return position;
  }

  void draw() {
    if (positions.length == 0) {
      positions.add(getRandomPosition());
    }
    while (length > positions.length) {
      positions.add(positions[positions.length - 1]);
    }
    for (var i = positions.length - 1; i > 0; i--) {
      positions[i] = positions[i - 1];
    }
    positions[0] = getNextPosition(positions[0]);
  }

  late Offset nextPosition;

  Offset getNextPosition(Offset position) {
    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }
    return nextPosition;
  }

  void drawFood() {
    if (foodPosition == null) {
      foodPosition = getRandomPosition();
    }
    if (foodPosition == positions[0]) {
      length++;
      score = score + 5;
      speed = speed + 0.25;
      foodPosition = getRandomPosition();
    }
    food = Piece(
      color: Colors.red,
      size: step,
      posX: foodPosition.dx.toInt(),
      posY: foodPosition.dy.toInt(),
      isAnimated: true,
    );
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();
    drawFood();
    for (var i = 0; i < length; ++i) {
      if (i >= positions.length) {
        continue;
      }
      pieces.add(Piece(
        color: i.isEven ? Colors.red : Colors.green,
        size: step,
        posX: positions[0].dx.toInt(),
        posY: positions[0].dy.toInt(),
        isAnimated: false,
      ));
    }
    return pieces;
  }

  Widget getScore() {
    return Positioned(
      top: 80.0,
      right: 50.0,
      child: Text(
        "Score:" + score.toString(),
        style: TextStyle(fontSize: 30, color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    lowerBoundY = step;
    lowerBoundX = step;

    upperBoundY = getNearestTens(screenHeight.toInt() - step);
    upperBoundX = getNearestTens(screenWidth.toInt() - step);

    return Scaffold(
      body: Container(
          color: Colors.amber,
          child: Stack(
            children: [
              Stack(
                children: getPieces(),
              ),
              getControls(),
              food,
              getScore(),
            ],
          )),
    );
  }
}
