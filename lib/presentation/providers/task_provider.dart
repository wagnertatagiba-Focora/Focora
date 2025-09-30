import 'package:flutter/foundation.dart';
import 'package:focora/domain/entities/task_entity.dart';
import 'package:focora/data/repositories/task_repository.dart';
import 'package:focora/core/services/service_locator.dart';

/// Provider para gerenciar o estado das tarefas
class TaskProvider with ChangeNotifier {
  /// Repositório de tarefas
  final TaskRepository _repository;
  
  /// Lista de tarefas
  List<TaskEntity> _tasks = [];
  
  /// Construtor
  TaskProvider({TaskRepository? repository}) 
      : _repository = repository ?? serviceLocator<TaskRepository>();
  
  /// Retorna a lista de tarefas
  List<TaskEntity> get tasks => _tasks;
  
  /// Retorna as tarefas na caixa de entrada
  List<TaskEntity> get inboxTasks => _tasks.where((task) => task.status == TaskStatus.inbox).toList();
  
  /// Retorna as tarefas em andamento
  List<TaskEntity> get inProgressTasks => _tasks.where((task) => task.status == TaskStatus.inProgress).toList();
  
  /// Retorna as tarefas concluídas
  List<TaskEntity> get completedTasks => _tasks.where((task) => task.status == TaskStatus.completed).toList();
  
  /// Retorna as tarefas atrasadas
  List<TaskEntity> get overdueTasks => _tasks.where((task) => task.isOverdue).toList();
  
  /// Retorna as tarefas para hoje
  List<TaskEntity> get todayTasks => _tasks.where((task) => 
    task.isDueToday && task.status != TaskStatus.completed).toList();
  
  /// Retorna as tarefas de alta energia
  List<TaskEntity> get highEnergyTasks => _tasks.where((task) => 
    task.energyLevel >= 4 && task.status != TaskStatus.completed).toList();
  
  /// Retorna as tarefas de baixa energia
  List<TaskEntity> get lowEnergyTasks => _tasks.where((task) => 
    task.energyLevel <= 2 && task.status != TaskStatus.completed).toList();
  
  /// Retorna as tarefas por projeto
  List<TaskEntity> getTasksByProject(String projectId) {
    return _tasks.where((task) => task.projectId == projectId).toList();
  }
  
  /// Retorna as tarefas por contexto
  List<TaskEntity> getTasksByContext(String context) {
    return _tasks.where((task) => task.contexts.contains(context)).toList();
  }
  
  /// Retorna as tarefas por tag
  List<TaskEntity> getTasksByTag(String tag) {
    return _tasks.where((task) => task.tags.contains(tag)).toList();
  }
  
  /// Retorna uma tarefa pelo ID
  TaskEntity? getTaskById(String id) {
    try {
      return _tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Carrega as tarefas do repositório
  Future<void> loadTasks() async {
    _tasks = _repository.getAllTasks();
    notifyListeners();
  }
  
  /// Adiciona uma tarefa
  Future<void> addTask(TaskEntity task) async {
    await _repository.addTask(task);
    await loadTasks();
  }
  
  /// Atualiza uma tarefa
  Future<void> updateTask(TaskEntity updatedTask) async {
    await _repository.updateTask(updatedTask);
    await loadTasks();
  }
  
  /// Remove uma tarefa
  Future<void> deleteTask(String id) async {
    await _repository.deleteTask(id);
    await loadTasks();
  }
  
  /// Marca uma tarefa como concluída
  Future<void> markTaskAsCompleted(String id) async {
    await _repository.markTaskAsCompleted(id);
    await loadTasks();
  }
  
  /// Marca uma tarefa como em andamento
  Future<void> markTaskAsInProgress(String id) async {
    await _repository.markTaskAsInProgress(id);
    await loadTasks();
  }
  
  /// Adiciona tarefas de exemplo para desenvolvimento
  Future<void> addSampleTasks() async {
    await _repository.addSampleTasks();
    await loadTasks();
  }
}
