import 'package:hive/hive.dart';
import 'package:focora/data/models/thought_model.dart';
import 'package:focora/domain/entities/thought_entity.dart';

/// Repositório para gerenciar pensamentos
class ThoughtRepository {
  /// Caixa do Hive para armazenar pensamentos
  final Box<ThoughtModel> _thoughtBox;
  
  /// Construtor
  ThoughtRepository(this._thoughtBox);
  
  /// Obtém todos os pensamentos
  List<ThoughtEntity> getAllThoughts() {
    return _thoughtBox.values.map((model) => model.toEntity()).toList();
  }
  
  /// Obtém um pensamento pelo ID
  ThoughtEntity? getThoughtById(String id) {
    try {
      final model = _thoughtBox.values.firstWhere(
        (thought) => thought.id == id,
      );
      return model.toEntity();
    } catch (e) {
      return null;
    }
  }
  
  /// Obtém pensamentos por tarefa
  List<ThoughtEntity> getThoughtsByTask(String taskId) {
    return _thoughtBox.values
        .where((thought) => thought.taskId == taskId)
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Obtém pensamentos recentes
  List<ThoughtEntity> getRecentThoughts({int limit = 10}) {
    final thoughts = _thoughtBox.values
        .map((model) => model.toEntity())
        .toList();
    
    thoughts.sort((a, b) => b.date.compareTo(a.date));
    
    return thoughts.take(limit).toList();
  }
  
  /// Obtém pensamentos com distorções específicas
  List<ThoughtEntity> getThoughtsByDistortion(CognitiveDistortion distortion) {
    return _thoughtBox.values
        .where((thought) => thought.distortions.contains(distortion.index))
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Adiciona um pensamento
  Future<void> addThought(ThoughtEntity thought) async {
    final model = ThoughtModel.fromEntity(thought);
    await _thoughtBox.add(model);
  }
  
  /// Atualiza um pensamento
  Future<void> updateThought(ThoughtEntity thought) async {
    final index = _thoughtBox.values.toList().indexWhere((t) => t.id == thought.id);
    if (index != -1) {
      final model = ThoughtModel.fromEntity(thought);
      await _thoughtBox.putAt(index, model);
    }
  }
  
  /// Remove um pensamento
  Future<void> deleteThought(String id) async {
    final index = _thoughtBox.values.toList().indexWhere((t) => t.id == id);
    if (index != -1) {
      await _thoughtBox.deleteAt(index);
    }
  }
  
  /// Adiciona pensamentos de exemplo
  Future<void> addSampleThoughts() async {
    if (_thoughtBox.isEmpty) {
      final now = DateTime.now();
      
      // Pensamento 1
      await addThought(ThoughtEntity(
        content: 'Nunca vou conseguir terminar este projeto a tempo.',
        situation: 'Trabalhando em um projeto com prazo apertado',
        emotions: ['Ansiedade', 'Frustração'],
        emotionIntensity: 8,
        distortions: [
          CognitiveDistortion.allOrNothing,
          CognitiveDistortion.overgeneralization,
        ],
        alternativeThought: 'Posso não conseguir fazer tudo que planejei, mas posso priorizar as partes mais importantes e entregar algo de valor.',
        date: now.subtract(const Duration(days: 2)),
      ));
      
      // Pensamento 2
      await addThought(ThoughtEntity(
        content: 'Se eu não fizer isso perfeitamente, todos vão perceber que sou um impostor.',
        situation: 'Preparando uma apresentação importante',
        emotions: ['Medo', 'Vergonha'],
        emotionIntensity: 7,
        distortions: [
          CognitiveDistortion.shouldStatements,
          CognitiveDistortion.magnificationOrMinimization,
        ],
        alternativeThought: 'Não preciso ser perfeito para fazer uma boa apresentação. Todos cometem erros ocasionalmente.',
        date: now.subtract(const Duration(days: 5)),
      ));
      
      // Pensamento 3
      await addThought(ThoughtEntity(
        content: 'Estou adiando esta tarefa porque é muito difícil.',
        situation: 'Tentando começar um relatório complexo',
        emotions: ['Ansiedade', 'Insegurança'],
        emotionIntensity: 6,
        distortions: [
          CognitiveDistortion.avoidance,
          CognitiveDistortion.emotionalReasoning,
        ],
        alternativeThought: 'Posso dividir esta tarefa em partes menores e começar com a mais simples.',
        date: now.subtract(const Duration(hours: 8)),
      ));
    }
  }
}
