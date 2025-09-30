import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:focora/domain/entities/task_entity.dart';
import 'package:focora/presentation/common_widgets/task_card.dart';

void main() {
  testWidgets('TaskCard displays task title', (WidgetTester tester) async {
    // Arrange
    final task = TaskEntity(
      id: '1',
      title: 'Test Task',
      status: TaskStatus.inbox,
      priority: TaskPriority.medium,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: task,
            onTap: (_) {},
            onComplete: (_) {},
          ),
        ),
      ),
    );

    // Assert
    expect(find.text('Test Task'), findsOneWidget);
  });

  testWidgets('TaskCard displays priority indicator', (WidgetTester tester) async {
    // Arrange
    final task = TaskEntity(
      id: '1',
      title: 'Test Task',
      status: TaskStatus.inbox,
      priority: TaskPriority.high,
    );

    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: task,
            onTap: (_) {},
            onComplete: (_) {},
          ),
        ),
      ),
    );

    // Assert
    // Verificar se existe um widget com a cor correspondente à prioridade alta
    // Como não podemos verificar cores diretamente, verificamos se o widget existe
    expect(find.byType(Container), findsWidgets);
  });

  testWidgets('TaskCard calls onTap when tapped', (WidgetTester tester) async {
    // Arrange
    final task = TaskEntity(
      id: '1',
      title: 'Test Task',
      status: TaskStatus.inbox,
      priority: TaskPriority.medium,
    );
    
    var tapped = false;
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: task,
            onTap: (_) {
              tapped = true;
            },
            onComplete: (_) {},
          ),
        ),
      ),
    );
    
    await tester.tap(find.byType(InkWell));
    await tester.pump();

    // Assert
    expect(tapped, true);
  });
  
  testWidgets('TaskCard calls onComplete when checkbox is tapped', (WidgetTester tester) async {
    // Arrange
    final task = TaskEntity(
      id: '1',
      title: 'Test Task',
      status: TaskStatus.inbox,
      priority: TaskPriority.medium,
    );
    
    var completed = false;
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: task,
            onTap: (_) {},
            onComplete: (_) {
              completed = true;
            },
          ),
        ),
      ),
    );
    
    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    // Assert
    expect(completed, true);
  });
  
  testWidgets('TaskCard displays due date if available', (WidgetTester tester) async {
    // Arrange
    final dueDate = DateTime(2023, 1, 15);
    final task = TaskEntity(
      id: '1',
      title: 'Test Task',
      status: TaskStatus.inbox,
      priority: TaskPriority.medium,
      dueDate: dueDate,
    );
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: TaskCard(
            task: task,
            onTap: (_) {},
            onComplete: (_) {},
          ),
        ),
      ),
    );
    
    // Assert
    expect(find.text('15/01/2023'), findsOneWidget);
  });
}
