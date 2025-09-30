import 'package:flutter/foundation.dart';
import 'package:focora/domain/entities/project_entity.dart';
import 'package:focora/data/repositories/project_repository.dart';

/// Provider para gerenciar o estado dos projetos
class ProjectProvider with ChangeNotifier {
  /// Repositório de projetos
  final ProjectRepository _repository;
  
  /// Lista de projetos
  List<ProjectEntity> _projects = [];
  
  /// Construtor
  ProjectProvider(this._repository) {
    loadProjects();
  }
  
  /// Retorna a lista de projetos
  List<ProjectEntity> get projects => _projects;
  
  /// Retorna os projetos ativos
  List<ProjectEntity> get activeProjects => _projects.where((project) => project.status == ProjectStatus.active).toList();
  
  /// Retorna os projetos em espera
  List<ProjectEntity> get onHoldProjects => _projects.where((project) => project.status == ProjectStatus.onHold).toList();
  
  /// Retorna os projetos concluídos
  List<ProjectEntity> get completedProjects => _projects.where((project) => project.status == ProjectStatus.completed).toList();
  
  /// Retorna os projetos atrasados
  List<ProjectEntity> get overdueProjects => _projects.where((project) => project.isOverdue).toList();
  
  /// Retorna os projetos para hoje
  List<ProjectEntity> get todayProjects => _projects.where((project) => 
    project.isDueToday && project.status != ProjectStatus.completed).toList();
  
  /// Retorna um projeto pelo ID
  ProjectEntity? getProjectById(String id) {
    try {
      return _projects.firstWhere((project) => project.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Carrega os projetos do repositório
  Future<void> loadProjects() async {
    _projects = _repository.getAllProjects();
    notifyListeners();
  }
  
  /// Adiciona um projeto
  Future<void> addProject(ProjectEntity project) async {
    await _repository.addProject(project);
    await loadProjects();
  }
  
  /// Atualiza um projeto
  Future<void> updateProject(ProjectEntity updatedProject) async {
    await _repository.updateProject(updatedProject);
    await loadProjects();
  }
  
  /// Remove um projeto
  Future<void> deleteProject(String id) async {
    await _repository.deleteProject(id);
    await loadProjects();
  }
  
  /// Marca um projeto como concluído
  Future<void> markProjectAsCompleted(String id) async {
    await _repository.markProjectAsCompleted(id);
    await loadProjects();
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
}
