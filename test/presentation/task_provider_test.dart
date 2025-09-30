import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:focora/domain/entities/task_entity.dart';

// Criar mock manual para o TaskRepository já que não podemos injetar dependência
class MockTaskRepository {
  List<TaskEntity> tasks = [];
  
  List<TaskEntity> getAllTasks() {
    return tasks;
  }
  
  List<TaskEntity> getTasksByStatus(TaskStatus status) {
    return tasks.where((task) => task.status == status).toList();
  }
  
  Future<void> addTask(TaskEntity task) async {
    tasks.add(task);
  }
  
  Future<void> updateTask(TaskEntity task) async {
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
    }
  }
  
  Future<void> deleteTask(String id) async {
    tasks.removeWhere((task) => task.id == id);
  }
}

void main() {
  group('TaskProvider', () {
    late TaskProvider provider;
    late MockTaskRepository mockRepository;

    setUp(() {
      mockRepository = MockTaskRepository();
      provider = TaskProvider();
      // Substituir o repositório interno do provider pelo mock
      // Como isso não é possível diretamente, vamos testar a lógica do provider
    });

    test('should add task and notify listeners', () {
      // Arrange
      var listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });
      
      final task = TaskEntity(
        title: 'Test Task',
        priority: TaskPriority.medium,
      );
      
      // Act
      provider.addTask(task);
      
      // Assert
      expect(listenerCalled, true);
      // Não podemos verificar se a tarefa foi adicionada ao repositório
      // devido à falta de injeção de dependência
    });
    
    test('should update task and notify listeners', () {
      // Arrange
      var listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });
      
      final task = TaskEntity(
        id: '1',
        title: 'Test Task',
        priority: TaskPriority.medium,
      );
      
      // Act
      provider.updateTask(task);
      
      // Assert
      expect(listenerCalled, true);
    });
    
    test('should delete task and notify listeners', () {
      // Arrange
      var listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });
      
      // Act
      provider.deleteTask('1');
      
      // Assert
      expect(listenerCalled, true);
    });
    
    test('should mark task as completed and notify listeners', () {
      // Arrange
      var listenerCalled = false;
      provider.addListener(() {
        listenerCalled = true;
      });
      
      // Act
      provider.markTaskAsCompleted('1');
      
      // Assert
      expect(listenerCalled, true);
    });
  });
}
