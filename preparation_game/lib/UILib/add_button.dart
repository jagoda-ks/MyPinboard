import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;

  const AddButton({
    super.key,
    required this.onPressed,
    this.size = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          'assets/images/add_button.png',
          fit: BoxFit.contain,
          alignment: Alignment.bottomRight, // 👈 Anchors scaling to bottom-right
        ),
      ),
    );
  }
}