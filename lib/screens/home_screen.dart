import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../widgets/coin_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                  ],
                );
              },
            ),
            // Coin in center
            const Expanded(
              child: Center(
                child: CoinWidget(),
              ),
            ),
            // Hint text
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Text(
                'Pinch the coin to collect!',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0x66FFFFFF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
