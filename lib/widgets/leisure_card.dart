import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

class LeisureCard extends StatelessWidget {
  const LeisureCard({
    super.key,
    required this.child,
    this.height = 300,
    this.width  = 280,       // ⬅️ nuova larghezza più “snella”
  });

  final Widget child;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Center(                       // centra la card nello stack
      child: ClipSmoothRect(
        radius: SmoothBorderRadius(
          cornerRadius: 24,
          cornerSmoothing: 0.6,
        ),
        child: Container(
          height: height,
          width:  width,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: child,
        ),
      ),
    );
  }
}
