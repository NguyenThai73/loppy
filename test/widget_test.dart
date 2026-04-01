import 'package:flutter_test/flutter_test.dart';

import 'package:loppy/main.dart';

void main() {
  testWidgets('App loads correctly', (WidgetTester tester) async {
    await tester.pumpWidget(const LoppyApp());
    expect(find.text('Bai viet'), findsOneWidget);
  });
}
