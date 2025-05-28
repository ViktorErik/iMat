import 'package:api_test/app_theme.dart';
import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
  const BuyButton({required this.onPressed, super.key, required this.size});

  final void Function() onPressed;
  final int size;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      iconSize: size.toDouble(),
      color: Colors.white,
      icon: Icon(Icons.add),
      onPressed: () {
        onPressed();
      },
    );
  }
}
