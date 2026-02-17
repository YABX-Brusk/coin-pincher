import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/game_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CoinPincherApp());
}

class CoinPincherApp extends StatelessWidget {
  const CoinPincherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameProvider()..loadState(),
      child: MaterialApp(
        title: 'Coin Pincher',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.amber,
            brightness: Brightness.dark,
          ),
        ),
        home: Consumer<GameProvider>(
          builder: (context, game, _) {
            if (!game.loaded) {
              return const Scaffold(
                backgroundColor: Color(0xFF1A1A2E),
                body: Center(
                  child: CircularProgressIndicator(color: Color(0xFFFFD54F)),
                ),
              );
            }
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
