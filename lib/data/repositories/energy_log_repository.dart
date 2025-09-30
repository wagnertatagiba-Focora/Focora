import 'package:hive/hive.dart';
import 'package:focora/data/models/energy_log_model.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';

/// Repositório para gerenciar registros de energia
class EnergyLogRepository {
  /// Caixa do Hive para armazenar registros de energia
  final Box<EnergyLogModel> _energyLogBox;
  
  /// Construtor
  EnergyLogRepository(this._energyLogBox);
  
  /// Obtém todos os registros de energia
  List<EnergyLogEntity> getAllEnergyLogs() {
    return _energyLogBox.values.map((model) => model.toEntity()).toList();
  }
  
  /// Obtém um registro de energia pelo ID
  EnergyLogEntity? getEnergyLogById(String id) {
    final model = _energyLogBox.values.firstWhere(
      (log) => log.id == id,
      orElse: () => null as EnergyLogModel,
    );
    return model?.toEntity();
  }
  
  /// Obtém registros de energia para hoje
  List<EnergyLogEntity> getTodayLogs() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    
    return _energyLogBox.values
        .where((log) => 
          log.date.isAfter(today.subtract(const Duration(seconds: 1))) && 
          log.date.isBefore(tomorrow)
        )
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Obtém registros de energia para a semana atual
  List<EnergyLogEntity> getThisWeekLogs() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final endDate = startDate.add(const Duration(days: 7));
    
    return _energyLogBox.values
        .where((log) => 
          log.date.isAfter(startDate.subtract(const Duration(seconds: 1))) && 
          log.date.isBefore(endDate)
        )
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Obtém registros de energia para o mês atual
  List<EnergyLogEntity> getThisMonthLogs() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1);
    
    return _energyLogBox.values
        .where((log) => 
          log.date.isAfter(startOfMonth.subtract(const Duration(seconds: 1))) && 
          log.date.isBefore(endOfMonth)
        )
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Obtém o registro de energia mais recente para o período atual
  EnergyLogEntity? getLatestLogForCurrentPeriod() {
    final currentPeriod = getCurrentPeriod();
    final todayLogs = getTodayLogs();
    
    try {
      return todayLogs.firstWhere((log) => log.period == currentPeriod);
    } catch (e) {
      return null;
    }
  }
  
  /// Adiciona um registro de energia
  Future<void> addEnergyLog(EnergyLogEntity log) async {
    final model = EnergyLogModel.fromEntity(log);
    await _energyLogBox.add(model);
  }
  
  /// Atualiza um registro de energia
  Future<void> updateEnergyLog(EnergyLogEntity log) async {
    final index = _energyLogBox.values.toList().indexWhere((l) => l.id == log.id);
    if (index != -1) {
      final model = EnergyLogModel.fromEntity(log);
      await _energyLogBox.putAt(index, model);
    }
  }
  
  /// Remove um registro de energia
  Future<void> deleteEnergyLog(String id) async {
    final index = _energyLogBox.values.toList().indexWhere((l) => l.id == id);
    if (index != -1) {
      await _energyLogBox.deleteAt(index);
    }
  }
  
  /// Adiciona registros de energia de exemplo
  Future<void> addSampleEnergyLogs() async {
    if (_energyLogBox.isEmpty) {
      final now = DateTime.now();
      
      // Registros para hoje
      await addEnergyLog(EnergyLogEntity(
        date: DateTime(now.year, now.month, now.day, 8, 0),
        period: FocoraDayPeriod.morning,
        energyLevel: 4,
        focusLevel: 3,
        motivationLevel: 4,
        factors: ['Café da manhã completo', 'Boa noite de sono'],
      ));
      
      await addEnergyLog(EnergyLogEntity(
        date: DateTime(now.year, now.month, now.day, 13, 0),
        period: FocoraDayPeriod.afternoon,
        energyLevel: 3,
        focusLevel: 4,
        motivationLevel: 3,
        factors: ['Almoço pesado', 'Reunião produtiva'],
      ));
      
      // Registros para os últimos 7 dias
      for (int i = 1; i <= 7; i++) {
        final date = now.subtract(Duration(days: i));
        
        await addEnergyLog(EnergyLogEntity(
          date: DateTime(date.year, date.month, date.day, 8, 0),
          period: FocoraDayPeriod.morning,
          energyLevel: 3 + (i % 3),
          focusLevel: 2 + (i % 4),
          motivationLevel: 3 + (i % 3),
          factors: ['Exemplo de fator ${i}a'],
        ));
        
        await addEnergyLog(EnergyLogEntity(
          date: DateTime(date.year, date.month, date.day, 13, 0),
          period: FocoraDayPeriod.afternoon,
          energyLevel: 4 - (i % 3),
          focusLevel: 3 - (i % 3),
          motivationLevel: 4 - (i % 3),
          factors: ['Exemplo de fator ${i}b'],
        ));
        
        await addEnergyLog(EnergyLogEntity(
          date: DateTime(date.year, date.month, date.day, 19, 0),
          period: FocoraDayPeriod.evening,
          energyLevel: 2 + (i % 4),
          focusLevel: 2 + (i % 3),
          motivationLevel: 3 + (i % 3),
          factors: ['Exemplo de fator ${i}c'],
        ));
      }
    }
  }
}
