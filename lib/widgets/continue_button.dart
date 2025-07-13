import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import '../utilities/app_theme.dart';

class ContinueButton extends StatelessWidget {
  const ContinueButton({
    super.key,
    required this.enabled,
    required this.child,
    this.onPressed,
  });

  final bool enabled;
  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0055FE),
          shadowColor: const Color(0xFF0055FE).withAlpha(80),
          elevation: enabled ? 12 : 0,
          shape: SmoothRectangleBorder(borderRadius: AppTheme.radius),
        ),
        child: child,
      ),
    );
  }
}
