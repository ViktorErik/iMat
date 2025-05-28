import 'package:api_test/app_theme.dart';
import 'package:flutter/material.dart';

class BuyButton extends StatelessWidget {
  const BuyButton({required this.onPressed, super.key, required int size});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      color: Colors.white,
      icon: Icon(Icons.add),
      onPressed: () {
        onPressed();
      },
    );
  }
}
