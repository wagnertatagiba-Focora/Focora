import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';

part 'energy_log_model.g.dart';

/// Modelo de registro de energia para armazenamento com Hive
@HiveType(typeId: 3)
class EnergyLogModel extends HiveObject {
  /// Identificador único do registro
  @HiveField(0)
  final String id;
  
  /// Data e hora do registro
  @HiveField(1)
  final DateTime date;
  
  /// Período do dia
  @HiveField(2)
  final int period;
  
  /// Nível de energia (1-5)
  @HiveField(3)
  final int energyLevel;
  
  /// Nível de foco (1-5)
  @HiveField(4)
  final int focusLevel;
  
  /// Nível de motivação (1-5)
  @HiveField(5)
  final int motivationLevel;
  
  /// Fatores que influenciaram o nível de energia
  @HiveField(6)
  final List<String> factors;
  
  /// Notas adicionais sobre o registro
  @HiveField(7)
  final String? notes;
  
  /// Construtor
  EnergyLogModel({
    String? id,
    required this.date,
    required this.period,
    required this.energyLevel,
    required this.focusLevel,
    required this.motivationLevel,
    List<String>? factors,
    this.notes,
  })  : id = id ?? const Uuid().v4(),
        factors = factors ?? [];
  
  /// Converte o modelo para a entidade
  EnergyLogEntity toEntity() {
    return EnergyLogEntity(
      id: id,
      date: date,
      period: FocoraDayPeriod.values[period],
      energyLevel: energyLevel,
      focusLevel: focusLevel,
      motivationLevel: motivationLevel,
      factors: factors,
      notes: notes,
    );
  }
  
  /// Cria um modelo a partir da entidade
  factory EnergyLogModel.fromEntity(EnergyLogEntity entity) {
    return EnergyLogModel(
      id: entity.id,
      date: entity.date,
      period: entity.period.index,
      energyLevel: entity.energyLevel,
      focusLevel: entity.focusLevel,
      motivationLevel: entity.motivationLevel,
      factors: entity.factors,
      notes: entity.notes,
    );
  }
}
