import 'package:flutter_test/flutter_test.dart';
import 'package:coin_pincher/main.dart';

void main() {
  testWidgets('App renders home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CoinPincherApp());
    expect(find.text('COINS'), findsOneWidget);
    expect(find.text('Pinch the coin to collect!'), findsOneWidget);
  });
}
