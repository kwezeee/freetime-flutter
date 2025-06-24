import 'package:flutter/material.dart';
import '../widgets/glass_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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

                // Card orizzontali
                SizedBox(
                  height: 280,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) => Stack(
                      children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24)),
                          elevation: 4,
                          clipBehavior: Clip.antiAlias,
                          child: SizedBox(
                            width: 200,
                            height: 260,
                            child: Container(
                              color: Theme.of(context).cardColor,
                              alignment: Alignment.center,
                              child: Text(
                                'Card #${index + 1}',
                                style:
                                Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          right: -4,
                          bottom: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.add,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ],
                    ),
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
