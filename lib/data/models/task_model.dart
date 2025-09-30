import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:focora/domain/entities/task_entity.dart';

part 'task_model.g.dart';

/// Modelo de tarefa para armazenamento com Hive
@HiveType(typeId: 1)
class TaskModel extends HiveObject {
  /// Identificador único da tarefa
  @HiveField(0)
  final String id;
  
  /// Título da tarefa
  @HiveField(1)
  String title;
  
  /// Descrição da tarefa
  @HiveField(2)
  String? description;
  
  /// Status da tarefa
  @HiveField(3)
  int status;
  
  /// Prioridade da tarefa
  @HiveField(4)
  int priority;
  
  /// Data de criação da tarefa
  @HiveField(5)
  DateTime createdAt;
  
  /// Data de atualização da tarefa
  @HiveField(6)
  DateTime updatedAt;
  
  /// Data de vencimento da tarefa
  @HiveField(7)
  DateTime? dueDate;
  
  /// Data de conclusão da tarefa
  @HiveField(8)
  DateTime? completedAt;
  
  /// Tempo estimado para concluir a tarefa (em minutos)
  @HiveField(9)
  int? estimatedTime;
  
  /// Tempo real gasto na tarefa (em minutos)
  @HiveField(10)
  int? actualTime;
  
  /// Projeto ao qual a tarefa pertence
  @HiveField(11)
  String? projectId;
  
  /// Contexto da tarefa (ex: @casa, @trabalho)
  @HiveField(12)
  List<String> contexts;
  
  /// Tags da tarefa
  @HiveField(13)
  List<String> tags;
  
  /// Notas adicionais sobre a tarefa
  @HiveField(14)
  String? notes;
  
  /// Indica se a tarefa é recorrente
  @HiveField(15)
  bool isRecurring;
  
  /// Padrão de recorrência (ex: "daily", "weekly", "monthly")
  @HiveField(16)
  String? recurrencePattern;
  
  /// Energia necessária para realizar a tarefa (1-5)
  @HiveField(17)
  int energyLevel;
  
  /// Construtor
  TaskModel({
    String? id,
    required this.title,
    this.description,
    required this.status,
    required this.priority,
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
  
  /// Converte o modelo para a entidade
  TaskEntity toEntity() {
    return TaskEntity(
      id: id,
      title: title,
      description: description,
      status: TaskStatus.values[status],
      priority: TaskPriority.values[priority],
      createdAt: createdAt,
      updatedAt: updatedAt,
      dueDate: dueDate,
      completedAt: completedAt,
      estimatedTime: estimatedTime,
      actualTime: actualTime,
      projectId: projectId,
      contexts: contexts,
      tags: tags,
      notes: notes,
      isRecurring: isRecurring,
      recurrencePattern: recurrencePattern,
      energyLevel: energyLevel,
    );
  }
  
  /// Cria um modelo a partir da entidade
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      status: entity.status.index,
      priority: entity.priority.index,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      dueDate: entity.dueDate,
      completedAt: entity.completedAt,
      estimatedTime: entity.estimatedTime,
      actualTime: entity.actualTime,
      projectId: entity.projectId,
      contexts: entity.contexts,
      tags: entity.tags,
      notes: entity.notes,
      isRecurring: entity.isRecurring,
      recurrencePattern: entity.recurrencePattern,
      energyLevel: entity.energyLevel,
    );
  }
}
