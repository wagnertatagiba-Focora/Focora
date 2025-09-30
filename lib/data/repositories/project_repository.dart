import 'package:hive/hive.dart';
import 'package:focora/data/models/project_model.dart';
import 'package:focora/domain/entities/project_entity.dart';

/// Repositório para gerenciar projetos
class ProjectRepository {
  /// Caixa do Hive para armazenar projetos
  final Box<ProjectModel> _projectBox;
  
  /// Construtor
  ProjectRepository(this._projectBox);
  
  /// Obtém todos os projetos
  List<ProjectEntity> getAllProjects() {
    return _projectBox.values.map((model) => model.toEntity()).toList();
  }
  
  /// Obtém um projeto pelo ID
  ProjectEntity? getProjectById(String id) {
    try {
      final model = _projectBox.values.firstWhere(
        (project) => project.id == id,
      );
      return model.toEntity();
    } catch (e) {
      return null;
    }
  }
  
  /// Obtém projetos por status
  List<ProjectEntity> getProjectsByStatus(ProjectStatus status) {
    return _projectBox.values
        .where((project) => project.status == status.index)
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Obtém projetos ativos
  List<ProjectEntity> getActiveProjects() {
    return getProjectsByStatus(ProjectStatus.active);
  }
  
  /// Obtém projetos concluídos
  List<ProjectEntity> getCompletedProjects() {
    return getProjectsByStatus(ProjectStatus.completed);
  }
  
  /// Obtém projetos com tarefas específicas
  List<ProjectEntity> getProjectsWithTask(String taskId) {
    return _projectBox.values
        .where((project) => project.taskIds.contains(taskId))
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Adiciona um projeto
  Future<void> addProject(ProjectEntity project) async {
    final model = ProjectModel.fromEntity(project);
    await _projectBox.add(model);
  }
  
  /// Atualiza um projeto
  Future<void> updateProject(ProjectEntity project) async {
    final index = _projectBox.values.toList().indexWhere((p) => p.id == project.id);
    if (index != -1) {
      final model = ProjectModel.fromEntity(project);
      await _projectBox.putAt(index, model);
    }
  }
  
  /// Remove um projeto
  Future<void> deleteProject(String id) async {
    final index = _projectBox.values.toList().indexWhere((p) => p.id == id);
    if (index != -1) {
      await _projectBox.deleteAt(index);
    }
  }
  
  /// Adiciona uma tarefa a um projeto
  Future<void> addTaskToProject(String projectId, String taskId) async {
    final project = getProjectById(projectId);
    if (project != null) {
      final updatedProject = project.addTask(taskId);
      await updateProject(updatedProject);
    }
  }
  
  /// Remove uma tarefa de um projeto
  Future<void> removeTaskFromProject(String projectId, String taskId) async {
    final project = getProjectById(projectId);
    if (project != null) {
      final updatedProject = project.removeTask(taskId);
      await updateProject(updatedProject);
    }
  }
  
  /// Adiciona projetos de exemplo
  Future<void> addSampleProjects() async {
    if (_projectBox.isEmpty) {
      final now = DateTime.now();
      
      // Projeto 1
      await addProject(ProjectEntity(
        id: 'projeto1',
        name: 'Redesign do Website',
        description: 'Atualizar o design e a estrutura do website da empresa',
        color: 0xFF2196F3, // Azul
        status: ProjectStatus.active,
        dueDate: DateTime(now.year, now.month, now.day + 14),
      ));
      
      // Projeto 2
      await addProject(ProjectEntity(
        name: 'Lançamento do Produto X',
        description: 'Preparar o lançamento do novo produto',
        color: 0xFF4CAF50, // Verde
        status: ProjectStatus.active,
        dueDate: DateTime(now.year, now.month, now.day + 30),
      ));
      
      // Projeto 3
      await addProject(ProjectEntity(
        name: 'Organização Pessoal',
        description: 'Melhorar a organização e produtividade pessoal',
        color: 0xFFFFC107, // Amarelo
        status: ProjectStatus.active,
      ));
    }
  }
}
