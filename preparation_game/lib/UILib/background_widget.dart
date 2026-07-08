import 'package:flutter/material.dart';
import 'package:preparation_game/utils/settings.dart';

class BackgroundWidget extends StatelessWidget {
  final Widget child;

  const BackgroundWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(AppSettings.pinboardBackground),
          fit: BoxFit.cover,
          alignment: Alignment.center,
        ),
      ),
      child: child,
    );
  }
}