import 'package:uuid/uuid.dart';

/// Enum que representa o período do dia
enum FocoraDayPeriod {
  /// Manhã (6h às 12h)
  morning,
  
  /// Tarde (12h às 18h)
  afternoon,
  
  /// Noite (18h às 0h)
  evening,
  
  /// Madrugada (0h às 6h)
  night,
}

/// Extensão para obter o nome em português do período
extension FocoraDayPeriodExtension on FocoraDayPeriod {
  String get name {
    switch (this) {
      case FocoraDayPeriod.morning:
        return 'Manhã';
      case FocoraDayPeriod.afternoon:
        return 'Tarde';
      case FocoraDayPeriod.evening:
        return 'Noite';
      case FocoraDayPeriod.night:
        return 'Madrugada';
    }
  }
  
  /// Retorna o horário de início do período
  int get startHour {
    switch (this) {
      case FocoraDayPeriod.morning:
        return 6;
      case FocoraDayPeriod.afternoon:
        return 12;
      case FocoraDayPeriod.evening:
        return 18;
      case FocoraDayPeriod.night:
        return 0;
    }
  }
  
  /// Retorna o horário de fim do período
  int get endHour {
    switch (this) {
      case FocoraDayPeriod.morning:
        return 12;
      case FocoraDayPeriod.afternoon:
        return 18;
      case FocoraDayPeriod.evening:
        return 24;
      case FocoraDayPeriod.night:
        return 6;
    }
  }
}

/// Retorna o período atual com base na hora
FocoraDayPeriod getCurrentPeriod() {
  final hour = DateTime.now().hour;
  if (hour >= 6 && hour < 12) {
    return FocoraDayPeriod.morning;
  } else if (hour >= 12 && hour < 18) {
    return FocoraDayPeriod.afternoon;
  } else if (hour >= 18) {
    return FocoraDayPeriod.evening;
  } else {
    return FocoraDayPeriod.night;
  }
}

/// Entidade que representa um registro de energia
class EnergyLogEntity {
  /// Identificador único do registro
  final String id;
  
  /// Data do registro
  final DateTime date;
  
  /// Período do dia
  final FocoraDayPeriod period;
  
  /// Nível de energia (1-5)
  int energyLevel;
  
  /// Nível de foco (1-5)
  int focusLevel;
  
  /// Nível de motivação (1-5)
  int motivationLevel;
  
  /// Notas adicionais sobre o registro
  String? notes;
  
  /// Fatores que influenciaram o nível de energia
  List<String> factors;
  
  /// Construtor
  EnergyLogEntity({
    String? id,
    DateTime? date,
    FocoraDayPeriod? period,
    required this.energyLevel,
    required this.focusLevel,
    required this.motivationLevel,
    this.notes,
    List<String>? factors,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now(),
        period = period ?? getCurrentPeriod(),
        factors = factors ?? [];
  
  /// Cria uma cópia do registro com os campos atualizados
  EnergyLogEntity copyWith({
    int? energyLevel,
    int? focusLevel,
    int? motivationLevel,
    String? notes,
    List<String>? factors,
  }) {
    return EnergyLogEntity(
      id: id,
      date: date,
      period: period,
      energyLevel: energyLevel ?? this.energyLevel,
      focusLevel: focusLevel ?? this.focusLevel,
      motivationLevel: motivationLevel ?? this.motivationLevel,
      notes: notes ?? this.notes,
      factors: factors ?? List.from(this.factors),
    );
  }
  
  /// Adiciona um fator ao registro
  EnergyLogEntity addFactor(String factor) {
    final newFactors = List<String>.from(factors);
    if (!newFactors.contains(factor)) {
      newFactors.add(factor);
    }
    return copyWith(factors: newFactors);
  }
  
  /// Remove um fator do registro
  EnergyLogEntity removeFactor(String factor) {
    final newFactors = List<String>.from(factors);
    newFactors.remove(factor);
    return copyWith(factors: newFactors);
  }
  
  /// Retorna a média dos níveis de energia, foco e motivação
  double get averageLevel {
    return (energyLevel + focusLevel + motivationLevel) / 3;
  }
  
  /// Retorna a data formatada como string (dd/MM/yyyy)
  String get formattedDate {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
  
  /// Retorna a hora formatada como string (HH:mm)
  String get formattedTime {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
