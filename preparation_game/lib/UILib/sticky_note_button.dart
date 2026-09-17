import 'package:flutter/material.dart';
import 'package:preparation_game/utils/settings.dart';

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
    this.width = 200.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: AspectRatio(
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
                        ? ColorFilter.mode(
                            const Color.fromARGB(255, 89, 13, 13)
                                .withValues(alpha: 0.4),
                            BlendMode.srcATop)
                        : null,
                  ),
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 20.0),
                  // 👈 Wrap the text in a Tooltip to reveal the full text on hover/long-press
                  child: Tooltip(
                    message: text, // Shows the complete, untouched text on hover
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      softWrap: true,
                      maxLines: 3, // Restricts height visibility to 3 lines
                      overflow: TextOverflow.ellipsis, // 👈 Appends "..." automatically when text overflows
                      style: AppSettings.stickyNoteText,
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: Image.asset('assets/images/pin.png',
                    fit: BoxFit.contain),
              ),
            ),
          ],
        ),
      ),
    );
  }
}