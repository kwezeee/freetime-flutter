import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top bar: greeting + avatar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Ciao Roberto',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Colors.white70)),
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                    'https://i.pravatar.cc/150?img=47',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Nel tuo tempo libero:',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w300)),
            const SizedBox(height: 24),

            // → Ora usa una semplice Card invece di Image.network
            Center(
              child: Stack(
                children: [
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 4,
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox(
                      width: 200,
                      height: 260,
                      child: Container(
                        color: Theme.of(context).cardColor,
                        // qui potrai mettere un child quando servirà
                      ),
                    ),
                  ),
                  Positioned(
                    right: -4,
                    bottom: 0,
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.add, color: Theme.of(context).primaryColor),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),
            // Card "Oggi – martedì 7"
            GlassCard(
              child: Column(
                children: [
                  Text('Oggi – martedì 7',
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
                                color: i == 7 ? Colors.yellow : Colors.black45,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          );
                        }),
                      ),
                      Align(
                        alignment: const Alignment(1, 0),
                        child: CircleAvatar(
                          radius: 10,
                          backgroundColor: Colors.yellow,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Lettura alle 20:00',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white70)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
