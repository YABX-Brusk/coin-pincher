import 'package:flutter/foundation.dart';
import '../models/game_state.dart';

class GameProvider extends ChangeNotifier {
  final GameState _state = GameState();

  int get coins => _state.coins;
  int get coinsPerSecond => _state.coinsPerSecond;
  int get autoClickerLevel => _state.autoClickerLevel;
  String get selectedSkin => _state.selectedSkin;

  void addCoin() {
    _state.coins++;
    notifyListeners();
  }

  void addCoins(int amount) {
    _state.coins += amount;
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (_state.coins >= amount) {
      _state.coins -= amount;
      notifyListeners();
      return true;
    }
    return false;
  }
}
