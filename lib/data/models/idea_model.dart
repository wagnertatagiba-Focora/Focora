import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:focora/domain/entities/idea_entity.dart';

part 'idea_model.g.dart';

/// Modelo de ideia para armazenamento com Hive
@HiveType(typeId: 6)
class IdeaModel extends HiveObject {
  /// Identificador único da ideia
  @HiveField(0)
  final String id;
  
  /// Título da ideia
  @HiveField(1)
  final String title;
  
  /// Descrição da ideia
  @HiveField(2)
  final String description;
  
  /// Data e hora da captura
  @HiveField(3)
  final DateTime captureDate;
  
  /// Categoria da ideia (armazenada como inteiro)
  @HiveField(4)
  final int category;
  
  /// Status da ideia (armazenado como inteiro)
  @HiveField(5)
  final int status;
  
  /// Tags associadas à ideia
  @HiveField(6)
  final List<String> tags;
  
  /// Notas adicionais
  @HiveField(7)
  final String? notes;
  
  /// Próximos passos
  @HiveField(8)
  final String? nextSteps;
  
  /// Recursos necessários
  @HiveField(9)
  final String? resources;
  
  /// Projeto associado à ideia
  @HiveField(10)
  final String? projectId;
  
  /// Tarefa associada à ideia
  @HiveField(11)
  final String? taskId;
  
  /// Construtor
  IdeaModel({
    String? id,
    required this.title,
    required this.description,
    DateTime? captureDate,
    this.category = 8, // IdeaCategory.other
    this.status = 0, // IdeaStatus.captured
    List<String>? tags,
    this.notes,
    this.nextSteps,
    this.resources,
    this.projectId,
    this.taskId,
  })  : id = id ?? const Uuid().v4(),
        captureDate = captureDate ?? DateTime.now(),
        tags = tags ?? [];
  
  /// Converte o modelo para a entidade
  IdeaEntity toEntity() {
    return IdeaEntity(
      id: id,
      title: title,
      description: description,
      captureDate: captureDate,
      category: IdeaCategory.values[category],
      status: IdeaStatus.values[status],
      tags: tags,
      notes: notes,
      nextSteps: nextSteps,
      resources: resources,
      projectId: projectId,
      taskId: taskId,
    );
  }
  
  /// Cria um modelo a partir da entidade
  factory IdeaModel.fromEntity(IdeaEntity entity) {
    return IdeaModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      captureDate: entity.captureDate,
      category: entity.category.index,
      status: entity.status.index,
      tags: entity.tags,
      notes: entity.notes,
      nextSteps: entity.nextSteps,
      resources: entity.resources,
      projectId: entity.projectId,
      taskId: entity.taskId,
    );
  }
}
