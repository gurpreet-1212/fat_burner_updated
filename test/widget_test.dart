// Basic Flutter widget test for Fat Burner app.

import 'package:flutter_test/flutter_test.dart';
import 'package:fat_burner/main.dart';

void main() {
  testWidgets('App loads with login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const FatBurnerApp());
    await tester.pumpAndSettle();

    expect(find.text('Fat Burner'), findsOneWidget);
    expect(find.text('Log in'), findsOneWidget);
  });
}
