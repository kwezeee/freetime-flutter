import 'dart:ui'; // <- necessario per ImageFilter
import 'package:flutter/material.dart';

import '../screens/explore_screen.dart';
import '../screens/home_screen.dart';
import '../screens/week_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeScreen(),
    WeekScreen(),
    ExploreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors
          .transparent,
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _pages),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: BackdropFilter(
            // blur molto più leggero
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.12), // vetro leggermente più denso
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.white.withOpacity(0.30), // bordo più visibile
                  width: 1.5,
                ),
              ),
              child: Stack(
                children: [
                  // effetto “acqua” interno più marcato
                  Positioned.fill(
                    child: AnimatedWaterRefraction(
                      opacity: 0.25,
                      waveCount: 3,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(Icons.home_outlined, Icons.home, 0),
                      _buildNavItem(Icons.list_outlined, Icons.list, 1,
                          label: 'Settimana'),
                      _buildNavItem(Icons.search_outlined, Icons.search, 2),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData out, IconData sel, int idx, {String? label}) {
    final isSel = _currentIndex == idx;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = idx),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(isSel ? sel : out,
              size: 28, color: isSel ? Colors.white : Colors.white70),
          if (label != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(label,
                  style: TextStyle(
                      color: isSel ? Colors.white : Colors.white70,
                      fontSize: 12)),
            ),
        ],
      ),
    );
  }
}

/// Effetto di “rifrazione” animata: più onde sovrapposte
class AnimatedWaterRefraction extends StatefulWidget {
  final double opacity;
  final int waveCount;

  const AnimatedWaterRefraction({
    this.opacity = 0.2,
    this.waveCount = 2,
  });

  @override
  _AnimatedWaterRefractionState createState() =>
      _AnimatedWaterRefractionState();
}

class _AnimatedWaterRefractionState extends State<AnimatedWaterRefraction>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 6),
  )..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) {
        return Stack(
          children: List.generate(widget.waveCount, (i) {
            final phase = (_ctrl.value + i / widget.waveCount) % 1.0;
            final offsetY = (phase * 2 - 1) * 4; // spostamento verticale [-4,4]
            return Transform.translate(
              offset: Offset(0, offsetY),
              child: Opacity(
                opacity: widget.opacity,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0, -0.5 + i * 0.5),
                      radius: 1.2,
                      colors: [
                        Colors.white.withOpacity(0.08),
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
