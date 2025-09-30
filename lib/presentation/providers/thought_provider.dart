import 'package:flutter/foundation.dart';
import 'package:focora/domain/entities/thought_entity.dart';
import 'package:focora/data/repositories/thought_repository.dart';

/// Provider para gerenciar o estado dos pensamentos
class ThoughtProvider with ChangeNotifier {
  /// Repositório de pensamentos
  final ThoughtRepository _repository;
  
  /// Lista de pensamentos
  List<ThoughtEntity> _thoughts = [];
  
  /// Pensamento atual sendo editado
  ThoughtEntity? _currentThought;
  
  /// Construtor
  ThoughtProvider(this._repository) {
    loadThoughts();
  }
  
  /// Retorna a lista de pensamentos
  List<ThoughtEntity> get thoughts => _thoughts;
  
  /// Retorna o pensamento atual
  ThoughtEntity? get currentThought => _currentThought;
  
  /// Retorna os pensamentos recentes
  List<ThoughtEntity> get recentThoughts {
    final sortedThoughts = List<ThoughtEntity>.from(_thoughts)
      ..sort((a, b) => b.date.compareTo(a.date));
    return sortedThoughts.take(10).toList();
  }
  
  /// Retorna as distorções cognitivas mais comuns
  List<MapEntry<CognitiveDistortion, int>> get commonDistortions {
    final distortionCounts = <CognitiveDistortion, int>{};
    
    for (final thought in _thoughts) {
      for (final distortion in thought.distortions) {
        if (distortion != CognitiveDistortion.none) {
          distortionCounts[distortion] = (distortionCounts[distortion] ?? 0) + 1;
        }
      }
    }
    
    final sortedDistortions = distortionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedDistortions;
  }
  
  /// Retorna as emoções mais comuns
  List<MapEntry<String, int>> get commonEmotions {
    final emotionCounts = <String, int>{};
    
    for (final thought in _thoughts) {
      for (final emotion in thought.emotions) {
        emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;
      }
    }
    
    final sortedEmotions = emotionCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedEmotions;
  }
  
  /// Carrega os pensamentos do repositório
  Future<void> loadThoughts() async {
    _thoughts = _repository.getAllThoughts();
    notifyListeners();
  }
  
  /// Define o pensamento atual
  void setCurrentThought(ThoughtEntity? thought) {
    _currentThought = thought;
    notifyListeners();
  }
  
  /// Cria um novo pensamento
  void createNewThought(String content) {
    _currentThought = ThoughtEntity(content: content);
    notifyListeners();
  }
  
  /// Adiciona um pensamento
  Future<void> addThought(ThoughtEntity thought) async {
    await _repository.addThought(thought);
    await loadThoughts();
    _currentThought = null;
  }
  
  /// Atualiza um pensamento
  Future<void> updateThought(ThoughtEntity thought) async {
    await _repository.updateThought(thought);
    await loadThoughts();
    _currentThought = null;
  }
  
  /// Remove um pensamento
  Future<void> deleteThought(String id) async {
    await _repository.deleteThought(id);
    await loadThoughts();
    if (_currentThought?.id == id) {
      _currentThought = null;
    }
  }
  
  /// Adiciona uma distorção ao pensamento atual
  void addDistortionToCurrent(CognitiveDistortion distortion) {
    if (_currentThought != null) {
      _currentThought = _currentThought!.addDistortion(distortion);
      notifyListeners();
    }
  }
  
  /// Remove uma distorção do pensamento atual
  void removeDistortionFromCurrent(CognitiveDistortion distortion) {
    if (_currentThought != null) {
      _currentThought = _currentThought!.removeDistortion(distortion);
      notifyListeners();
    }
  }
  
  /// Adiciona uma emoção ao pensamento atual
  void addEmotionToCurrent(String emotion) {
    if (_currentThought != null) {
      _currentThought = _currentThought!.addEmotion(emotion);
      notifyListeners();
    }
  }
  
  /// Remove uma emoção do pensamento atual
  void removeEmotionFromCurrent(String emotion) {
    if (_currentThought != null) {
      _currentThought = _currentThought!.removeEmotion(emotion);
      notifyListeners();
    }
  }
  
  /// Atualiza a intensidade da emoção do pensamento atual
  void updateCurrentEmotionIntensity(int intensity) {
    if (_currentThought != null) {
      _currentThought = _currentThought!.copyWith(emotionIntensity: intensity);
      notifyListeners();
    }
  }
  
  /// Atualiza a situação do pensamento atual
  void updateCurrentSituation(String situation) {
    if (_currentThought != null) {
      _currentThought = _currentThought!.copyWith(situation: situation);
      notifyListeners();
    }
  }
  
  /// Atualiza o pensamento alternativo do pensamento atual
  void updateCurrentAlternativeThought(String alternativeThought) {
    if (_currentThought != null) {
      _currentThought = _currentThought!.copyWith(alternativeThought: alternativeThought);
      notifyListeners();
    }
  }
  
  /// Atualiza o resultado do pensamento atual
  void updateCurrentOutcome(String outcome) {
    if (_currentThought != null) {
      _currentThought = _currentThought!.copyWith(outcome: outcome);
      notifyListeners();
    }
  }
  
  /// Salva o pensamento atual
  Future<void> saveCurrentThought() async {
    if (_currentThought != null) {
      if (_thoughts.any((t) => t.id == _currentThought!.id)) {
        await updateThought(_currentThought!);
      } else {
        await addThought(_currentThought!);
      }
    }
  }
  
  /// Descarta o pensamento atual
  void discardCurrentThought() {
    _currentThought = null;
    notifyListeners();
  }
}
