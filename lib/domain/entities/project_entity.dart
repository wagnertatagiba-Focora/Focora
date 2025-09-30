import 'package:uuid/uuid.dart';

/// Enum que representa o status de um projeto
enum ProjectStatus {
  /// Projeto ativo
  active,
  
  /// Projeto em espera
  onHold,
  
  /// Projeto concluído
  completed,
  
  /// Projeto arquivado
  archived,
  
  /// Projeto cancelado
  cancelled,
}

/// Extensão para obter o nome em português do status
extension ProjectStatusExtension on ProjectStatus {
  String get name {
    switch (this) {
      case ProjectStatus.active:
        return 'Ativo';
      case ProjectStatus.onHold:
        return 'Em espera';
      case ProjectStatus.completed:
        return 'Concluído';
      case ProjectStatus.archived:
        return 'Arquivado';
      case ProjectStatus.cancelled:
        return 'Cancelado';
    }
  }
  
  /// Retorna a cor correspondente ao status
  int get colorValue {
    switch (this) {
      case ProjectStatus.active:
        return 0xFF4CAF50; // Verde
      case ProjectStatus.onHold:
        return 0xFFFFC107; // Amarelo
      case ProjectStatus.completed:
        return 0xFF2196F3; // Azul
      case ProjectStatus.archived:
        return 0xFF9E9E9E; // Cinza
      case ProjectStatus.cancelled:
        return 0xFFF44336; // Vermelho
    }
  }
}

/// Entidade que representa um projeto
class ProjectEntity {
  /// Identificador único do projeto
  final String id;
  
  /// Nome do projeto
  String name;
  
  /// Descrição do projeto
  String? description;
  
  /// Status do projeto
  ProjectStatus status;
  
  /// Data de criação do projeto
  final DateTime createdAt;
  
  /// Data de atualização do projeto
  DateTime updatedAt;
  
  /// Data de vencimento do projeto
  DateTime? dueDate;
  
  /// Data de conclusão do projeto
  DateTime? completedAt;
  
  /// Cor do projeto
  int color;
  
  /// Ícone do projeto
  String? icon;
  
  /// Notas adicionais sobre o projeto
  String? notes;
  
  /// Lista de IDs das tarefas associadas ao projeto
  List<String> taskIds;
  
  /// Construtor
  ProjectEntity({
    String? id,
    required this.name,
    this.description,
    this.status = ProjectStatus.active,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.dueDate,
    this.completedAt,
    this.color = 0xFF2196F3, // Azul por padrão
    this.icon,
    this.notes,
    List<String>? taskIds,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        taskIds = taskIds ?? [];
  
  /// Cria uma cópia do projeto com os campos atualizados
  ProjectEntity copyWith({
    String? name,
    String? description,
    ProjectStatus? status,
    DateTime? updatedAt,
    DateTime? dueDate,
    DateTime? completedAt,
    int? color,
    String? icon,
    String? notes,
    List<String>? taskIds,
  }) {
    return ProjectEntity(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      color: color ?? this.color,
      icon: icon ?? this.icon,
      notes: notes ?? this.notes,
      taskIds: taskIds ?? List.from(this.taskIds),
    );
  }
  
  /// Marca o projeto como concluído
  ProjectEntity markAsCompleted() {
    return copyWith(
      status: ProjectStatus.completed,
      completedAt: DateTime.now(),
    );
  }
  
  /// Adiciona uma tarefa ao projeto
  ProjectEntity addTask(String taskId) {
    final newTaskIds = List<String>.from(taskIds);
    if (!newTaskIds.contains(taskId)) {
      newTaskIds.add(taskId);
    }
    return copyWith(taskIds: newTaskIds);
  }
  
  /// Remove uma tarefa do projeto
  ProjectEntity removeTask(String taskId) {
    final newTaskIds = List<String>.from(taskIds);
    newTaskIds.remove(taskId);
    return copyWith(taskIds: newTaskIds);
  }
  
  /// Verifica se o projeto está atrasado
  bool get isOverdue {
    if (dueDate == null) return false;
    return dueDate!.isBefore(DateTime.now()) && status != ProjectStatus.completed;
  }
  
  /// Verifica se o projeto vence hoje
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year && 
           dueDate!.month == now.month && 
           dueDate!.day == now.day;
  }
  
  /// Retorna o progresso do projeto (0.0 a 1.0)
  double get progress {
    if (taskIds.isEmpty) return 0.0;
    // Nota: Esta é uma implementação simplificada.
    // Na implementação real, precisaríamos contar as tarefas concluídas.
    return 0.0;
  }
}
