import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class CoinWidget extends StatefulWidget {
  const CoinWidget({super.key});

  @override
  State<CoinWidget> createState() => _CoinWidgetState();
}

class _CoinWidgetState extends State<CoinWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  final AudioPlayer _audioPlayer = AudioPlayer();
  double _currentScale = 1.0;
  bool _isPinching = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.85), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.85, end: 1.05), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 1.05, end: 1.0), weight: 25),
    ]).animate(CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOut,
    ));
    // Pre-load the coin sound for instant playback
    _audioPlayer.setAsset('assets/audio/coin.wav');
  }

  @override
  void dispose() {
    _animController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onCollect() {
    context.read<GameProvider>().addCoin();
    HapticFeedback.lightImpact();
    // Seek to start and play (allows rapid replays)
    _audioPlayer.seek(Duration.zero).then((_) => _audioPlayer.play());
    _animController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.shortestSide * 0.55;

    return GestureDetector(
      // Tap to collect (works on desktop, web, and mobile)
      onTap: _onCollect,
      // Pinch to collect (mobile two-finger gesture)
      onScaleStart: (_) {
        _isPinching = false;
      },
      onScaleUpdate: (details) {
        // Ignore scale == 1.0 (that's a single-finger drag, not a pinch)
        if (details.pointerCount < 2) return;
        setState(() {
          _currentScale = details.scale.clamp(0.7, 1.3);
        });
        if (details.scale < 0.85 && !_isPinching) {
          _isPinching = true;
          _onCollect();
        }
      },
      onScaleEnd: (_) {
        setState(() {
          _currentScale = 1.0;
          _isPinching = false;
        });
      },
      child: CoinAnimatedBuilder(
        listenable: _scaleAnimation,
        builder: (context, child) {
          final animScale =
              _animController.isAnimating ? _scaleAnimation.value : _currentScale;
          return Transform.scale(
            scale: animScale,
            child: child,
          );
        },
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const RadialGradient(
              colors: [Color(0xFFFFD54F), Color(0xFFFFA000), Color(0xFFE65100)],
              stops: [0.3, 0.7, 1.0],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.amber.withValues(alpha: 0.6),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Text(
              '\$',
              style: TextStyle(
                fontSize: size * 0.45,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFFFF8E1),
                shadows: const [
                  Shadow(
                    color: Color(0x80000000),
                    offset: Offset(2, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CoinAnimatedBuilder extends AnimatedWidget {
  final Widget Function(BuildContext, Widget?) builder;
  final Widget? child;

  const CoinAnimatedBuilder({
    super.key,
    required super.listenable,
    required this.builder,
    this.child,
  });

  Animation<double> get animation => listenable as Animation<double>;

  @override
  Widget build(BuildContext context) {
    return builder(context, child);
  }
}
