import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:focora/presentation/screens/dashboard/dashboard_screen_refactored.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:focora/presentation/providers/energy_provider.dart';
import 'package:focora/domain/entities/task_entity.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';

// Gerar arquivo de mock
@GenerateMocks([TaskProvider, EnergyProvider])
import 'dashboard_screen_refactored_test.mocks.dart';

void main() {
  group('DashboardScreenRefactored', () {
    late MockTaskProvider mockTaskProvider;
    late MockEnergyProvider mockEnergyProvider;

    setUp(() {
      mockTaskProvider = MockTaskProvider();
      mockEnergyProvider = MockEnergyProvider();
      
      // Configurar os mocks com dados básicos
      when(mockTaskProvider.todayTasks).thenReturn([]);
      when(mockTaskProvider.inboxTasks).thenReturn([]);
      when(mockTaskProvider.inProgressTasks).thenReturn([]);
      when(mockEnergyProvider.latestLogForCurrentPeriod).thenReturn(null);
      when(mockTaskProvider.loadTasks()).thenAnswer((_) async {});
      when(mockEnergyProvider.loadEnergyLogs()).thenAnswer((_) async {});
      when(mockTaskProvider.addSampleTasks()).thenAnswer((_) async {});
      when(mockEnergyProvider.addSampleEnergyLogs()).thenAnswer((_) async {});
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
        ),
      );

      // Assert
      expect(find.text('Focora'), findsOneWidget);
      expect(find.byKey(const Key('insights_button')), findsOneWidget);
      expect(find.byKey(const Key('notifications_button')), findsOneWidget);
      expect(find.byKey(const Key('settings_button')), findsOneWidget);
    });

    testWidgets('should display all main sections', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
        ),
      );

      // Assert
      expect(find.text('Como está sua energia?'), findsOneWidget);
      expect(find.text('Para hoje'), findsOneWidget);
      expect(find.text('Em andamento'), findsOneWidget);
      expect(find.text('Caixa de entrada'), findsOneWidget);
      expect(find.text('Coach Cognitivo'), findsOneWidget);
      expect(find.text('Ócio Criativo'), findsOneWidget);
      expect(find.text('Seus Insights'), findsOneWidget);
    });

    testWidgets('should handle refresh correctly', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
        ),
      );

      // Act
      await tester.fling(find.byType(SingleChildScrollView), const Offset(0, 300), 1000);
      await tester.pumpAndSettle();

      // Assert
      verify(mockTaskProvider.loadTasks()).called(greaterThan(0));
      verify(mockEnergyProvider.loadEnergyLogs()).called(greaterThan(0));
    });

    testWidgets('should display tasks when they exist', (WidgetTester tester) async {
      // Arrange
      when(mockTaskProvider.todayTasks).thenReturn([
        TaskEntity(
          id: '1',
          title: 'Test Task Today',
          status: TaskStatus.inProgress,
          priority: TaskPriority.high,
        ),
      ]);
      
      when(mockTaskProvider.inboxTasks).thenReturn([
        TaskEntity(
          id: '2',
          title: 'Test Inbox Task',
          status: TaskStatus.inbox,
          priority: TaskPriority.medium,
        ),
      ]);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Task Today'), findsOneWidget);
      expect(find.text('Test Inbox Task'), findsOneWidget);
    });

    testWidgets('should display energy card when log exists', (WidgetTester tester) async {
      // Arrange
      when(mockEnergyProvider.latestLogForCurrentPeriod).thenReturn(
        EnergyLogEntity(
          energyLevel: 4,
          focusLevel: 3,
          motivationLevel: 2,
        ),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
        ),
      );

      // Assert
      expect(find.byKey(const Key('energy_card')), findsOneWidget);
    });

    testWidgets('should display register energy card when no log exists', (WidgetTester tester) async {
      // Arrange
      when(mockEnergyProvider.latestLogForCurrentPeriod).thenReturn(null);

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
        ),
      );

      // Assert
      expect(find.byKey(const Key('energy_register_card')), findsOneWidget);
      expect(find.text('Registrar agora'), findsOneWidget);
    });

    testWidgets('should have bottom navigation bar', (WidgetTester tester) async {
      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreenRefactored(),
          ),
        ),
      );

      // Assert
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Caixa de Entrada'), findsOneWidget);
      expect(find.text('Pomodoro'), findsOneWidget);
      expect(find.text('Coach'), findsOneWidget);
      expect(find.text('Ócio'), findsOneWidget);
    });
  });
}
