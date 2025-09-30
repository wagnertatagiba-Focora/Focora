import 'package:flutter_test/flutter_test.dart';
import 'package:focora/domain/entities/task_entity.dart';

void main() {
  group('TaskEntity', () {
    test('should create a task with correct properties', () {
      final task = TaskEntity(
        id: '1',
        title: 'Test Task',
        description: 'Test Description',
        priority: TaskPriority.high,
        status: TaskStatus.inbox,
        createdAt: DateTime.now(),
      );

      expect(task.id, '1');
      expect(task.title, 'Test Task');
      expect(task.description, 'Test Description');
      expect(task.priority, TaskPriority.high);
      expect(task.status, TaskStatus.inbox);
    });

    test('should update task status correctly', () {
      final task = TaskEntity(
        id: '1',
        title: 'Test Task',
        status: TaskStatus.inbox,
      );

      final updatedTask = task.copyWith(status: TaskStatus.completed);
      
      expect(updatedTask.status, TaskStatus.completed);
      expect(updatedTask.id, task.id);
      expect(updatedTask.title, task.title);
    });
    
    test('should mark task as completed with current date', () {
      final now = DateTime.now();
      final task = TaskEntity(
        id: '1',
        title: 'Test Task',
        status: TaskStatus.inbox,
      );
      
      final completedTask = task.markAsCompleted();
      
      expect(completedTask.status, TaskStatus.completed);
      expect(completedTask.completedAt, isNotNull);
      
      // Verificar se a data de conclusão está próxima da data atual
      final difference = completedTask.completedAt!.difference(now).inSeconds.abs();
      expect(difference, lessThan(2)); // Tolerância de 2 segundos
    });
    
    test('should add and remove contexts', () {
      final task = TaskEntity(
        title: 'Test Task',
        contexts: ['casa'],
      );
      
      final updatedTask = task.addContext('trabalho');
      expect(updatedTask.contexts, contains('casa'));
      expect(updatedTask.contexts, contains('trabalho'));
      expect(updatedTask.contexts.length, 2);
      
      final finalTask = updatedTask.removeContext('casa');
      expect(finalTask.contexts, isNot(contains('casa')));
      expect(finalTask.contexts, contains('trabalho'));
      expect(finalTask.contexts.length, 1);
    });
    
    test('should identify overdue tasks', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      
      final overdueTask = TaskEntity(
        title: 'Overdue Task',
        dueDate: yesterday,
      );
      
      final upcomingTask = TaskEntity(
        title: 'Upcoming Task',
        dueDate: tomorrow,
      );
      
      final completedOverdueTask = TaskEntity(
        title: 'Completed Overdue Task',
        dueDate: yesterday,
        status: TaskStatus.completed,
      );
      
      expect(overdueTask.isOverdue, isTrue);
      expect(upcomingTask.isOverdue, isFalse);
      expect(completedOverdueTask.isOverdue, isFalse);
    });
  });
}
