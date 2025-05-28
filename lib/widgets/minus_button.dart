import 'package:flutter/material.dart';

class MinusButton extends StatelessWidget {
  const MinusButton({required this.onPressed, super.key, required int size});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: Icon(Icons.remove),
      onPressed: () {
        onPressed();
      },
    );
  }
}