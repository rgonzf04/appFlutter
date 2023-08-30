import 'package:app/pages/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

//Inicializate widgets
const emailKey = Key('emailTextField');
const passwordKey = Key('passwordTextField');
final buttonSignIn = find.text('INICIAR SESIÓN');
final buttonSignUp = find.text('REGISTRARSE');

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockRoute extends Mock implements Route<dynamic> {}

void main() {
  group('Login Page Tests', () {
    //mock class that can be used to test navigation events
    late MockNavigatorObserver mockObserver;

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });
/*
    testWidgets('Should navigate to Menu Page when button is pressed',
        (WidgetTester tester) async {
      // By registering a fallback value, we can prevent the test from failing due to unexpected method calls and focus on verifying the expected behavior of the Navigator object.
      registerFallbackValue(MockRoute());

      // Build the widget tree
      await tester.pumpWidget(MaterialApp(
        home: const LoginPage(),
        navigatorObservers: [mockObserver],
        routes: {'/menu': (_) => const Text('Menu Page')},
      ));

      //Enter text and tap button
      await tester.enterText(find.byKey(emailKey), 'test@example.com');
      await tester.enterText(find.byKey(passwordKey), 'abc123');
      await tester.tap(buttonSignIn);

      // Rebuild the widget tree and wait until all asynchronous operations are complete
      await tester.pumpAndSettle();

      // Verify that the Navigator pushed two screens
      verify(() => mockObserver.didPush(any(), any())).called(2);
    });

    testWidgets('Should navigate to SignUp Page when button is pressed',
        (WidgetTester tester) async {
      // By registering a fallback value, we can prevent the test from failing due to unexpected method calls and focus on verifying the expected behavior of the Navigator object.
      registerFallbackValue(MockRoute());

      // Build the widget tree
      await tester.pumpWidget(MaterialApp(
        home: const LoginPage(),
        navigatorObservers: [mockObserver],
        routes: {'/signUp': (_) => const Text('SignUp Page')},
      ));

      //Tap button
      await tester.tap(buttonSignUp);

      // Rebuild the widget tree and wait until all asynchronous operations are complete
      await tester.pumpAndSettle();

      // Verify that the Navigator pushed two screens
      verify(() => mockObserver.didPush(any(), any())).called(2);
    });*/
  });
}
