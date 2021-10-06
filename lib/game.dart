import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
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
  void changeSpeed() {
    if (timer != null && timer.isActive) {
      timer.cancel();
    }
    timer = Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {});
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

  Offset getNextPosition(Offset position) {
    Offset nextPosition;
    if (direction == Direction.right) {
      nextPosition = Offset(position.dx + step, position.dy);
    } else if (direction == Direction.left) {
      nextPosition = Offset(position.dx - step, position.dy);
    } else if (direction == Direction.up) {
      nextPosition = Offset(position.dx, position.dy - step);
    } else if (direction == Direction.down) {
      nextPosition = Offset(position.dx, position.dy + step);
    }
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();
    for (var i = 0; i < length; ++i) {
      pieces.add(Piece(
        color: Colors.red,
        size: step,
        posX: positions[0].dx.toInt(),
        posY: positions[0].dy.toInt(),
      ));
    }
    return pieces;
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
            ],
          )),
    );
  }
}
