import 'package:flutter/foundation.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';
import 'package:focora/data/repositories/energy_log_repository.dart';

/// Provider para gerenciar o estado dos registros de energia
class EnergyProvider with ChangeNotifier {
  /// Repositório de registros de energia
  final EnergyLogRepository _repository;
  
  /// Lista de registros de energia
  List<EnergyLogEntity> _energyLogs = [];
  
  /// Construtor
  EnergyProvider(this._repository) {
    loadEnergyLogs();
  }
  
  /// Retorna a lista de registros de energia
  List<EnergyLogEntity> get energyLogs => _energyLogs;
  
  /// Retorna os registros de energia de hoje
  List<EnergyLogEntity> get todayLogs {
    final now = DateTime.now();
    return _energyLogs.where((log) => 
      log.date.year == now.year && 
      log.date.month == now.month && 
      log.date.day == now.day
    ).toList();
  }
  
  /// Retorna os registros de energia da semana atual
  List<EnergyLogEntity> get thisWeekLogs {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    
    return _energyLogs.where((log) => 
      log.date.isAfter(startDate.subtract(const Duration(days: 1))) && 
      log.date.isBefore(startDate.add(const Duration(days: 7)))
    ).toList();
  }
  
  /// Retorna os registros de energia do mês atual
  List<EnergyLogEntity> get thisMonthLogs {
    final now = DateTime.now();
    return _energyLogs.where((log) => 
      log.date.year == now.year && 
      log.date.month == now.month
    ).toList();
  }
  
  /// Retorna o registro de energia mais recente
  EnergyLogEntity? get latestLog {
    if (_energyLogs.isEmpty) return null;
    return _energyLogs.reduce((a, b) => a.date.isAfter(b.date) ? a : b);
  }
  
  /// Retorna o registro de energia mais recente para o período atual
  EnergyLogEntity? get latestLogForCurrentPeriod {
    final currentPeriod = getCurrentPeriod();
    
    try {
      return todayLogs.firstWhere((log) => log.period == currentPeriod);
    } catch (e) {
      return null;
    }
  }
  
  /// Retorna a média de energia para o período especificado
  double getAverageEnergyLevel(List<EnergyLogEntity> logs) {
    if (logs.isEmpty) return 0;
    final sum = logs.fold<double>(0, (sum, log) => sum + log.energyLevel);
    return sum / logs.length;
  }
  
  /// Retorna a média de foco para o período especificado
  double getAverageFocusLevel(List<EnergyLogEntity> logs) {
    if (logs.isEmpty) return 0;
    final sum = logs.fold<double>(0, (sum, log) => sum + log.focusLevel);
    return sum / logs.length;
  }
  
  /// Retorna a média de motivação para o período especificado
  double getAverageMotivationLevel(List<EnergyLogEntity> logs) {
    if (logs.isEmpty) return 0;
    final sum = logs.fold<double>(0, (sum, log) => sum + log.motivationLevel);
    return sum / logs.length;
  }
  
  /// Retorna um registro de energia pelo ID
  EnergyLogEntity? getLogById(String id) {
    try {
      return _energyLogs.firstWhere((log) => log.id == id);
    } catch (e) {
      return null;
    }
  }
  
  /// Carrega os registros de energia do repositório
  Future<void> loadEnergyLogs() async {
    _energyLogs = _repository.getAllEnergyLogs();
    notifyListeners();
  }
  
  /// Adiciona um registro de energia
  Future<void> addEnergyLog(EnergyLogEntity log) async {
    await _repository.addEnergyLog(log);
    await loadEnergyLogs();
  }
  
  /// Atualiza um registro de energia
  Future<void> updateEnergyLog(EnergyLogEntity updatedLog) async {
    await _repository.updateEnergyLog(updatedLog);
    await loadEnergyLogs();
  }
  
  /// Remove um registro de energia
  Future<void> deleteEnergyLog(String id) async {
    await _repository.deleteEnergyLog(id);
    await loadEnergyLogs();
  }
  
  /// Retorna o período atual do dia
  FocoraDayPeriod getCurrentPeriod() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 12) {
      return FocoraDayPeriod.morning;
    } else if (hour >= 12 && hour < 18) {
      return FocoraDayPeriod.afternoon;
    } else {
      return FocoraDayPeriod.evening;
    }
  }
  
  /// Adiciona registros de energia de exemplo para desenvolvimento
  Future<void> addSampleEnergyLogs() async {
    await _repository.addSampleEnergyLogs();
    await loadEnergyLogs();
  }
}
