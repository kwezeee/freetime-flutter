import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';

import '../utilities/app_theme.dart';

class EmailInputField extends StatelessWidget {
  const EmailInputField({super.key, required this.controller});
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return ClipSmoothRect(
      radius: AppTheme.radius,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Email',
          filled: true,
          fillColor: Colors.white.withAlpha(20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 14)
        ),
      ),
    );
  }
}
