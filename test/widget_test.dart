import 'package:demo/auth.dart';
import 'package:demo/orders.dart';
import 'package:demo/register.dart';
import 'package:demo/login.dart';
import 'package:demo/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_test/flutter_test.dart';

// class MockRepository extends Repository {
//   @override
//   Future<bool> login(String email, String password) async {
//     return Future.value(true);
//   }
// }

void main() {
  group('Initial screen', () {
    testWidgets('Initial screen has logo', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InitialScreen()));
      expect(find.byType(SvgPicture), findsOneWidget);
    });

    testWidgets('Initial screen has registration button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InitialScreen()));
      expect(find.text('Registration'), findsOneWidget);
    });

    testWidgets('Initial screen has login button', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InitialScreen()));
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Initial screen navigation to registration screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InitialScreen()));

      await tester.tap(find.text('Registration'));
      await tester.pumpAndSettle();

      expect(find.byType(RegistrationScreen), findsOneWidget);
    });

    testWidgets('Initial screen navigation to login screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: InitialScreen()));

      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
  group('RegistrationScreen widget', () {
    testWidgets('shows registration form', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegistrationScreen()));

      expect(find.text('Registration'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Customer'), findsOneWidget);
      expect(find.text('Manager'), findsOneWidget);
      expect(find.text('You have an account?'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);
      expect(find.text('Submit'), findsOneWidget);
    });

    testWidgets(
        'Tapping Register button without filling text fields shows empty fields validation errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegistrationScreen()));

      final btn = find.text('Submit');
      expect(btn, findsOneWidget);
      await tester.tap(btn);
      await tester.pumpAndSettle();

      final emailField = find.widgetWithText(TextFormField, 'Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Tapping Register with invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: RegistrationScreen()));

      final btn = find.text('Submit');
      expect(btn, findsOneWidget);

      final emailField = find.widgetWithText(TextFormField, 'Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');

      await tester.enterText(emailField, 'invalidmail@e');
      await tester.enterText(passwordField, 'qwerty');
      await tester.tap(btn);
      await tester.pumpAndSettle();

      // Check for validation errors
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });
  });

    group('Login screen', () {
    testWidgets('shows registration form', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));
      expect(find.text('Not Registered Yet?'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Log in'), findsOneWidget);

    });

    testWidgets(
        'Tapping Register button without filling text fields shows empty fields validation errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      final btn = find.text('Log in');
      expect(btn, findsOneWidget);
      await tester.tap(btn);
      await tester.pumpAndSettle();

      final emailField = find.widgetWithText(TextFormField, 'Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');
      expect(emailField, findsOneWidget);
      expect(passwordField, findsOneWidget);
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Tapping Register with invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: LoginScreen()));

      final btn = find.text('Log in');
      expect(btn, findsOneWidget);

      final emailField = find.widgetWithText(TextFormField, 'Email');
      final passwordField = find.widgetWithText(TextFormField, 'Password');

      await tester.enterText(emailField, 'invalidmail@e');
      await tester.enterText(passwordField, 'qwerty');
      await tester.tap(btn);
      await tester.pumpAndSettle();

      // Check for validation errors
      expect(find.text('Please enter a valid email'), findsOneWidget);
    });
  });
}
