import 'package:flutter_test/flutter_test.dart';
import 'package:home_art/app.dart';

void main() {
  testWidgets('Smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const HomeArtApp());
  });
}
