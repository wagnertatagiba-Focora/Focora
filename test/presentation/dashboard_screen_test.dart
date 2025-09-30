import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:focora/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:focora/presentation/providers/energy_provider.dart';
import 'package:focora/domain/entities/task_entity.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';

// Gerar arquivo de mock
@GenerateMocks([TaskProvider, EnergyProvider])
import 'dashboard_screen_test.mocks.dart';

void main() {
  group('DashboardScreen', () {
    late MockTaskProvider mockTaskProvider;
    late MockEnergyProvider mockEnergyProvider;

    setUp(() {
      mockTaskProvider = MockTaskProvider();
      mockEnergyProvider = MockEnergyProvider();
      
      // Configurar os mocks
      when(mockTaskProvider.todayTasks).thenReturn([
        TaskEntity(
          id: '1',
          title: 'Test Task 1',
          status: TaskStatus.inProgress,
          priority: TaskPriority.high,
        ),
        TaskEntity(
          id: '2',
          title: 'Test Task 2',
          status: TaskStatus.inProgress,
          priority: TaskPriority.medium,
        ),
      ]);
      
      when(mockTaskProvider.inboxTasks).thenReturn([
        TaskEntity(
          id: '3',
          title: 'Inbox Task',
          status: TaskStatus.inbox,
          priority: TaskPriority.low,
        ),
      ]);
      
      when(mockEnergyProvider.latestLog).thenReturn(
        EnergyLogEntity(
          energyLevel: 4,
          focusLevel: 3,
          motivationLevel: 2,
        )
      );
    });

    testWidgets('should display today tasks', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreen(),
          ),
        ),
      );
      
      // Act - just pumping the widget
      
      // Assert
      expect(find.text('Test Task 1'), findsOneWidget);
      expect(find.text('Test Task 2'), findsOneWidget);
    });
    
    testWidgets('should display inbox tasks', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreen(),
          ),
        ),
      );
      
      // Act - just pumping the widget
      
      // Assert
      expect(find.text('Inbox Task'), findsOneWidget);
    });
    
    testWidgets('should display energy level', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreen(),
          ),
        ),
      );
      
      // Act - just pumping the widget
      
      // Assert
      // Verificar se o widget de energia está presente
      // Como não podemos verificar valores específicos facilmente, verificamos se o widget existe
      expect(find.byKey(const Key('energy_card')), findsOneWidget);
    });
    
    testWidgets('should display inbox section', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const DashboardScreen(),
          ),
        ),
      );
      
      // Act - just pumping the widget
      
      // Assert
      // Verificar se a seção de inbox está presente
      expect(find.byKey(const Key('inbox_card')), findsOneWidget);
      verify(mockTaskProvider.inboxTasks).called(greaterThan(0));
    });
  });
}
