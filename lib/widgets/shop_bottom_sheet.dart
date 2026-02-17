import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/auto_clicker_tier.dart';
import '../providers/game_provider.dart';

class ShopBottomSheet extends StatelessWidget {
  const ShopBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16213E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => ChangeNotifierProvider.value(
        value: context.read<GameProvider>(),
        child: const ShopBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, game, _) {
        final nextTier = AutoClickerTier.nextTier(game.autoClickerLevel);

        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'AUTO-CLICKER SHOP',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFFD54F),
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Current: ${game.coinsPerSecond} coins/sec',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0x99FFFFFF),
                ),
              ),
              const SizedBox(height: 24),
              // Tier list
              ...AutoClickerTier.tiers.map((tier) {
                final isOwned = tier.level <= game.autoClickerLevel;
                final isNext = tier.level == game.autoClickerLevel + 1;
                final canAfford = game.coins >= tier.cost;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _TierCard(
                    tier: tier,
                    isOwned: isOwned,
                    isNext: isNext,
                    canAfford: canAfford,
                    onBuy: isNext && canAfford
                        ? () {
                            game.spendCoins(tier.cost);
                            game.setAutoClicker(
                              level: tier.level,
                              coinsPerSecond: tier.coinsPerSecond,
                            );
                          }
                        : null,
                  ),
                );
              }),
              if (nextTier == null)
                const Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Text(
                    'All upgrades purchased!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFFFD54F),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _TierCard extends StatelessWidget {
  final AutoClickerTier tier;
  final bool isOwned;
  final bool isNext;
  final bool canAfford;
  final VoidCallback? onBuy;

  const _TierCard({
    required this.tier,
    required this.isOwned,
    required this.isNext,
    required this.canAfford,
    this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor;
    if (isOwned) {
      bgColor = const Color(0xFF1B5E20).withValues(alpha: 0.3);
    } else if (isNext) {
      bgColor = const Color(0xFF0D47A1).withValues(alpha: 0.3);
    } else {
      bgColor = Colors.white.withValues(alpha: 0.05);
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: isNext
            ? Border.all(color: const Color(0xFFFFD54F).withValues(alpha: 0.5))
            : null,
      ),
      child: Row(
        children: [
          // Level badge
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isOwned
                  ? const Color(0xFF4CAF50)
                  : const Color(0x33FFFFFF),
            ),
            child: Center(
              child: isOwned
                  ? const Icon(Icons.check, size: 20, color: Colors.white)
                  : Text(
                      '${tier.level}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tier.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isOwned
                        ? const Color(0xFF81C784)
                        : Colors.white,
                  ),
                ),
                Text(
                  '${tier.coinsPerSecond} coins/sec',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0x99FFFFFF),
                  ),
                ),
              ],
            ),
          ),
          // Buy button or status
          if (isOwned)
            const Text(
              'OWNED',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF81C784),
              ),
            )
          else if (isNext)
            ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    canAfford ? const Color(0xFFFFD54F) : const Color(0xFF333333),
                foregroundColor: canAfford ? Colors.black : Colors.white38,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '${_formatCost(tier.cost)} coins',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            )
          else
            Text(
              '${_formatCost(tier.cost)} coins',
              style: const TextStyle(
                fontSize: 13,
                color: Color(0x66FFFFFF),
              ),
            ),
        ],
      ),
    );
  }

  String _formatCost(int cost) {
    if (cost >= 1000) {
      return '${(cost / 1000).toStringAsFixed(cost % 1000 == 0 ? 0 : 1)}K';
    }
    return '$cost';
  }
}
