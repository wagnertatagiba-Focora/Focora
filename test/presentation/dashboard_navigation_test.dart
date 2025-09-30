import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:focora/presentation/screens/dashboard/dashboard_screen_refactored.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:focora/presentation/providers/energy_provider.dart';
import 'package:focora/app/routes.dart';
import '../helpers/test_navigator_observer.dart';

// Gerar arquivo de mock
@GenerateMocks([TaskProvider, EnergyProvider])
void main() {
  group('Dashboard Navigation Tests', () {
    late TaskProvider mockTaskProvider;
    late EnergyProvider mockEnergyProvider;

    setUp(() {
      mockTaskProvider = MockTaskProvider();
      mockEnergyProvider = MockEnergyProvider();
      
      // Configurar mocks básicos
      when(mockTaskProvider.tasks).thenReturn([]);
      when(mockTaskProvider.todayTasks).thenReturn([]);
      when(mockTaskProvider.inboxTasks).thenReturn([]);
      when(mockTaskProvider.inProgressTasks).thenReturn([]);
      when(mockTaskProvider.completedTasks).thenReturn([]);
      when(mockTaskProvider.overdueTasks).thenReturn([]);
      when(mockEnergyProvider.energyLogs).thenReturn([]);
      when(mockEnergyProvider.todayLogs).thenReturn([]);
      when(mockEnergyProvider.latestLog).thenReturn(null);
      when(mockEnergyProvider.latestLogForCurrentPeriod).thenReturn(null);
      
      // Configurar métodos assíncronos
      when(mockTaskProvider.loadTasks()).thenAnswer((_) async {});
      when(mockEnergyProvider.loadEnergyLogs()).thenAnswer((_) async {});
      when(mockTaskProvider.addSampleTasks()).thenAnswer((_) async {});
      when(mockEnergyProvider.addSampleEnergyLogs()).thenAnswer((_) async {});
      
      // Limpar observer antes de cada teste
      NavigationTestHelper.clearObserver();
    });

    group('AppBar Navigation', () {
      testWidgets('should navigate to insights when insights button is tapped', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
          routes: {
            AppRoutes.insights: (context) => const MockInsightsScreen(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.byKey(const Key('insights_button')));
        await tester.pumpAndSettle();

        // Assert
        final observer = NavigationTestHelper.observer;
        expect(observer.hasNavigatedTo(AppRoutes.insights), isTrue);
        expect(observer.currentRoute, AppRoutes.insights);
        expect(observer.getNavigationCount(AppRoutes.insights), 1);
      });

      testWidgets('should track navigation events for insights button', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
          routes: {
            AppRoutes.insights: (context) => const MockInsightsScreen(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.byKey(const Key('insights_button')));
        await tester.pumpAndSettle();

        // Assert
        final observer = NavigationTestHelper.observer;
        final pushEvents = observer.getEventsByType(NavigationType.push);
        expect(pushEvents.length, 1);
        expect(pushEvents.first.routeName, AppRoutes.insights);
        expect(pushEvents.first.type, NavigationType.push);
      });
    });

    group('Bottom Navigation', () {
      testWidgets('should navigate to inbox when inbox tab is tapped', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
          routes: {
            AppRoutes.inbox: (context) => const MockInboxScreen(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Caixa de Entrada'));
        await tester.pumpAndSettle();

        // Assert
        final observer = NavigationTestHelper.observer;
        expect(observer.hasNavigatedTo(AppRoutes.inbox), isTrue);
        expect(observer.currentRoute, AppRoutes.inbox);
      });

      testWidgets('should navigate to pomodoro when pomodoro tab is tapped', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
          routes: {
            AppRoutes.pomodoro: (context) => const MockPomodoroScreen(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Pomodoro'));
        await tester.pumpAndSettle();

        // Assert
        final observer = NavigationTestHelper.observer;
        expect(observer.hasNavigatedTo(AppRoutes.pomodoro), isTrue);
        expect(observer.currentRoute, AppRoutes.pomodoro);
      });

      testWidgets('should navigate to coach when coach tab is tapped', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
          routes: {
            AppRoutes.coach: (context) => const MockCoachScreen(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Coach'));
        await tester.pumpAndSettle();

        // Assert
        final observer = NavigationTestHelper.observer;
        expect(observer.hasNavigatedTo(AppRoutes.coach), isTrue);
        expect(observer.currentRoute, AppRoutes.coach);
      });

      testWidgets('should navigate to ocio when ocio tab is tapped', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
          routes: {
            AppRoutes.ocio: (context) => const MockOcioScreen(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Ócio'));
        await tester.pumpAndSettle();

        // Assert
        final observer = NavigationTestHelper.observer;
        expect(observer.hasNavigatedTo(AppRoutes.ocio), isTrue);
        expect(observer.currentRoute, AppRoutes.ocio);
      });
    });

    group('Section Navigation', () {
      testWidgets('should navigate to energy log when register energy is tapped', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
          routes: {
            AppRoutes.energyLog: (context) => const MockEnergyLogScreen(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.text('Registrar agora'));
        await tester.pumpAndSettle();

        // Assert
        final observer = NavigationTestHelper.observer;
        expect(observer.hasNavigatedTo(AppRoutes.energyLog), isTrue);
        expect(observer.currentRoute, AppRoutes.energyLog);
      });

      testWidgets('should navigate to inbox when "Ver todas" is tapped in inbox section', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
          routes: {
            AppRoutes.inbox: (context) => const MockInboxScreen(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.byKey(const Key('inbox_see_all_button')));
        await tester.pumpAndSettle();

        // Assert
        final observer = NavigationTestHelper.observer;
        expect(observer.hasNavigatedTo(AppRoutes.inbox), isTrue);
        expect(observer.currentRoute, AppRoutes.inbox);
      });
    });

    group('Navigation Flow Tests', () {
      testWidgets('should track complete navigation flow', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
          routes: {
            AppRoutes.insights: (context) => const MockInsightsScreen(),
            AppRoutes.coach: (context) => const MockCoachScreen(),
            AppRoutes.inbox: (context) => const MockInboxScreen(),
          },
        );

        // Act - Navigate through multiple screens
        await tester.pumpWidget(app);
        
        // Navigate to insights
        await tester.tap(find.byKey(const Key('insights_button')));
        await tester.pumpAndSettle();
        
        // Navigate back
        Navigator.of(tester.element(find.byType(MockInsightsScreen))).pop();
        await tester.pumpAndSettle();
        
        // Navigate to coach
        await tester.tap(find.text('Coach'));
        await tester.pumpAndSettle();
        
        // Navigate to inbox
        Navigator.of(tester.element(find.byType(MockCoachScreen))).pop();
        await tester.pumpAndSettle();
        await tester.tap(find.text('Caixa de Entrada'));
        await tester.pumpAndSettle();

        // Assert
        final observer = NavigationTestHelper.observer;
        expect(observer.hasNavigationSequence([AppRoutes.insights]), isTrue);
        expect(observer.hasNavigatedTo(AppRoutes.coach), isTrue);
        expect(observer.hasNavigatedTo(AppRoutes.inbox), isTrue);
        expect(observer.getNavigationCount(AppRoutes.insights), 1);
        expect(observer.getNavigationCount(AppRoutes.coach), 1);
        expect(observer.getNavigationCount(AppRoutes.inbox), 1);
        
        return null;
      });

      testWidgets('should provide detailed navigation summary', (WidgetTester tester) async {
        // Arrange
        final app = NavigationTestHelper.createTestApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
          routes: {
            AppRoutes.insights: (context) => const MockInsightsScreen(),
            AppRoutes.coach: (context) => const MockCoachScreen(),
          },
        );

        // Act
        await tester.pumpWidget(app);
        await tester.tap(find.byKey(const Key('insights_button')));
        await tester.pumpAndSettle();
        Navigator.of(tester.element(find.byType(MockInsightsScreen))).pop();
        await tester.pumpAndSettle();
        await tester.tap(find.text('Coach'));
        await tester.pumpAndSettle();

        // Assert
        final observer = NavigationTestHelper.observer;
        final summary = observer.getNavigationSummary();
        
        expect(summary, contains('Current Route: ${AppRoutes.coach}'));
        expect(summary, contains('Total Navigations: 2'));
        expect(summary, contains(AppRoutes.insights));
        expect(summary, contains(AppRoutes.coach));
        
        // Debug output for development
        debugPrint(summary);
        
        return null;
      });
    });
  });
}

// Mock screens para testes de navegação
class MockInsightsScreen extends StatelessWidget {
  const MockInsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: const Center(child: Text('Mock Insights Screen')),
    );
  }
}

class MockInboxScreen extends StatelessWidget {
  const MockInboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: const Center(child: Text('Mock Inbox Screen')),
    );
  }
}

class MockPomodoroScreen extends StatelessWidget {
  const MockPomodoroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pomodoro')),
      body: const Center(child: Text('Mock Pomodoro Screen')),
    );
  }
}

class MockCoachScreen extends StatelessWidget {
  const MockCoachScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Coach')),
      body: const Center(child: Text('Mock Coach Screen')),
    );
  }
}

class MockOcioScreen extends StatelessWidget {
  const MockOcioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ócio')),
      body: const Center(child: Text('Mock Ócio Screen')),
    );
  }
}

class MockEnergyLogScreen extends StatelessWidget {
  const MockEnergyLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Energy Log')),
      body: const Center(child: Text('Mock Energy Log Screen')),
    );
  }
}

// Implementações de mock para os testes
class MockTaskProvider extends Mock implements TaskProvider {
  @override
  Future<void> addSampleTasks() async {}
}

class MockEnergyProvider extends Mock implements EnergyProvider {
  @override
  Future<void> addSampleEnergyLogs() async {}
}
