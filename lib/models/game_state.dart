import 'dart:convert';

class GameState {
  int coins;
  int coinsPerSecond;
  int autoClickerLevel;
  String selectedSkin;
  List<String> purchasedSkins;

  GameState({
    this.coins = 0,
    this.coinsPerSecond = 0,
    this.autoClickerLevel = 0,
    this.selectedSkin = 'default',
    List<String>? purchasedSkins,
  }) : purchasedSkins = purchasedSkins ?? ['default'];

  Map<String, dynamic> toJson() => {
        'coins': coins,
        'coinsPerSecond': coinsPerSecond,
        'autoClickerLevel': autoClickerLevel,
        'selectedSkin': selectedSkin,
        'purchasedSkins': purchasedSkins,
      };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
        coins: json['coins'] as int? ?? 0,
        coinsPerSecond: json['coinsPerSecond'] as int? ?? 0,
        autoClickerLevel: json['autoClickerLevel'] as int? ?? 0,
        selectedSkin: json['selectedSkin'] as String? ?? 'default',
        purchasedSkins: (json['purchasedSkins'] as List<dynamic>?)
                ?.cast<String>() ??
            ['default'],
      );

  String encode() => jsonEncode(toJson());

  factory GameState.decode(String source) =>
      GameState.fromJson(jsonDecode(source) as Map<String, dynamic>);
}
