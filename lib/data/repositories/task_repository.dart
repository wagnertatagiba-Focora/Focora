import 'package:hive/hive.dart';
import 'package:focora/data/models/task_model.dart';
import 'package:focora/domain/entities/task_entity.dart';

/// Repositório para gerenciar tarefas
class TaskRepository {
  /// Caixa do Hive para armazenar tarefas
  final Box<TaskModel> _taskBox;
  
  /// Construtor
  TaskRepository(this._taskBox);
  
  /// Obtém todas as tarefas
  List<TaskEntity> getAllTasks() {
    return _taskBox.values.map((model) => model.toEntity()).toList();
  }
  
  /// Obtém uma tarefa pelo ID
  TaskEntity? getTaskById(String id) {
    final model = _taskBox.get(id);
    return model?.toEntity();
  }
  
  /// Obtém tarefas por status
  List<TaskEntity> getTasksByStatus(TaskStatus status) {
    return _taskBox.values
        .where((task) => task.status == status.index)
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Obtém tarefas por projeto
  List<TaskEntity> getTasksByProject(String projectId) {
    return _taskBox.values
        .where((task) => task.projectId == projectId)
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Obtém tarefas para hoje
  List<TaskEntity> getTodayTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return _taskBox.values
        .where((task) => 
          task.dueDate != null && 
          task.dueDate!.isAfter(today.subtract(const Duration(seconds: 1))) && 
          task.dueDate!.isBefore(tomorrow) &&
          task.status != TaskStatus.completed.index &&
          task.status != TaskStatus.archived.index &&
          task.status != TaskStatus.cancelled.index
        )
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Obtém tarefas atrasadas
  List<TaskEntity> getOverdueTasks() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    
    return _taskBox.values
        .where((task) => 
          task.dueDate != null && 
          task.dueDate!.isBefore(today) &&
          task.status != TaskStatus.completed.index &&
          task.status != TaskStatus.archived.index &&
          task.status != TaskStatus.cancelled.index
        )
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Adiciona uma tarefa
  Future<void> addTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await _taskBox.put(task.id, model);
  }
  
  /// Atualiza uma tarefa
  Future<void> updateTask(TaskEntity task) async {
    final model = TaskModel.fromEntity(task);
    await _taskBox.put(task.id, model);
  }
  
  /// Remove uma tarefa
  Future<void> deleteTask(String id) async {
    await _taskBox.delete(id);
  }
  
  /// Marca uma tarefa como concluída
  Future<void> markTaskAsCompleted(String id) async {
    final task = getTaskById(id);
    if (task != null) {
      final updatedTask = task.markAsCompleted();
      await updateTask(updatedTask);
    }
  }
  
  /// Marca uma tarefa como em andamento
  Future<void> markTaskAsInProgress(String id) async {
    final task = getTaskById(id);
    if (task != null) {
      final updatedTask = task.markAsInProgress();
      await updateTask(updatedTask);
    }
  }
  
  /// Adiciona tarefas de exemplo
  Future<void> addSampleTasks() async {
    if (_taskBox.isEmpty) {
      final now = DateTime.now();
      
      // Tarefas na caixa de entrada
      await addTask(TaskEntity(
        title: 'Revisar plano de estudos',
        description: 'Atualizar o plano de estudos para o próximo mês',
        status: TaskStatus.inbox,
        priority: TaskPriority.medium,
      ));
      
      await addTask(TaskEntity(
        title: 'Pesquisar sobre técnicas de foco',
        status: TaskStatus.inbox,
        priority: TaskPriority.low,
      ));
      
      // Tarefas para hoje
      await addTask(TaskEntity(
        title: 'Preparar apresentação',
        description: 'Preparar slides para a reunião de amanhã',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        dueDate: DateTime(now.year, now.month, now.day, 18, 0),
        estimatedTime: 120,
      ));
      
      await addTask(TaskEntity(
        title: 'Responder e-mails',
        status: TaskStatus.inProgress,
        priority: TaskPriority.medium,
        dueDate: DateTime(now.year, now.month, now.day, 12, 0),
        estimatedTime: 30,
      ));
      
      // Tarefas concluídas
      await addTask(TaskEntity(
        title: 'Agendar reunião',
        status: TaskStatus.completed,
        priority: TaskPriority.medium,
        completedAt: DateTime.now().subtract(const Duration(hours: 2)),
      ));
      
      // Tarefas com projeto
      await addTask(TaskEntity(
        title: 'Definir requisitos',
        description: 'Listar todos os requisitos do projeto',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        projectId: 'projeto1',
        dueDate: DateTime(now.year, now.month, now.day + 2),
      ));
      
      await addTask(TaskEntity(
        title: 'Criar protótipo',
        status: TaskStatus.inProgress,
        priority: TaskPriority.high,
        projectId: 'projeto1',
        dueDate: DateTime(now.year, now.month, now.day + 5),
      ));
    }
  }
}
