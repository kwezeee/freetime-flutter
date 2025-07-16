// fan_deck.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../widgets/leisure_card.dart';

class FanDeck extends StatefulWidget {
  const FanDeck({super.key, required this.itemCount});
  final int itemCount;

  @override
  State<FanDeck> createState() => _FanDeckState();
}

class _FanDeckState extends State<FanDeck> with TickerProviderStateMixin {
  // UX constants
  static const _dismissThreshold = 120.0;   // px
  static const _fanStep          = 48.0;    // base offset X

  // state
  late final List<int> _order;
  late final AnimationController _anim;
  late Animation<double> _frontDx, _frontRot, _stackT;
  double _dragX = 0;

  @override
  void initState() {
    super.initState();
    _order = List<int>.generate(widget.itemCount, (i) => i);

    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    )..addListener(() => setState(() {}));
  }

  @override
  void dispose() => _anim.dispose();

  // 0→1 based on drag
  double _dragFactor() => (_dragX.abs() / _dismissThreshold).clamp(0.0, 1.0);

  // Phase A: card off-screen & t: current → 1
  void _startDismiss(bool toLeft) {
    if (_anim.isAnimating) return;

    final screenW = MediaQuery.of(context).size.width;

    _frontDx  = Tween(begin: _dragX,         end: toLeft ? -screenW : screenW)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeIn));
    _frontRot = Tween(begin: _dragX / -3000, end: toLeft ? -0.35 : 0.35)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeIn));
    _stackT   = Tween(begin: _dragFactor(),  end: 1.0)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeIn));

    _anim
        .forward(from: 0)
        .whenComplete(() {
      // — Phase B — re-order & settle t:1 → 0
      if (!mounted) return;
      setState(() {
        _order.add(_order.removeAt(0));   // front → tail
        _dragX = 0;
      });

      // rebuild tweens per la nuova frontale
      _frontDx  = AlwaysStoppedAnimation(0);
      _frontRot = AlwaysStoppedAnimation(0);
      _stackT   = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic),
      );

      _anim.forward(from: 0);             // Phase B
    });
  }

  // rebound: torna allo stato di riposo (t→0) senza scatti
  void _startRebound() {
    if (_anim.isAnimating) return;

    final reboundDur = (220 + 180 * _dragFactor()).round();
    _anim.duration   = Duration(milliseconds: reboundDur);

    _frontDx  = Tween(begin: _dragX,         end: 0.0)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _frontRot = Tween(begin: _dragX / -3000, end: 0.0)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));
    _stackT   = Tween(begin: _dragFactor(),  end: 0.0)
        .animate(CurvedAnimation(parent: _anim, curve: Curves.easeOutCubic));

    _anim.forward(from: 0).whenComplete(() => _dragX = 0);
  }

  // single stacked card based on depth
  Widget _stackedCard(int depth, int idx, double t) {
    final damp   = math.pow(0.8, depth - 1).toDouble(); // meno corsa per le lontane
    final localT = t * damp;

    return Transform.translate(
      offset: Offset(_fanStep * depth * (1 - localT), 4.0 * depth),
      child: Transform.rotate(
        angle: 0.10 * depth * (1 - localT),
        alignment: Alignment.centerLeft,
        child: Transform.scale(
          scale: 1 - 0.04 * depth + 0.04 * localT,
          alignment: Alignment.topCenter,
          child: LeisureCard(
            child: Center(
              child: Text('Card #${idx + 1}',
                  style: Theme.of(context).textTheme.titleMedium),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t   = _anim.isAnimating ? _stackT.value  : _dragFactor();
    final dx  = _anim.isAnimating ? _frontDx.value : _dragX;
    final rot = _anim.isAnimating ? _frontRot.value: _dragX / -3000;

    final List<Widget> layers = [];
    // partiamo dal fondo: depth = last → 1
    for (int depth = _order.length - 1; depth >= 1; depth--) {
      layers.add(_stackedCard(depth, _order[depth], t));
    }

    // frontale con gesture
    layers.add(
      GestureDetector(
        onHorizontalDragUpdate: (d) => setState(() => _dragX += d.delta.dx),
        onHorizontalDragEnd: (_) {
          if      (_dragX <= -_dismissThreshold) _startDismiss(true);
          else if (_dragX >=  _dismissThreshold) _startDismiss(false);
          else                                    _startRebound();
        },
        child: Transform.translate(
          offset: Offset(dx, 0),
          child: Transform.rotate(
            angle: rot,
            child: LeisureCard(
              child: Center(
                child: Text('Card #${_order[0] + 1}',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
          ),
        ),
      ),
    );

    return SizedBox(
      height: 320,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: layers,
      ),
    );
  }
}
