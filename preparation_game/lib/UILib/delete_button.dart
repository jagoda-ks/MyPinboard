import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final bool isDeleting;
  final VoidCallback onPressed;
  final bool enabled;
  final double size;

  const DeleteButton({
    super.key,
    required this.isDeleting,
    required this.onPressed,
    required this.enabled,
    this.size = 180.0,
  });

  @override
  Widget build(BuildContext context) {
    Widget bin = Image.asset(
      'assets/images/bin.png',
      fit: BoxFit.contain,
      alignment: Alignment.bottomLeft,
    );

    if (isDeleting) {
      bin = ColorFiltered(
        colorFilter: ColorFilter.mode(
          const Color.fromARGB(255, 160, 30, 30).withValues(alpha: 0.35),
          BlendMode.srcATop,
        ),
        child: bin,
      );
    }

    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Tooltip(
        message: isDeleting ? 'Finish deleting' : 'Delete',
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 150),
          opacity: enabled ? 1.0 : 0.4,
          child: AnimatedScale(
            scale: isDeleting ? 1.08 : 1.0,
            duration: const Duration(milliseconds: 150),
            alignment: Alignment.bottomLeft,
            child: SizedBox(
              width: size,
              height: size,
              child: bin,
            ),
          ),
        ),
      ),
    );
  }
}
