import 'package:flutter/material.dart';
import 'package:preparation_game/settings.dart'; // 1. Import your new settings class

class StickyNoteButton extends StatelessWidget {
  final String text;
  final bool isMarked;
  final VoidCallback onTap;
  final double width;

  const StickyNoteButton({
    super.key,
    required this.text,
    required this.isMarked,
    required this.onTap,
    this.width = 120.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
        // 2. Use the ratio from AppSettings
        aspectRatio: AppSettings.stickyNoteRatio, 
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/sticky_note.png'),
                    fit: BoxFit.fill,
                    colorFilter: isMarked
                        ? const ColorFilter.mode(Colors.redAccent, BlendMode.srcATop)
                        : null,
                  ),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Text(
                    text,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    // 3. Use the centralized text style!
                    style: AppSettings.stickyNoteText, 
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset('assets/images/pin.png', fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}