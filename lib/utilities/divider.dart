import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Colors.white.withAlpha(60))),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            'or',
            style: TextStyle(color: Colors.white70),
          ),
        ),
        Expanded(child: Divider(color: Colors.white.withAlpha(60))),
      ],
    );
  }
}
