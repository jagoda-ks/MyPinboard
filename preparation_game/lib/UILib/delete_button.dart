import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final bool isDeleting;
  final VoidCallback onPressed;
  final bool enabled;

  const DeleteButton({
    super.key,
    required this.isDeleting,
    required this.onPressed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: isDeleting ? Colors.red.shade800 : Colors.red,
        borderRadius: BorderRadius.circular(30),
        boxShadow: isDeleting ? [const BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))] : [],
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: Row(
          children: [
            Icon(isDeleting ? Icons.check : Icons.delete, color: Colors.white),
            const SizedBox(width: 8),
            Text(isDeleting ? 'Finish Deleting' : 'Delete', style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}