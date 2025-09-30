import 'package:uuid/uuid.dart';

/// Enum que representa o status de uma tarefa
enum TaskStatus {
  /// Tarefa na caixa de entrada, ainda não processada
  inbox,
  
  /// Tarefa em andamento
  inProgress,
  
  /// Tarefa concluída
  completed,
  
  /// Tarefa delegada a outra pessoa
  delegated,
  
  /// Tarefa adiada para depois
  deferred,
  
  /// Tarefa arquivada
  archived,
  
  /// Tarefa cancelada
  cancelled,
}

/// Enum que representa a prioridade de uma tarefa
enum TaskPriority {
  /// Prioridade baixa
  low,
  
  /// Prioridade média
  medium,
  
  /// Prioridade alta
  high,
  
  /// Prioridade urgente
  urgent,
}

/// Extensão para obter o nome em português da prioridade
extension TaskPriorityExtension on TaskPriority {
  String get name {
    switch (this) {
      case TaskPriority.low:
        return 'Baixa';
      case TaskPriority.medium:
        return 'Média';
      case TaskPriority.high:
        return 'Alta';
      case TaskPriority.urgent:
        return 'Urgente';
    }
  }
  
  /// Retorna a cor correspondente à prioridade
  int get colorValue {
    switch (this) {
      case TaskPriority.low:
        return 0xFF8BC34A; // Verde claro
      case TaskPriority.medium:
        return 0xFFFFC107; // Amarelo
      case TaskPriority.high:
        return 0xFFFF9800; // Laranja
      case TaskPriority.urgent:
        return 0xFFF44336; // Vermelho
    }
  }
}

/// Entidade que representa uma tarefa
class TaskEntity {
  /// Identificador único da tarefa
  final String id;
  
  /// Título da tarefa
  String title;
  
  /// Descrição da tarefa
  String? description;
  
  /// Status da tarefa
  TaskStatus status;
  
  /// Prioridade da tarefa
  TaskPriority priority;
  
  /// Data de criação da tarefa
  final DateTime createdAt;
  
  /// Data de atualização da tarefa
  DateTime updatedAt;
  
  /// Data de vencimento da tarefa
  DateTime? dueDate;
  
  /// Data de conclusão da tarefa
  DateTime? completedAt;
  
  /// Tempo estimado para concluir a tarefa (em minutos)
  int? estimatedTime;
  
  /// Tempo real gasto na tarefa (em minutos)
  int? actualTime;
  
  /// Projeto ao qual a tarefa pertence
  String? projectId;
  
  /// Contexto da tarefa (ex: @casa, @trabalho)
  List<String> contexts;
  
  /// Tags da tarefa
  List<String> tags;
  
  /// Notas adicionais sobre a tarefa
  String? notes;
  
  /// Indica se a tarefa é recorrente
  bool isRecurring;
  
  /// Padrão de recorrência (ex: "daily", "weekly", "monthly")
  String? recurrencePattern;
  
  /// Energia necessária para realizar a tarefa (1-5)
  int energyLevel;
  
  /// Construtor
  TaskEntity({
    String? id,
    required this.title,
    this.description,
    this.status = TaskStatus.inbox,
    this.priority = TaskPriority.medium,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.dueDate,
    this.completedAt,
    this.estimatedTime,
    this.actualTime,
    this.projectId,
    List<String>? contexts,
    List<String>? tags,
    this.notes,
    this.isRecurring = false,
    this.recurrencePattern,
    this.energyLevel = 3,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        contexts = contexts ?? [],
        tags = tags ?? [];
  
  /// Cria uma cópia da tarefa com os campos atualizados
  TaskEntity copyWith({
    String? title,
    String? description,
    TaskStatus? status,
    TaskPriority? priority,
    DateTime? updatedAt,
    DateTime? dueDate,
    DateTime? completedAt,
    int? estimatedTime,
    int? actualTime,
    String? projectId,
    List<String>? contexts,
    List<String>? tags,
    String? notes,
    bool? isRecurring,
    String? recurrencePattern,
    int? energyLevel,
  }) {
    return TaskEntity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      actualTime: actualTime ?? this.actualTime,
      projectId: projectId ?? this.projectId,
      contexts: contexts ?? List.from(this.contexts),
      tags: tags ?? List.from(this.tags),
      notes: notes ?? this.notes,
      isRecurring: isRecurring ?? this.isRecurring,
      recurrencePattern: recurrencePattern ?? this.recurrencePattern,
      energyLevel: energyLevel ?? this.energyLevel,
    );
  }
  
  /// Marca a tarefa como concluída
  TaskEntity markAsCompleted() {
    return copyWith(
      status: TaskStatus.completed,
      completedAt: DateTime.now(),
    );
  }
  
  /// Marca a tarefa como em andamento
  TaskEntity markAsInProgress() {
    return copyWith(
      status: TaskStatus.inProgress,
    );
  }
  
  /// Adiciona um contexto à tarefa
  TaskEntity addContext(String context) {
    final newContexts = List<String>.from(contexts);
    if (!newContexts.contains(context)) {
      newContexts.add(context);
    }
    return copyWith(contexts: newContexts);
  }
  
  /// Remove um contexto da tarefa
  TaskEntity removeContext(String context) {
    final newContexts = List<String>.from(contexts);
    newContexts.remove(context);
    return copyWith(contexts: newContexts);
  }
  
  /// Adiciona uma tag à tarefa
  TaskEntity addTag(String tag) {
    final newTags = List<String>.from(tags);
    if (!newTags.contains(tag)) {
      newTags.add(tag);
    }
    return copyWith(tags: newTags);
  }
  
  /// Remove uma tag da tarefa
  TaskEntity removeTag(String tag) {
    final newTags = List<String>.from(tags);
    newTags.remove(tag);
    return copyWith(tags: newTags);
  }
  
  /// Verifica se a tarefa está atrasada
  bool get isOverdue {
    if (dueDate == null) return false;
    return dueDate!.isBefore(DateTime.now()) && status != TaskStatus.completed;
  }
  
  /// Verifica se a tarefa vence hoje
  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year && 
           dueDate!.month == now.month && 
           dueDate!.day == now.day;
  }
  
  /// Retorna a categoria da tarefa na Matriz de Eisenhower
  String get eisenhowerQuadrant {
    if (priority == TaskPriority.urgent || priority == TaskPriority.high) {
      return dueDate != null && dueDate!.difference(DateTime.now()).inDays <= 3
          ? 'Urgente e Importante' // Quadrante 1
          : 'Importante, Não Urgente'; // Quadrante 2
    } else {
      return dueDate != null && dueDate!.difference(DateTime.now()).inDays <= 3
          ? 'Urgente, Não Importante' // Quadrante 3
          : 'Não Urgente, Não Importante'; // Quadrante 4
    }
  }
  
  /// Getter para compatibilidade com código existente
  DateTime? get completedDate => completedAt;
}
