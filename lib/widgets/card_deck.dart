import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'leisure_card.dart';

class LeisureDeck extends StatefulWidget {
  const LeisureDeck({super.key});

  @override
  State<LeisureDeck> createState() => _LeisureDeckState();
}

class _LeisureDeckState extends State<LeisureDeck> {
  final _controller = CardSwiperController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool _onSwipe(
      int previousIndex,
      int? currentIndex,
      CardSwiperDirection direction,
      ) {
    if (direction == CardSwiperDirection.right) {
      // Verso destra → voglio tornare indietro
      // Aspetto un micro-task così l’animazione termina e subito dopo faccio undo
      Future.microtask(_controller.undo);
    }
    // Lascio sempre completare l’animazione dello swipe
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final cards = List.generate(
      5,
          (i) => LeisureCard(
        child: Center(
          child: Text(
            'Card #${i + 1}',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );

    return CardSwiper(
      controller: _controller,
      cardsCount: cards.length,
      cardBuilder: (ctx, index, _, __) => cards[index],

      // effetto ventaglio
      numberOfCardsDisplayed: 3,
      backCardOffset: const Offset(48, 8),
      scale: 0.92,
      maxAngle: 22,
      padding: EdgeInsets.zero,
      isLoop: false,                               // evita giri infiniti
      allowedSwipeDirection:
      const AllowedSwipeDirection.only(left: true, right: true),

      onSwipe: _onSwipe,
    );
  }
}
