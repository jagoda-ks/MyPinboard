import 'package:flutter/material.dart';

class ScrollPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;

  const ScrollPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.only(top: 20, bottom: 100),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: padding,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: child,
          ),
        );
      },
    );
  }
}