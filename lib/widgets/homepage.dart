import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';

import '../screens/home_screen.dart';
import '../screens/week_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/profile_screen.dart'; // ← nuovo

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  /// Ordine delle page: Home • Week • You
  static const _pages = <Widget>[
    HomeScreen(),
    WeekScreen(),
    ProfileScreen(),
  ];

  // =================  H O M E   P A G E  =================
  @override
  Widget build(BuildContext context) {
    final scrW        = MediaQuery.of(context).size.width;
    final bottomInset = MediaQuery.of(context).padding.bottom;

    const barH      = 62.0;  // altezza della pill-bar
    const barMargin = 24.0;  // padding del bottomNavigationBar
    final overlayH  = barH + bottomInset + 16;

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(index: _currentIndex, children: _pages),
          _BottomVeloScrim(height: overlayH),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: barMargin),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: scrW * .62, child: _buildPillBar()),
            const SizedBox(width: 16),
            _buildExploreButton(),
          ],
        ),
      ),
    );
  }


// ----------------  P I L L  B A R  ----------------
  Widget _buildPillBar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        const barH   = 62.0;
        const pillH  = 48.0;
        const pillR  = 40.0;
        const pillHP = 6.0;
        const animD  = Duration(milliseconds: 320);
        const items  = 3;
        final step   = constraints.maxWidth / items;
        final pWidth = step - pillHP * 2;
        final alignX = -1 + 2 * _currentIndex / (items - 1);

        return ClipSmoothRect(
          radius: SmoothBorderRadius(cornerRadius: 40, cornerSmoothing: .6),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              height: barH,
              decoration: ShapeDecoration(
                color: Colors.white.withAlpha(31),
                shape: SmoothRectangleBorder(
                  borderRadius: SmoothBorderRadius(cornerRadius: 40, cornerSmoothing: .6),
                  side: BorderSide(color: Colors.white.withAlpha(77), width: 1.5),
                ),
              ),
              child: Stack(
                children: [
                  const Positioned.fill(
                    child: AnimatedWaterRefraction(opacity: .25, waveCount: 8),
                  ),

                  // ---  PILL SCORREVOLE  ---
                  AnimatedAlign(
                    duration: animD,
                    curve: Curves.easeOutQuart,
                    alignment: Alignment(alignX, 0),
                    child: Transform.translate(
                      offset: Offset(-alignX * pillHP, 0),
                      child: SizedBox(
                        width: pWidth,
                        height: pillH,
                        child: ClipSmoothRect(
                          radius: SmoothBorderRadius(
                              cornerRadius: pillR, cornerSmoothing: 0.6),
                          child: Container(color: Colors.white.withAlpha(45)),
                        ),
                      ),
                    ),
                  ),

                  // ---  VOCI NAV  ---
                  Row(
                    children: List.generate(items, (i) => Expanded(child: _buildNavItem(i))),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }


  // ----------------  N A V  I T E M  ----------------
  Widget _buildNavItem(int i) {
    const labels       = ['Home', 'Week', 'You'];
    const iconsOutline = [
      CupertinoIcons.home,
      CupertinoIcons.list_bullet,
      CupertinoIcons.person,
    ];
    const iconsFilled  = [
      CupertinoIcons.home,
      CupertinoIcons.list_bullet,
      CupertinoIcons.person_fill,
    ];

    final sel = _currentIndex == i;
    final icon = sel ? iconsFilled[i] : iconsOutline[i];
    final col  = sel ? Colors.white : Colors.white70;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => setState(() => _currentIndex = i),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 24, color: col),
            const SizedBox(height: 2),
            Text(labels[i], style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: col)),
          ],
        ),
      ),
    );
  }

  // ----------------  F L O A T I N G  E X P L O R E  ----------------
  Widget _buildExploreButton() {
    const double size = 62;            // diametro = pillH
    return ClipOval(
      child: GestureDetector(
        onTap: () => Navigator.push(context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const ExploreScreen(),
            transitionDuration: const Duration(milliseconds: 320),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: CurvedAnimation(parent: anim, curve: Curves.easeOutQuart), child: child),
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(31),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withAlpha(77), width: 1.5),
            ),
            child: const Icon(CupertinoIcons.search, size: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// Effetto di “rifrazione” animata: più onde sovrapposte
class AnimatedWaterRefraction extends StatefulWidget {
  final double opacity;
  final int waveCount;

  const AnimatedWaterRefraction({
    super.key,
    this.opacity = 0.2,
    this.waveCount = 2,
  });

  @override
  AnimatedWaterRefractionState createState() => AnimatedWaterRefractionState();
}

class AnimatedWaterRefractionState extends State<AnimatedWaterRefraction>
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
            final offsetY = (phase * 2 - 1) * 4; // [-4, 4]
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
                        Colors.white.withAlpha(20), // ~0.08
                        Colors.white.withAlpha(0),
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
class _BottomVeloScrim extends StatelessWidget {
  final double height;
  const _BottomVeloScrim({super.key, required this.height});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: height,
      child: IgnorePointer(
        child: SoftEdgeBlur(
          // Applichiamo il blur solo sul bordo superiore del riquadro
          edges: [
            EdgeBlur(
              type: EdgeType.topEdge,
              size: height,    // estende il blur per tutta l'altezza del scrim
              sigma: 12,
              controlPoints: [
                // 0% blur in corrispondenza della linea superiore
                ControlPoint(position: 0.0, type: ControlPointType.transparent),
                // 100% blur in basso, all'interno del scrim
                ControlPoint(position: 1.0, type: ControlPointType.visible),
              ],
            ),
          ],
          child: Container(
            // poi aggiungiamo il velo colore come prima
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Color.fromARGB(153, 6, 15, 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}