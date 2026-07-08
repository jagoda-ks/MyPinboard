import 'package:flutter/material.dart';

class AppSettings {
  // -----------------------------------------
  // FONTS & TEXT STYLES
  // -----------------------------------------
  
  // If using a local font from pubspec.yaml:
  static const String customFontFamily = 'CustomFont';

  // The text style for your Sticky Note buttons
  static const TextStyle stickyNoteText = TextStyle(
    fontFamily: customFontFamily,
    fontSize: 24    ,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    height: 1.1,
  );

  /* 
  // IF USING GOOGLE FONTS, IT WOULD LOOK LIKE THIS INSTEAD:
  static final TextStyle stickyNoteText = GoogleFonts.lato(
    fontSize: 14,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    height: 1.1,
  );
  */

  // The text style for your Page Titles (AppBars)
  static const TextStyle pageTitleText = TextStyle(
    fontFamily: customFontFamily,
    fontSize: 20,
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  // -----------------------------------------
  // COLORS
  // -----------------------------------------
  
  static const Color deleteButtonNormal = Colors.red;
  static Color deleteButtonActive = Colors.red.shade800; // .shade requires removing 'const' if used directly
  static const Color iconColorWhite = Colors.white;

  // -----------------------------------------
  // LAYOUT & DIMENSIONS
  // -----------------------------------------
  
  // You can even store your Sticky Note proportions here!
  static const double stickyNoteOriginalWidth = 856.0;
  static const double stickyNoteOriginalHeight = 830.0;
  static const double stickyNoteRatio = stickyNoteOriginalWidth / stickyNoteOriginalHeight;

  // BACKGROUND
  static const String pinboardBackground = 'assets/images/pinboard.png';
}