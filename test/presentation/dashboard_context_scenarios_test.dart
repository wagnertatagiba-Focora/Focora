import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focora/presentation/screens/dashboard/dashboard_screen_refactored.dart';
import '../helpers/context_mocks.dart';

void main() {
  group('Dashboard Context Scenarios Tests', () {
    group('New User Context', () {
      testWidgets('should display empty states for new user', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createNewUserContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        expect(find.text('Registrar agora'), findsOneWidget);
        expect(find.text('Nenhuma tarefa para hoje'), findsOneWidget);
        expect(find.text('Caixa de entrada vazia'), findsOneWidget);
        expect(find.text('Nenhuma tarefa em andamento'), findsOneWidget);
        
        // Verify empty state icons
        expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);
        expect(find.byIcon(Icons.inbox), findsOneWidget);
        expect(find.byIcon(Icons.hourglass_empty), findsOneWidget);
      });

      testWidgets('should show onboarding-friendly interface for new user', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createNewUserContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        expect(find.text('Como está sua energia?'), findsOneWidget);
        expect(find.text('Coach Cognitivo'), findsOneWidget);
        expect(find.text('Ócio Criativo'), findsOneWidget);
        expect(find.text('Seus Insights'), findsOneWidget);
        
        // Should encourage first actions
        expect(find.text('Registrar agora'), findsOneWidget);
      });
    });

    group('Productive User Context', () {
      testWidgets('should display active tasks and energy for productive user', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createProductiveUserContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        // Should show energy card instead of register prompt
        expect(find.byKey(const Key('energy_card')), findsOneWidget);
        expect(find.text('Registrar agora'), findsNothing);
        
        // Should show tasks
        expect(find.text('Revisar relatório mensal'), findsOneWidget);
        expect(find.text('Preparar apresentação'), findsOneWidget);
        expect(find.text('Planejar próxima sprint'), findsOneWidget);
        
        // Should not show empty states
        expect(find.text('Nenhuma tarefa para hoje'), findsNothing);
        expect(find.text('Caixa de entrada vazia'), findsNothing);
      });

      testWidgets('should show balanced sections for productive user', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createProductiveUserContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        expect(find.text('Para hoje'), findsOneWidget);
        expect(find.text('Em andamento'), findsOneWidget);
        expect(find.text('Caixa de entrada'), findsOneWidget);
        
        // Verify task distribution
        expect(find.text('Revisar relatório mensal'), findsOneWidget);
        expect(find.text('Preparar apresentação'), findsOneWidget);
      });
    });

    group('Procrastinator Context', () {
      testWidgets('should highlight overdue tasks for procrastinator', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createProcrastinatorContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        // Should show overdue and pending tasks
        expect(find.text('Tarefa atrasada há 3 dias'), findsOneWidget);
        expect(find.text('Projeto importante atrasado'), findsOneWidget);
        expect(find.text('Email urgente não respondido'), findsOneWidget);
        
        // Should show low energy
        expect(find.byKey(const Key('energy_card')), findsOneWidget);
        
        // Should show many inbox items
        expect(find.text('Email urgente não respondido'), findsOneWidget);
        expect(find.text('Relatório pendente'), findsOneWidget);
      });

      testWidgets('should emphasize urgent actions for procrastinator', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createProcrastinatorContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        // Should not show "no tasks" messages
        expect(find.text('Nenhuma tarefa para hoje'), findsNothing);
        expect(find.text('Caixa de entrada vazia'), findsNothing);
        
        // Should show tasks that need attention
        expect(find.text('Tarefa atrasada há 3 dias'), findsOneWidget);
        expect(find.text('Projeto importante atrasado'), findsOneWidget);
      });
    });

    group('Recovering User Context', () {
      testWidgets('should show progress and positive reinforcement for recovering user', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createRecoveringUserContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        // Should show completed positive habits
        expect(find.text('Exercício matinal'), findsOneWidget);
        expect(find.text('Meditar 10 minutos'), findsOneWidget);
        
        // Should show ongoing improvement tasks
        expect(find.text('Organizar mesa de trabalho'), findsOneWidget);
        expect(find.text('Ler 20 páginas do livro'), findsOneWidget);
        
        // Should show energy tracking
        expect(find.byKey(const Key('energy_card')), findsOneWidget);
      });

      testWidgets('should balance completed and ongoing tasks for recovering user', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createRecoveringUserContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        // Should show mix of completed and in-progress
        expect(find.text('Exercício matinal'), findsOneWidget);
        expect(find.text('Organizar mesa de trabalho'), findsOneWidget);
        expect(find.text('Planejar semana'), findsOneWidget);
        
        // Should not show empty states
        expect(find.text('Nenhuma tarefa em andamento'), findsNothing);
      });
    });

    group('Stressed User Context', () {
      testWidgets('should show overwhelming task load for stressed user', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createStressedUserContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        // Should show multiple high-priority tasks
        expect(find.text('Apresentação para CEO'), findsOneWidget);
        expect(find.text('Corrigir bug crítico'), findsOneWidget);
        expect(find.text('Reunião com cliente'), findsOneWidget);
        
        // Should show many inbox items
        expect(find.text('Revisar código da equipe'), findsOneWidget);
        expect(find.text('Atualizar sistema'), findsOneWidget);
        
        // Should show energy tracking (likely low energy, high stress)
        expect(find.byKey(const Key('energy_card')), findsOneWidget);
      });

      testWidgets('should emphasize urgent priorities for stressed user', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createStressedUserContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        // Should not show empty states
        expect(find.text('Nenhuma tarefa para hoje'), findsNothing);
        expect(find.text('Caixa de entrada vazia'), findsNothing);
        expect(find.text('Nenhuma tarefa em andamento'), findsNothing);
        
        // Should show high-priority tasks
        expect(find.text('Apresentação para CEO'), findsOneWidget);
        expect(find.text('Corrigir bug crítico'), findsOneWidget);
      });
    });

    group('Balanced User Context', () {
      testWidgets('should show healthy mix of work and personal tasks for balanced user', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createBalancedUserContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        // Should show work tasks
        expect(find.text('Revisar projeto principal'), findsOneWidget);
        expect(find.text('Ler artigo técnico'), findsOneWidget);
        
        // Should show personal tasks
        expect(find.text('Exercitar-se'), findsOneWidget);
        expect(find.text('Planejar fim de semana'), findsOneWidget);
        
        // Should show energy tracking
        expect(find.byKey(const Key('energy_card')), findsOneWidget);
      });

      testWidgets('should show optimal dashboard layout for balanced user', (WidgetTester tester) async {
        // Arrange
        final context = ContextMocks.createBalancedUserContext();
        final app = context.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act
        await tester.pumpWidget(app);

        // Assert
        // Should have content in all sections but not overwhelming
        expect(find.text('Para hoje'), findsOneWidget);
        expect(find.text('Em andamento'), findsOneWidget);
        expect(find.text('Caixa de entrada'), findsOneWidget);
        
        // Should show balanced task distribution
        expect(find.text('Revisar projeto principal'), findsOneWidget);
        expect(find.text('Ler artigo técnico'), findsOneWidget);
        expect(find.text('Planejar fim de semana'), findsOneWidget);
        
        // Should not show empty states
        expect(find.text('Nenhuma tarefa em andamento'), findsNothing);
      });
    });

    group('Context Comparison Tests', () {
      testWidgets('should show different content for different user contexts', (WidgetTester tester) async {
        // Test New User vs Productive User
        
        // Arrange - New User
        final newUserContext = ContextMocks.createNewUserContext();
        final newUserApp = newUserContext.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act - Test New User
        await tester.pumpWidget(newUserApp);
        
        // Assert - New User should see empty states
        expect(find.text('Registrar agora'), findsOneWidget);
        expect(find.text('Nenhuma tarefa para hoje'), findsOneWidget);

        // Arrange - Productive User
        final productiveContext = ContextMocks.createProductiveUserContext();
        final productiveApp = productiveContext.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act - Test Productive User
        await tester.pumpWidget(productiveApp);
        
        // Assert - Productive User should see tasks and energy
        expect(find.byKey(const Key('energy_card')), findsOneWidget);
        expect(find.text('Revisar relatório mensal'), findsOneWidget);
        expect(find.text('Registrar agora'), findsNothing);
        expect(find.text('Nenhuma tarefa para hoje'), findsNothing);
      });

      testWidgets('should adapt UI based on user stress level', (WidgetTester tester) async {
        // Test Balanced vs Stressed User
        
        // Arrange - Balanced User
        final balancedContext = ContextMocks.createBalancedUserContext();
        final balancedApp = balancedContext.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act - Test Balanced User
        await tester.pumpWidget(balancedApp);
        
        // Assert - Should show personal and work balance
        expect(find.text('Exercitar-se'), findsOneWidget);
        expect(find.text('Planejar fim de semana'), findsOneWidget);

        // Arrange - Stressed User
        final stressedContext = ContextMocks.createStressedUserContext();
        final stressedApp = stressedContext.createTestApp(
          child: const DashboardScreenRefactored(),
        );

        // Act - Test Stressed User
        await tester.pumpWidget(stressedApp);
        
        // Assert - Should show urgent work tasks
        expect(find.text('Apresentação para CEO'), findsOneWidget);
        expect(find.text('Corrigir bug crítico'), findsOneWidget);
        expect(find.text('Exercitar-se'), findsNothing);
      });
    });
  });
}
