import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:focora/presentation/screens/dashboard/widgets/dashboard_energy_section.dart';
import 'package:focora/presentation/screens/dashboard/widgets/dashboard_today_tasks_section.dart';
import 'package:focora/presentation/screens/dashboard/widgets/dashboard_inbox_section.dart';
import 'package:focora/presentation/screens/dashboard/widgets/dashboard_in_progress_section.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:focora/presentation/providers/energy_provider.dart';
import 'package:focora/domain/entities/task_entity.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';

// Gerar arquivo de mock
@GenerateMocks([TaskProvider, EnergyProvider])
import 'dashboard_widgets_test.mocks.dart';

void main() {
  group('Dashboard Widgets Tests', () {
    late MockTaskProvider mockTaskProvider;
    late MockEnergyProvider mockEnergyProvider;

    setUp(() {
      mockTaskProvider = MockTaskProvider();
      mockEnergyProvider = MockEnergyProvider();
    });

    group('DashboardEnergySection', () {
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
            home: Scaffold(
              body: ChangeNotifierProvider<EnergyProvider>.value(
                value: mockEnergyProvider,
                child: const DashboardEnergySection(),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Como está sua energia?'), findsOneWidget);
        expect(find.byKey(const Key('energy_card')), findsOneWidget);
      });

      testWidgets('should display register card when no log exists', (WidgetTester tester) async {
        // Arrange
        when(mockEnergyProvider.latestLogForCurrentPeriod).thenReturn(null);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ChangeNotifierProvider<EnergyProvider>.value(
                value: mockEnergyProvider,
                child: const DashboardEnergySection(),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Como está sua energia?'), findsOneWidget);
        expect(find.byKey(const Key('energy_register_card')), findsOneWidget);
        expect(find.text('Registrar agora'), findsOneWidget);
      });
    });

    group('DashboardTodayTasksSection', () {
      testWidgets('should display today tasks when they exist', (WidgetTester tester) async {
        // Arrange
        when(mockTaskProvider.todayTasks).thenReturn([
          TaskEntity(
            id: '1',
            title: 'Task for Today',
            status: TaskStatus.inProgress,
            priority: TaskPriority.high,
          ),
        ]);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ChangeNotifierProvider<TaskProvider>.value(
                value: mockTaskProvider,
                child: const DashboardTodayTasksSection(),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Para hoje'), findsOneWidget);
        expect(find.text('Task for Today'), findsOneWidget);
        expect(find.byKey(const Key('today_tasks_section')), findsOneWidget);
      });

      testWidgets('should display empty state when no tasks exist', (WidgetTester tester) async {
        // Arrange
        when(mockTaskProvider.todayTasks).thenReturn([]);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ChangeNotifierProvider<TaskProvider>.value(
                value: mockTaskProvider,
                child: const DashboardTodayTasksSection(),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Para hoje'), findsOneWidget);
        expect(find.text('Nenhuma tarefa para hoje'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
      });
    });

    group('DashboardInboxSection', () {
      testWidgets('should display inbox tasks when they exist', (WidgetTester tester) async {
        // Arrange
        when(mockTaskProvider.inboxTasks).thenReturn([
          TaskEntity(
            id: '1',
            title: 'Inbox Task',
            status: TaskStatus.inbox,
            priority: TaskPriority.medium,
          ),
        ]);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ChangeNotifierProvider<TaskProvider>.value(
                value: mockTaskProvider,
                child: const DashboardInboxSection(),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Caixa de entrada'), findsOneWidget);
        expect(find.text('Inbox Task'), findsOneWidget);
        expect(find.byKey(const Key('inbox_section')), findsOneWidget);
        expect(find.byKey(const Key('inbox_see_all_button')), findsOneWidget);
      });

      testWidgets('should display empty state when no inbox tasks exist', (WidgetTester tester) async {
        // Arrange
        when(mockTaskProvider.inboxTasks).thenReturn([]);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ChangeNotifierProvider<TaskProvider>.value(
                value: mockTaskProvider,
                child: const DashboardInboxSection(),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Caixa de entrada'), findsOneWidget);
        expect(find.text('Caixa de entrada vazia'), findsOneWidget);
        expect(find.byIcon(Icons.inbox), findsOneWidget);
      });
    });

    group('DashboardInProgressSection', () {
      testWidgets('should display in progress tasks when they exist', (WidgetTester tester) async {
        // Arrange
        when(mockTaskProvider.inProgressTasks).thenReturn([
          TaskEntity(
            id: '1',
            title: 'In Progress Task',
            status: TaskStatus.inProgress,
            priority: TaskPriority.high,
          ),
        ]);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ChangeNotifierProvider<TaskProvider>.value(
                value: mockTaskProvider,
                child: const DashboardInProgressSection(),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Em andamento'), findsOneWidget);
        expect(find.text('In Progress Task'), findsOneWidget);
        expect(find.byKey(const Key('in_progress_section')), findsOneWidget);
      });

      testWidgets('should display empty state when no in progress tasks exist', (WidgetTester tester) async {
        // Arrange
        when(mockTaskProvider.inProgressTasks).thenReturn([]);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: ChangeNotifierProvider<TaskProvider>.value(
                value: mockTaskProvider,
                child: const DashboardInProgressSection(),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Em andamento'), findsOneWidget);
        expect(find.text('Nenhuma tarefa em andamento'), findsOneWidget);
        expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);
      });
    });
  });
}
