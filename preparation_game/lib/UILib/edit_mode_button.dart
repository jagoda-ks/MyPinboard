import 'package:flutter/material.dart';
import '../utils/settings.dart';

class EditModeButton extends StatelessWidget {
  final bool isEditMode;
  final VoidCallback onPressed;

  const EditModeButton({
    super.key,
    required this.isEditMode,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -10.0), // 👈 Shifts the button 10 pixels UPWARD
      child: Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: IconButton(
          icon: Icon(
            isEditMode ? Icons.check : Icons.edit,
            color: AppSettings.titleColor, // Use the title color from AppSettings
            size: 26,
          ),
          onPressed: onPressed,
          tooltip: isEditMode ? 'Done Editing' : 'Edit Mode',
        ),
      ),
    );
  }
}