import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
  const BuyButton({required this.onPressed, required this.size, super.key});

  final void Function() onPressed;
  final int size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: size.toDouble(),
      icon: Icon(Icons.add),
      onPressed: () {
        onPressed();
      },
    );
  }
}
