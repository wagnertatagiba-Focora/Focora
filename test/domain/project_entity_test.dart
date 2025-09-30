import 'package:flutter_test/flutter_test.dart';
import 'package:focora/domain/entities/project_entity.dart';

void main() {
  group('ProjectEntity', () {
    test('should create a project with correct properties', () {
      final project = ProjectEntity(
        id: '1',
        name: 'Test Project',
        description: 'Test Description',
        color: 0xFF0000FF,
        createdAt: DateTime(2023, 1, 1),
      );

      expect(project.id, '1');
      expect(project.name, 'Test Project');
      expect(project.description, 'Test Description');
      expect(project.color, 0xFF0000FF);
      expect(project.createdAt, DateTime(2023, 1, 1));
      expect(project.status, ProjectStatus.active);
    });

    test('should update project properties correctly', () {
      final project = ProjectEntity(
        id: '1',
        name: 'Test Project',
        description: 'Test Description',
      );

      final updatedProject = project.copyWith(
        name: 'Updated Project',
        description: 'Updated Description',
        color: 0xFF00FF00,
        status: ProjectStatus.archived,
      );
      
      expect(updatedProject.id, project.id);
      expect(updatedProject.name, 'Updated Project');
      expect(updatedProject.description, 'Updated Description');
      expect(updatedProject.color, 0xFF00FF00);
      expect(updatedProject.status, ProjectStatus.archived);
      expect(updatedProject.createdAt, project.createdAt);
      expect(updatedProject.updatedAt.isAfter(project.updatedAt), isTrue);
    });
    
    test('should add and remove tasks', () {
      final project = ProjectEntity(
        id: '1',
        name: 'Test Project',
      );
      
      expect(project.taskIds, isEmpty);
      
      final updatedProject = project.addTask('task1');
      expect(updatedProject.taskIds, contains('task1'));
      expect(updatedProject.taskIds.length, 1);
      
      final finalProject = updatedProject.addTask('task2');
      expect(finalProject.taskIds, contains('task1'));
      expect(finalProject.taskIds, contains('task2'));
      expect(finalProject.taskIds.length, 2);
      
      final projectWithTaskRemoved = finalProject.removeTask('task1');
      expect(projectWithTaskRemoved.taskIds, isNot(contains('task1')));
      expect(projectWithTaskRemoved.taskIds, contains('task2'));
      expect(projectWithTaskRemoved.taskIds.length, 1);
    });
    
    test('should mark project as completed', () {
      final project = ProjectEntity(
        id: '1',
        name: 'Test Project',
      );
      
      expect(project.status, ProjectStatus.active);
      expect(project.completedAt, isNull);
      
      final completedProject = project.markAsCompleted();
      expect(completedProject.status, ProjectStatus.completed);
      expect(completedProject.completedAt, isNotNull);
    });
    
    test('should identify overdue projects', () {
      final yesterday = DateTime.now().subtract(const Duration(days: 1));
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      
      final overdueProject = ProjectEntity(
        name: 'Overdue Project',
        dueDate: yesterday,
      );
      
      final upcomingProject = ProjectEntity(
        name: 'Upcoming Project',
        dueDate: tomorrow,
      );
      
      final completedOverdueProject = ProjectEntity(
        name: 'Completed Overdue Project',
        dueDate: yesterday,
        status: ProjectStatus.completed,
      );
      
      expect(overdueProject.isOverdue, isTrue);
      expect(upcomingProject.isOverdue, isFalse);
      expect(completedOverdueProject.isOverdue, isFalse);
    });
  });
}
