import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  const ControlButton({Key? key, required this.onPressed, required this.icon})
      : super(key: key);
  final Function onPressed;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 1,
      child: Container(
        width: 80.0,
        height: 80.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            elevation: 0.0,
            onPressed: this.onPressed(),
            child: this.icon,
          ),
        ),
      ),
    );
  }
}
