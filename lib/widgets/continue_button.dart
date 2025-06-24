import 'package:flutter/material.dart';

class ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onPressed;
  final Widget child;          // ← nuovo parametro

  const ContinueButton({
    super.key,
    required this.enabled,
    required this.child,       // ← obbligatorio
    this.onPressed,
  });

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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Figma squircle
          ),
        ),
        child: child,            // ← usa il widget passato (testo o loader)
      ),
    );
  }
}
