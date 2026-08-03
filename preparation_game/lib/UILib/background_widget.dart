import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget? child;

  const BackgroundWidget({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Bottom Layer: Board
        Positioned.fill(
          child: Image.asset(
            'assets/images/board.png',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),

        // 2. Middle Layer (Interactive Content, e.g., Notes Canvas)
        if (child != null) Positioned.fill(child: child!),

        // 3. Top Layer: Frame
        Positioned.fill(
          child: IgnorePointer(
            child: Image.asset(
              'assets/images/frame.png',
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
  }
}