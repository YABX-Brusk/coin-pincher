import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/game_state.dart';

class GameProvider extends ChangeNotifier with WidgetsBindingObserver {
  static const _storageKey = 'game_state';
  static const _saveInterval = Duration(seconds: 10);

  GameState _state = GameState();
  Timer? _autoSaveTimer;
  Timer? _autoClickTimer;
  bool _loaded = false;

  bool get loaded => _loaded;
  int get coins => _state.coins;
  int get coinsPerSecond => _state.coinsPerSecond;
  int get autoClickerLevel => _state.autoClickerLevel;
  String get selectedSkin => _state.selectedSkin;
  List<String> get purchasedSkins => _state.purchasedSkins;

  GameProvider() {
    WidgetsBinding.instance.addObserver(this);
  }

  /// Call once at app startup to load saved state.
  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      _state = GameState.decode(raw);
    }
    _loaded = true;
    _startAutoSave();
    _syncAutoClicker();
    notifyListeners();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, _state.encode());
  }

  void _startAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(_saveInterval, (_) => _save());
  }

  void _syncAutoClicker() {
    _autoClickTimer?.cancel();
    if (_state.coinsPerSecond > 0) {
      _autoClickTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        _state.coins += _state.coinsPerSecond;
        notifyListeners();
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _save();
    }
  }

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

  void setAutoClicker({required int level, required int coinsPerSecond}) {
    _state.autoClickerLevel = level;
    _state.coinsPerSecond = coinsPerSecond;
    _syncAutoClicker();
    notifyListeners();
  }

  void selectSkin(String skin) {
    _state.selectedSkin = skin;
    notifyListeners();
  }

  void unlockSkin(String skin) {
    if (!_state.purchasedSkins.contains(skin)) {
      _state.purchasedSkins.add(skin);
      notifyListeners();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autoSaveTimer?.cancel();
    _autoClickTimer?.cancel();
    _save();
    super.dispose();
  }
}
