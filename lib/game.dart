import 'dart:math';

import 'package:flutter/material.dart';
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
  // int length = 5;
  List<Offset> positions = [];

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
    // while (length > positions.length) {
    //   positions.add(positions[positions.length - 1]);
    // }
  }

  List<Piece> getPieces() {
    final pieces = <Piece>[];
    draw();
    pieces.add(Piece(
      color: Colors.red,
      size: step,
      posX: positions[0].dx.toInt(),
      posY: positions[0].dy.toInt(),
    ));
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
