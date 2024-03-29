import 'package:app/pages/HomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

final buttonStart = find.text('COMENZAR');

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoute extends Mock implements Route<dynamic> {}

void main() {
  group('Home Page Tests', () {
    //mock class that can be used to test navigation events
    late MockNavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    testWidgets('Should navigate to Menu Page when button is pressed',
        (WidgetTester tester) async {
      // By registering a fallback value, we can prevent the test from failing due to unexpected method calls and focus on verifying the expected behavior of the Navigator object.
      registerFallbackValue(MockRoute());

      // Build the widget tree
      await tester.pumpWidget(MaterialApp(
        home: const HomePage(),
        navigatorObservers: [mockObserver],
        routes: {'/menu': (_) => const Text('Menu Page')},
      ));

      await tester.tap(buttonStart);

      // Rebuild the widget tree and wait until all asynchronous operations are complete
      await tester.pumpAndSettle();

      // Verify that the Navigator pushed two screens
      verify(() => mockObserver.didPush(any(), any())).called(2);
    });
  });
}
