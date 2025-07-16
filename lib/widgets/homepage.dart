import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:figma_squircle/figma_squircle.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:soft_edge_blur/soft_edge_blur.dart';
import 'dart:math' as math;
import '../screens/home_screen.dart';
import '../screens/week_screen.dart';
import '../screens/explore_screen.dart';
import '../screens/profile_screen.dart';

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

        return LiquidGlass(
          shape: const LiquidRoundedSuperellipse(
            borderRadius: Radius.circular(40),
          ),
          glassContainsChild: false,
          settings: const LiquidGlassSettings(
            blur: 4,
            ambientStrength: 2,
            lightAngle: 0.4 * math.pi,
            glassColor: Colors.black12,
            thickness: 30,
          ),
          child: SizedBox(
            height: barH,
            child: Stack(
              children: [
              AnimatedAlign(
              duration: animD,
              curve: Curves.easeOutQuart,
              alignment: Alignment(alignX, 0),
              child: Transform.translate(
                offset: Offset(-alignX * pillHP, 0),
                child: SizedBox(
                  width: pWidth,
                  height: pillH,
                  child: LiquidGlass(
                    glassContainsChild: false,
                    shape: const LiquidRoundedSuperellipse(
                      borderRadius: Radius.circular(pillR),
                    ),
                    settings: const LiquidGlassSettings(
                      blur: 6,
                      thickness: 16,
                      ambientStrength: 0.6,
                      lightAngle: 0.25 * math.pi,
                      glassColor: Colors.white10,
                    ),
                    child: const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
                // —— VOCI NAV
                Row(
                  children: List.generate(
                    items,
                        (i) => Expanded(child: _buildNavItem(i)),
                  ),
                ),
              ],
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
    const double size = 62; // = pillH
    return LiquidGlass(
      shape: const LiquidRoundedSuperellipse(
        borderRadius: Radius.circular(size / 2),
      ),
      glassContainsChild: false,
      settings: const LiquidGlassSettings(
        blur: 4,
        thickness: 22,
        ambientStrength: 0.7,
        lightAngle: -0.25 * math.pi,
        glassColor: Colors.white10,
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: GestureDetector(
          onTap: () => Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (_, __, ___) => const ExploreScreen(),
              transitionDuration: const Duration(milliseconds: 320),
              transitionsBuilder: (_, anim, __, child) => FadeTransition(
                opacity: CurvedAnimation(
                  parent: anim,
                  curve: Curves.easeOutQuart,
                ),
                child: child,
              ),
            ),
          ),
          child: const Icon(
            CupertinoIcons.search,
            size: 24,
            color: Colors.white,
          ),
        ),
      ),
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
