import 'package:flutter_test/flutter_test.dart';
import 'package:sleep_analytics_mobile/app/app.dart';

void main() {
  testWidgets('shows login screen before authentication', (tester) async {
    await tester.pumpWidget(const SleepAnalyticsApp());

    expect(find.text('Ласкаво просимо до Sleep Analytics'), findsOneWidget);
    expect(find.text('Увійти через Google'), findsOneWidget);
  });
}
