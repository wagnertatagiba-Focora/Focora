import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:focora/domain/entities/project_entity.dart';

part 'project_model.g.dart';

/// Modelo de projeto para armazenamento com Hive
@HiveType(typeId: 2)
class ProjectModel extends HiveObject {
  /// Identificador único do projeto
  @HiveField(0)
  final String id;
  
  /// Nome do projeto
  @HiveField(1)
  String name;
  
  /// Descrição do projeto
  @HiveField(2)
  String? description;
  
  /// Cor do projeto
  @HiveField(3)
  int color;
  
  /// Data de criação do projeto
  @HiveField(4)
  final DateTime createdAt;
  
  /// Data de atualização do projeto
  @HiveField(5)
  DateTime updatedAt;
  
  /// Data de vencimento do projeto
  @HiveField(6)
  DateTime? dueDate;
  
  /// Data de conclusão do projeto
  @HiveField(7)
  DateTime? completedAt;
  
  /// Status do projeto
  @HiveField(8)
  int status;
  
  /// Notas adicionais sobre o projeto
  @HiveField(9)
  String? notes;
  
  /// Lista de IDs das tarefas associadas ao projeto
  @HiveField(10)
  List<String> taskIds;
  
  /// Construtor
  ProjectModel({
    String? id,
    required this.name,
    this.description,
    required this.color,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.dueDate,
    this.completedAt,
    required this.status,
    this.notes,
    List<String>? taskIds,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now(),
        taskIds = taskIds ?? [];
  
  /// Converte o modelo para a entidade
  ProjectEntity toEntity() {
    return ProjectEntity(
      id: id,
      name: name,
      description: description,
      color: color,
      createdAt: createdAt,
      updatedAt: updatedAt,
      dueDate: dueDate,
      completedAt: completedAt,
      status: ProjectStatus.values[status],
      notes: notes,
      taskIds: taskIds,
    );
  }
  
  /// Cria um modelo a partir da entidade
  factory ProjectModel.fromEntity(ProjectEntity entity) {
    return ProjectModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      color: entity.color,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      dueDate: entity.dueDate,
      completedAt: entity.completedAt,
      status: entity.status.index,
      notes: entity.notes,
      taskIds: entity.taskIds,
    );
  }
}
