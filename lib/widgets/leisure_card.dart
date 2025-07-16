import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';
import '../design/design_system.dart';

class LeisureCard extends StatelessWidget {
  final Widget child;
  const LeisureCard({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      clipBehavior: Clip.antiAlias,
      shape: SmoothRectangleBorder(borderRadius: AppShapes.card),
      child: Container(
        width: 200,
        height: 260,
        color: Theme.of(context).cardColor,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
