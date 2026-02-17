class GameState {
  int coins;
  int coinsPerSecond;
  int autoClickerLevel;
  String selectedSkin;

  GameState({
    this.coins = 0,
    this.coinsPerSecond = 0,
    this.autoClickerLevel = 0,
    this.selectedSkin = 'default',
  });
}
