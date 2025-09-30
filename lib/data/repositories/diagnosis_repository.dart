import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';
import 'package:focora/data/models/diagnosis_model.dart';
import 'package:focora/domain/entities/diagnosis_entity.dart';

/// Repositório para gerenciar diagnósticos
class DiagnosisRepository {
  /// Caixa do Hive para armazenar diagnósticos
  final Box<DiagnosisModel> _diagnosisBox;
  
  /// Construtor
  DiagnosisRepository(this._diagnosisBox);
  
  /// Obtém todos os diagnósticos
  List<DiagnosisEntity> getAllDiagnoses() {
    return _diagnosisBox.values.map((model) => model.toEntity()).toList();
  }
  
  /// Obtém um diagnóstico pelo ID
  DiagnosisEntity? getDiagnosisById(String id) {
    try {
      final model = _diagnosisBox.values.firstWhere(
        (diagnosis) => diagnosis.id == id,
      );
      return model.toEntity();
    } catch (e) {
      return null;
    }
  }
  
  /// Obtém o diagnóstico mais recente
  DiagnosisEntity? getLatestDiagnosis() {
    if (_diagnosisBox.isEmpty) {
      return null;
    }
    
    return _diagnosisBox.values
        .reduce((a, b) => a.date.isAfter(b.date) ? a : b)
        .toEntity();
  }
  
  /// Adiciona um diagnóstico
  Future<void> addDiagnosis(DiagnosisEntity diagnosis) async {
    final model = DiagnosisModel.fromEntity(diagnosis);
    await _diagnosisBox.add(model);
  }
  
  /// Atualiza um diagnóstico
  Future<void> updateDiagnosis(DiagnosisEntity diagnosis) async {
    final index = _diagnosisBox.values.toList().indexWhere((d) => d.id == diagnosis.id);
    if (index != -1) {
      final model = DiagnosisModel.fromEntity(diagnosis);
      await _diagnosisBox.putAt(index, model);
    }
  }
  
  /// Remove um diagnóstico
  Future<void> deleteDiagnosis(String id) async {
    final index = _diagnosisBox.values.toList().indexWhere((d) => d.id == id);
    if (index != -1) {
      await _diagnosisBox.deleteAt(index);
    }
  }
  
  /// Adiciona um diagnóstico de exemplo
  Future<void> addSampleDiagnosis() async {
    if (_diagnosisBox.isEmpty) {
      await addDiagnosis(DiagnosisEntity(
        id: const Uuid().v4(),
        primaryType: 'Perfeccionista',
        secondaryType: 'Preocupado',
        date: DateTime.now(),
        scores: {
          'Perfeccionista': 12,
          'Preocupado': 9,
          'Sonhador': 7,
          'Desafiador': 5,
          'Sobrecarregado': 8,
          'Entediado': 4,
        },
        recommendations: [
          'Estabeleça padrões realistas para suas tarefas',
          'Divida projetos grandes em etapas menores e mais gerenciáveis',
          'Pratique a técnica Pomodoro para manter o foco sem buscar a perfeição',
          'Celebre o progresso, não apenas o resultado final perfeito',
          'Defina prazos claros para evitar revisões infinitas',
        ],
      ));
    }
  }
}
