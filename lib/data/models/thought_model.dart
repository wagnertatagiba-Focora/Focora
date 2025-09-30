import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:focora/domain/entities/thought_entity.dart';

part 'thought_model.g.dart';

/// Modelo de pensamento para armazenamento com Hive
@HiveType(typeId: 5)
class ThoughtModel extends HiveObject {
  /// Identificador único do pensamento
  @HiveField(0)
  final String id;
  
  /// Conteúdo do pensamento
  @HiveField(1)
  final String content;
  
  /// Data e hora do registro
  @HiveField(2)
  final DateTime date;
  
  /// Situação que desencadeou o pensamento
  @HiveField(3)
  final String? situation;
  
  /// Emoções associadas ao pensamento
  @HiveField(4)
  final List<String> emotions;
  
  /// Intensidade da emoção (1-10)
  @HiveField(5)
  final int emotionIntensity;
  
  /// Distorções cognitivas identificadas (armazenadas como inteiros)
  @HiveField(6)
  final List<int> distortions;
  
  /// Pensamento alternativo mais equilibrado
  @HiveField(7)
  final String? alternativeThought;
  
  /// Resultado após a reflexão
  @HiveField(8)
  final String? outcome;
  
  /// Tarefa associada ao pensamento
  @HiveField(9)
  final String? taskId;
  
  /// Construtor
  ThoughtModel({
    String? id,
    required this.content,
    DateTime? date,
    this.situation,
    List<String>? emotions,
    this.emotionIntensity = 5,
    List<int>? distortions,
    this.alternativeThought,
    this.outcome,
    this.taskId,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now(),
        emotions = emotions ?? [],
        distortions = distortions ?? [];
  
  /// Converte o modelo para a entidade
  ThoughtEntity toEntity() {
    return ThoughtEntity(
      id: id,
      content: content,
      date: date,
      situation: situation,
      emotions: emotions,
      emotionIntensity: emotionIntensity,
      distortions: distortions
          .map((index) => CognitiveDistortion.values[index])
          .toList(),
      alternativeThought: alternativeThought,
      outcome: outcome,
      taskId: taskId,
    );
  }
  
  /// Cria um modelo a partir da entidade
  factory ThoughtModel.fromEntity(ThoughtEntity entity) {
    return ThoughtModel(
      id: entity.id,
      content: entity.content,
      date: entity.date,
      situation: entity.situation,
      emotions: entity.emotions,
      emotionIntensity: entity.emotionIntensity,
      distortions: entity.distortions
          .map((distortion) => distortion.index)
          .toList(),
      alternativeThought: entity.alternativeThought,
      outcome: entity.outcome,
      taskId: entity.taskId,
    );
  }
}
