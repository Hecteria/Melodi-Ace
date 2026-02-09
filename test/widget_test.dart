import 'package:flutter_test/flutter_test.dart';
import 'package:melodi/main.dart';

void main() {
  testWidgets('App builds successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const MelodiApp());
    expect(find.text('Get Started'), findsOneWidget);
  });
}
