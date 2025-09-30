import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:focora/domain/entities/diagnosis_entity.dart';

part 'diagnosis_model.g.dart';

/// Modelo de diagnóstico para armazenamento com Hive
@HiveType(typeId: 4)
class DiagnosisModel extends HiveObject {
  /// Identificador único do diagnóstico
  @HiveField(0)
  final String id;
  
  /// Data do diagnóstico
  @HiveField(1)
  final DateTime date;
  
  /// Tipo principal de procrastinador
  @HiveField(2)
  final String primaryType;
  
  /// Tipo secundário de procrastinador
  @HiveField(3)
  final String? secondaryType;
  
  /// Pontuações por tipo
  @HiveField(4)
  final Map<String, int> scores;
  
  /// Recomendações personalizadas
  @HiveField(5)
  final List<String> recommendations;
  
  /// Construtor
  DiagnosisModel({
    String? id,
    DateTime? date,
    required this.primaryType,
    this.secondaryType,
    required this.scores,
    required this.recommendations,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now();
  
  /// Converte o modelo para a entidade
  DiagnosisEntity toEntity() {
    return DiagnosisEntity(
      id: id,
      date: date,
      primaryType: primaryType,
      secondaryType: secondaryType,
      scores: scores,
      recommendations: recommendations,
    );
  }
  
  /// Cria um modelo a partir da entidade
  factory DiagnosisModel.fromEntity(DiagnosisEntity entity) {
    return DiagnosisModel(
      id: entity.id,
      date: entity.date,
      primaryType: entity.primaryType,
      secondaryType: entity.secondaryType,
      scores: entity.scores,
      recommendations: entity.recommendations,
    );
  }
}
