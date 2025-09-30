import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:focora/data/repositories/task_repository.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:focora/domain/entities/task_entity.dart';

// Gerar arquivo de mock
@GenerateMocks([TaskRepository])
import 'task_provider_test_di.mocks.dart';

void main() {
  group('TaskProvider', () {
    late TaskProvider provider;
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
      provider = TaskProvider(repository: mockRepository);
    });

    test('should load tasks from repository', () async {
      // Arrange
      final tasks = [
        TaskEntity(
          id: '1',
          title: 'Task 1',
          status: TaskStatus.inbox,
          priority: TaskPriority.medium,
        ),
        TaskEntity(
          id: '2',
          title: 'Task 2',
          status: TaskStatus.completed,
          priority: TaskPriority.medium,
        ),
      ];
      
      when(mockRepository.getAllTasks()).thenReturn(tasks);

      // Act
      await provider.loadTasks();

      // Assert
      expect(provider.tasks.length, 2);
      expect(provider.tasks[0].id, '1');
      expect(provider.tasks[0].title, 'Task 1');
      expect(provider.tasks[1].id, '2');
      expect(provider.tasks[1].title, 'Task 2');
      verify(mockRepository.getAllTasks()).called(1);
    });

    test('should add task and notify listeners', () async {
      // Arrange
      var listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });
      
      final task = TaskEntity(
        id: '1',
        title: 'Test Task',
        status: TaskStatus.inbox,
        priority: TaskPriority.medium,
      );
      
      when(mockRepository.addTask(any)).thenAnswer((_) => Future.value());
      when(mockRepository.getAllTasks()).thenReturn([task]);

      // Act
      await provider.addTask(task);

      // Assert
      expect(listenerCalled, true);
      verify(mockRepository.addTask(task)).called(1);
      verify(mockRepository.getAllTasks()).called(1);
    });
    
    test('should update task and notify listeners', () async {
      // Arrange
      var listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });
      
      final task = TaskEntity(
        id: '1',
        title: 'Updated Task',
        status: TaskStatus.inProgress,
        priority: TaskPriority.medium,
      );
      
      when(mockRepository.updateTask(any)).thenAnswer((_) => Future.value());
      when(mockRepository.getAllTasks()).thenReturn([task]);

      // Act
      await provider.updateTask(task);

      // Assert
      expect(listenerCalled, true);
      verify(mockRepository.updateTask(task)).called(1);
      verify(mockRepository.getAllTasks()).called(1);
    });
    
    test('should delete task and notify listeners', () async {
      // Arrange
      var listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });
      
      when(mockRepository.deleteTask(any)).thenAnswer((_) => Future.value());
      when(mockRepository.getAllTasks()).thenReturn([]);

      // Act
      await provider.deleteTask('1');

      // Assert
      expect(listenerCalled, true);
      verify(mockRepository.deleteTask('1')).called(1);
      verify(mockRepository.getAllTasks()).called(1);
    });
    
    test('should mark task as completed and notify listeners', () async {
      // Arrange
      var listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });
      
      when(mockRepository.markTaskAsCompleted(any)).thenAnswer((_) => Future.value());
      when(mockRepository.getAllTasks()).thenReturn([]);

      // Act
      await provider.markTaskAsCompleted('1');

      // Assert
      expect(listenerCalled, true);
      verify(mockRepository.markTaskAsCompleted('1')).called(1);
      verify(mockRepository.getAllTasks()).called(1);
    });
    
    test('should filter tasks by status', () async {
      // Arrange
      final tasks = [
        TaskEntity(
          id: '1',
          title: 'Task 1',
          status: TaskStatus.inbox,
          priority: TaskPriority.medium,
        ),
        TaskEntity(
          id: '2',
          title: 'Task 2',
          status: TaskStatus.completed,
          priority: TaskPriority.medium,
        ),
        TaskEntity(
          id: '3',
          title: 'Task 3',
          status: TaskStatus.inbox,
          priority: TaskPriority.medium,
        ),
      ];
      
      when(mockRepository.getAllTasks()).thenReturn(tasks);
      
      // Act
      await provider.loadTasks();
      
      // Assert
      expect(provider.inboxTasks.length, 2);
      expect(provider.inboxTasks[0].id, '1');
      expect(provider.inboxTasks[1].id, '3');
      
      expect(provider.completedTasks.length, 1);
      expect(provider.completedTasks[0].id, '2');
    });
  });
}
