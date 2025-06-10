import 'package:flutter/material.dart';

import '../widgets/glass_card.dart';

class WeekScreen extends StatelessWidget {
  const WeekScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('La tua settimana',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w300)),
            const SizedBox(height: 16),
            // selettore settimana
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_left, color: Colors.white)),
                const Text('settimana', style: TextStyle(color: Colors.white70)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 24),
            // Card del lunedì
            GlassCard(
              child: Column(
                children: [
                  Text('Lunedì 6',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white70)),
                  const SizedBox(height: 4),
                  Text('✨ 4h tempo libero',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white)),
                  const SizedBox(height: 16),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Row(
                        children: List.generate(8, (i) {
                          return Expanded(
                            child: Container(
                              height: 8,
                              margin: const EdgeInsets.symmetric(horizontal: 2),
                              decoration: BoxDecoration(
                                color: i == 2 ? Colors.yellow : Colors.black45,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }),
                      ),
                      Align(
                        alignment: const Alignment(-0.25, 0),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const GlassCard(height: 120),
            const SizedBox(height: 16),
            const GlassCard(height: 120),
          ],
        ),
      ),
    );
  }
}
