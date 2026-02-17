class AutoClickerTier {
  final int level;
  final int cost;
  final int coinsPerSecond;
  final String name;

  const AutoClickerTier({
    required this.level,
    required this.cost,
    required this.coinsPerSecond,
    required this.name,
  });

  static const List<AutoClickerTier> tiers = [
    AutoClickerTier(level: 1, cost: 50, coinsPerSecond: 1, name: 'Rusty Clicker'),
    AutoClickerTier(level: 2, cost: 200, coinsPerSecond: 3, name: 'Bronze Clicker'),
    AutoClickerTier(level: 3, cost: 1000, coinsPerSecond: 10, name: 'Silver Clicker'),
    AutoClickerTier(level: 4, cost: 5000, coinsPerSecond: 30, name: 'Gold Clicker'),
    AutoClickerTier(level: 5, cost: 25000, coinsPerSecond: 100, name: 'Diamond Clicker'),
  ];

  static AutoClickerTier? nextTier(int currentLevel) {
    if (currentLevel >= tiers.length) return null;
    return tiers[currentLevel];
  }
}
