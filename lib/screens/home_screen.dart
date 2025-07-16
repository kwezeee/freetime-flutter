import 'package:figma_squircle/figma_squircle.dart';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../design/design_system.dart';
import '../widgets/card_deck.dart';
import '../widgets/glass_card.dart';
import '../widgets/leisure_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pageCtrl = PageController(viewportFraction: 1.0);
    return Stack(
      children: [
        SafeArea(
          top: true,
          bottom: false, // permetto di scorrere sotto la nav bar
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top bar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ciao Roberto',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .copyWith(color: Colors.white70),
                    ),
                    const CircleAvatar(
                      radius: 20,
                      backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?img=47'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Nel tuo tempo libero:',
                  style: Theme.of(context)
                      .textTheme
                      .headlineSmall!
                      .copyWith(
                      color: Colors.white, fontWeight: FontWeight.w300),
                ),
                const SizedBox(height: 24),

              SizedBox(
                height: 320,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const FanDeck(itemCount: 5), // nuova gestione

                    Positioned(
                      right: 16,
                      child: FloatingActionButton(
                        onPressed: () {
                          // puoi recuperare l’indice corrente con
                          // int idx = (context.findAncestorStateOfType<_FanDeckState>())!.currentIndex;
                        },
                        shape: SmoothRectangleBorder(borderRadius: AppShapes.card),
                        child: const Icon(Icons.add),
                      ),
                    ),
                  ],
                ),
              ),

                const SizedBox(height: 32),

                // GlassCard in colonna
                for (var info in [
                  {'title': 'Oggi – martedì 7', 'subtitle': '✨ 4h tempo libero'},
                  {'title': 'Domani – mercoledì 8', 'subtitle': '🎬 2h film'},
                  {'title': 'Weekend – sab 11', 'subtitle': '🏞️ Escursione'},
                ])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: GlassCard(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Text(info['title']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Text(info['subtitle']!,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium!
                                    .copyWith(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
