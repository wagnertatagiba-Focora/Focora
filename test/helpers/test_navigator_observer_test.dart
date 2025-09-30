import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_navigator_observer.dart';

void main() {
  group('TestNavigatorObserver', () {
    late TestNavigatorObserver observer;

    setUp(() {
      observer = TestNavigatorObserver();
    });

    group('Navigation Tracking', () {
      testWidgets('should track navigation to new route', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: const HomePage(),
          routes: {
            '/second': (context) => const SecondPage(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Go to Second'));
        await tester.pumpAndSettle();

        // Assert
        final testObserver = NavigationTestHelper.observer;
        expect(testObserver.hasNavigatedTo('/second'), isTrue);
        expect(testObserver.currentRoute, '/second');
        // O Flutter registra a rota inicial "/" e depois "/second"
        expect(testObserver.navigatedRoutes.length, greaterThanOrEqualTo(1));
        expect(testObserver.navigatedRoutes.contains('/second'), isTrue);
      });

      testWidgets('should track navigation back', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: const HomePage(),
          routes: {
            '/second': (context) => const SecondPage(),
          },
        );

        await tester.pumpWidget(app);
        await tester.tap(find.text('Go to Second'));
        await tester.pumpAndSettle();

        // Act - Navigate back
        await tester.tap(find.text('Go Back'));
        await tester.pumpAndSettle();

        // Assert
        final testObserver = NavigationTestHelper.observer;
        expect(testObserver.hasRemovedRoute('/second'), isTrue);
        expect(testObserver.removedRoutes.contains('/second'), isTrue);
      });

      testWidgets('should track multiple navigations', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: const HomePage(),
          routes: {
            '/second': (context) => const SecondPage(),
            '/third': (context) => const ThirdPage(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        
        // Navigate to second page
        await tester.tap(find.text('Go to Second'));
        await tester.pumpAndSettle();
        
        // Navigate to third page
        await tester.tap(find.text('Go to Third'));
        await tester.pumpAndSettle();

        // Assert
        final testObserver = NavigationTestHelper.observer;
        // O Flutter registra a rota inicial "/" e depois as navegações
        expect(testObserver.navigatedRoutes.contains('/second'), isTrue);
        expect(testObserver.navigatedRoutes.contains('/third'), isTrue);
        expect(testObserver.currentRoute, '/third');
        expect(testObserver.getNavigationCount('/second'), 1);
        expect(testObserver.getNavigationCount('/third'), 1);
      });

      testWidgets('should track navigation sequence', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: const HomePage(),
          routes: {
            '/second': (context) => const SecondPage(),
            '/third': (context) => const ThirdPage(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Go to Second'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Go to Third'));
        await tester.pumpAndSettle();

        // Assert
        final testObserver = NavigationTestHelper.observer;
        expect(testObserver.hasNavigationSequence(['/second', '/third']), isTrue);
        expect(testObserver.hasNavigationSequence(['/third', '/second']), isFalse);
      });
    });

    group('Navigation Events', () {
      testWidgets('should record navigation events with correct types', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: const HomePage(),
          routes: {
            '/second': (context) => const SecondPage(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Go to Second'));
        await tester.pumpAndSettle();

        // Assert
        final testObserver = NavigationTestHelper.observer;
        final pushEvents = testObserver.getEventsByType(NavigationType.push);
        // Deve ter pelo menos 1 evento push (pode ter mais devido à rota inicial)
        expect(pushEvents.length, greaterThanOrEqualTo(1));
        // Verificar se há um evento push para '/second'
        final secondPageEvents = pushEvents.where((e) => e.routeName == '/second').toList();
        expect(secondPageEvents.length, 1);
        expect(secondPageEvents.first.type, NavigationType.push);
      });

      testWidgets('should record pop events', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: const HomePage(),
          routes: {
            '/second': (context) => const SecondPage(),
          },
        );

        await tester.pumpWidget(app);
        await tester.tap(find.text('Go to Second'));
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.text('Go Back'));
        await tester.pumpAndSettle();

        // Assert
        final testObserver = NavigationTestHelper.observer;
        final popEvents = testObserver.getEventsByType(NavigationType.pop);
        expect(popEvents.length, 1);
        expect(popEvents.first.routeName, '/second');
        expect(popEvents.first.type, NavigationType.pop);
      });

      testWidgets('should provide navigation summary', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: const HomePage(),
          routes: {
            '/second': (context) => const SecondPage(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Go to Second'));
        await tester.pumpAndSettle();

        // Assert
        final testObserver = NavigationTestHelper.observer;
        final summary = testObserver.getNavigationSummary();
        expect(summary, contains('Current Route: /second'));
        expect(summary, contains('Total Navigations:'));
        expect(summary, contains('/second'));
      });
    });

    group('Observer Management', () {
      testWidgets('should clear navigation history', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: const HomePage(),
          routes: {
            '/second': (context) => const SecondPage(),
          },
        );

        await tester.pumpWidget(app);
        await tester.tap(find.text('Go to Second'));
        await tester.pumpAndSettle();

        // Act
        NavigationTestHelper.clearObserver();

        // Assert
        final newObserver = NavigationTestHelper.observer;
        expect(newObserver.navigatedRoutes, isEmpty);
        expect(newObserver.navigationEvents, isEmpty);
        expect(newObserver.currentRoute, isNull);
      });
    });
  });
}

/// Widget de teste para a página inicial
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Home Page'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/second');
              },
              child: const Text('Go to Second'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de teste para a segunda página
class SecondPage extends StatelessWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Second Page'),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/third');
              },
              child: const Text('Go to Third'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget de teste para a terceira página
class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Third')),
      body: const Center(
        child: Text('Third Page'),
      ),
    );
  }
}
