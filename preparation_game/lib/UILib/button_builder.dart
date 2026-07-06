import 'package:flutter/material.dart';

class ButtonBuilder {
  String _text = '';
  Color _color = Colors.blue;
  VoidCallback? _onPressed;

  // 1. Text Setter Method
  ButtonBuilder withText(String text) {
    _text = text;
    return this; // Allows chaining
  }

  // 2. Color Setter Method
  ButtonBuilder withColor(Color color) {
    _color = color;
    return this; // Allows chaining
  }

  // 3. Callback Setter Method
  ButtonBuilder onPressed(VoidCallback action) {
    _onPressed = action;
    return this; // Allows chaining
  }

  // 4. Final Build Method
  Widget build() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _color,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: _onPressed,
      child: Text(
        _text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}