import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/coin_widget.dart';
import '../widgets/floating_text.dart';
import '../widgets/shop_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<int> _floatingTexts = [];
  int _floatingKey = 0;
  Timer? _floatingTimer;
  int _lastCoinsPerSecond = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final cps = context.read<GameProvider>().coinsPerSecond;
    if (cps != _lastCoinsPerSecond) {
      _lastCoinsPerSecond = cps;
      _syncFloatingTimer(cps);
    }
  }

  void _syncFloatingTimer(int coinsPerSecond) {
    _floatingTimer?.cancel();
    if (coinsPerSecond > 0) {
      _floatingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          _floatingTexts.add(_floatingKey++);
        });
      });
    }
  }

  @override
  void dispose() {
    _floatingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 40),
            // Coin counter
            Consumer<GameProvider>(
              builder: (context, game, _) {
                // Sync timer when coinsPerSecond changes
                if (game.coinsPerSecond != _lastCoinsPerSecond) {
                  _lastCoinsPerSecond = game.coinsPerSecond;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _syncFloatingTimer(game.coinsPerSecond);
                  });
                }
                return Column(
                  children: [
                    Text(
                      '${game.coins}',
                      style: const TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD54F),
                        shadows: [
                          Shadow(
                            color: Color(0x80FFD54F),
                            blurRadius: 16,
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'COINS',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0x99FFFFFF),
                        letterSpacing: 4,
                      ),
                    ),
                    if (game.coinsPerSecond > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '${game.coinsPerSecond} coins/sec',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF81C784),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            // Coin in center with floating text overlay
            Expanded(
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    const CoinWidget(),
                    // Floating +X texts from auto-clicker
                    ..._floatingTexts.map((key) {
                      final cps = context.read<GameProvider>().coinsPerSecond;
                      return Positioned(
                        top: -20,
                        key: ValueKey(key),
                        child: FloatingText(
                          amount: cps,
                          onComplete: () {
                            setState(() {
                              _floatingTexts.remove(key);
                            });
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
            // Shop button
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: ElevatedButton.icon(
                onPressed: () => ShopBottomSheet.show(context),
                icon: const Icon(Icons.shopping_cart, size: 20),
                label: const Text(
                  'SHOP',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF16213E),
                  foregroundColor: const Color(0xFFFFD54F),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(
                      color: Color(0x40FFD54F),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
