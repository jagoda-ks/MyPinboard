import 'package:flutter/material.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 1. Bottom Layer: Background Board Image
        Positioned.fill(
          child: Image.asset(
            'assets/images/board.png', // Update to AppSettings.boardBackground if using AppSettings
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
        ),

        // 2. Middle Layer: Your App Content (Sticky notes, buttons, forms, etc.)
        Positioned.fill(
          child: child,
        ),

        // 3. Top Layer: Foreground Frame Image (Touch events pass straight through)
        Positioned.fill(
          child: IgnorePointer(
            child: Image.asset(
              'assets/images/frame.png', // Update path as needed
              fit: BoxFit.fill, // Ensures the frame stretches across the whole screen edges
            ),
          ),
        ),
      ],
    );
  }
}