import 'package:flutter/foundation.dart';
import 'package:focora/domain/entities/idea_entity.dart';
import 'package:focora/data/repositories/idea_repository.dart';

/// Provider para gerenciar o estado das ideias
class IdeaProvider with ChangeNotifier {
  /// Repositório de ideias
  final IdeaRepository _repository;
  
  /// Lista de ideias
  List<IdeaEntity> _ideas = [];
  
  /// Ideia atual sendo editada
  IdeaEntity? _currentIdea;
  
  /// Construtor
  IdeaProvider(this._repository) {
    loadIdeas();
  }
  
  /// Retorna a lista de ideias
  List<IdeaEntity> get ideas => _ideas;
  
  /// Retorna a ideia atual
  IdeaEntity? get currentIdea => _currentIdea;
  
  /// Retorna as ideias recentes
  List<IdeaEntity> get recentIdeas {
    final sortedIdeas = List<IdeaEntity>.from(_ideas)
      ..sort((a, b) => b.captureDate.compareTo(a.captureDate));
    return sortedIdeas.take(10).toList();
  }
  
  /// Retorna as ideias capturadas
  List<IdeaEntity> get capturedIdeas {
    return _ideas.where((idea) => idea.status == IdeaStatus.captured).toList();
  }
  
  /// Retorna as ideias em desenvolvimento
  List<IdeaEntity> get inDevelopmentIdeas {
    return _ideas.where((idea) => idea.status == IdeaStatus.inDevelopment).toList();
  }
  
  /// Retorna as ideias implementadas
  List<IdeaEntity> get implementedIdeas {
    return _ideas.where((idea) => idea.status == IdeaStatus.implemented).toList();
  }
  
  /// Retorna as ideias arquivadas
  List<IdeaEntity> get archivedIdeas {
    return _ideas.where((idea) => idea.status == IdeaStatus.archived).toList();
  }
  
  /// Retorna as categorias mais comuns
  List<MapEntry<IdeaCategory, int>> get commonCategories {
    final categoryCounts = <IdeaCategory, int>{};
    
    for (final idea in _ideas) {
      categoryCounts[idea.category] = (categoryCounts[idea.category] ?? 0) + 1;
    }
    
    final sortedCategories = categoryCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedCategories;
  }
  
  /// Retorna as tags mais comuns
  List<MapEntry<String, int>> get commonTags {
    final tagCounts = <String, int>{};
    
    for (final idea in _ideas) {
      for (final tag in idea.tags) {
        tagCounts[tag] = (tagCounts[tag] ?? 0) + 1;
      }
    }
    
    final sortedTags = tagCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return sortedTags;
  }
  
  /// Carrega as ideias do repositório
  Future<void> loadIdeas() async {
    _ideas = _repository.getAllIdeas();
    notifyListeners();
  }
  
  /// Define a ideia atual
  void setCurrentIdea(IdeaEntity? idea) {
    _currentIdea = idea;
    notifyListeners();
  }
  
  /// Cria uma nova ideia
  void createNewIdea(String title, String description) {
    _currentIdea = IdeaEntity(
      title: title,
      description: description,
    );
    notifyListeners();
  }
  
  /// Adiciona uma ideia
  Future<void> addIdea(IdeaEntity idea) async {
    await _repository.addIdea(idea);
    await loadIdeas();
    _currentIdea = null;
  }
  
  /// Atualiza uma ideia
  Future<void> updateIdea(IdeaEntity idea) async {
    await _repository.updateIdea(idea);
    await loadIdeas();
    _currentIdea = null;
  }
  
  /// Remove uma ideia
  Future<void> deleteIdea(String id) async {
    await _repository.deleteIdea(id);
    await loadIdeas();
    if (_currentIdea?.id == id) {
      _currentIdea = null;
    }
  }
  
  /// Atualiza o status de uma ideia
  Future<void> updateIdeaStatus(String id, IdeaStatus status) async {
    await _repository.updateIdeaStatus(id, status);
    await loadIdeas();
  }
  
  /// Atualiza o título da ideia atual
  void updateCurrentTitle(String title) {
    if (_currentIdea != null) {
      _currentIdea = _currentIdea!.copyWith(title: title);
      notifyListeners();
    }
  }
  
  /// Atualiza a descrição da ideia atual
  void updateCurrentDescription(String description) {
    if (_currentIdea != null) {
      _currentIdea = _currentIdea!.copyWith(description: description);
      notifyListeners();
    }
  }
  
  /// Atualiza a categoria da ideia atual
  void updateCurrentCategory(IdeaCategory category) {
    if (_currentIdea != null) {
      _currentIdea = _currentIdea!.copyWith(category: category);
      notifyListeners();
    }
  }
  
  /// Atualiza o status da ideia atual
  void updateCurrentStatus(IdeaStatus status) {
    if (_currentIdea != null) {
      _currentIdea = _currentIdea!.copyWith(status: status);
      notifyListeners();
    }
  }
  
  /// Adiciona uma tag à ideia atual
  void addTagToCurrent(String tag) {
    if (_currentIdea != null) {
      _currentIdea = _currentIdea!.addTag(tag);
      notifyListeners();
    }
  }
  
  /// Remove uma tag da ideia atual
  void removeTagFromCurrent(String tag) {
    if (_currentIdea != null) {
      _currentIdea = _currentIdea!.removeTag(tag);
      notifyListeners();
    }
  }
  
  /// Atualiza as notas da ideia atual
  void updateCurrentNotes(String notes) {
    if (_currentIdea != null) {
      _currentIdea = _currentIdea!.copyWith(notes: notes);
      notifyListeners();
    }
  }
  
  /// Atualiza os próximos passos da ideia atual
  void updateCurrentNextSteps(String nextSteps) {
    if (_currentIdea != null) {
      _currentIdea = _currentIdea!.copyWith(nextSteps: nextSteps);
      notifyListeners();
    }
  }
  
  /// Atualiza os recursos da ideia atual
  void updateCurrentResources(String resources) {
    if (_currentIdea != null) {
      _currentIdea = _currentIdea!.copyWith(resources: resources);
      notifyListeners();
    }
  }
  
  /// Salva a ideia atual
  Future<void> saveCurrentIdea() async {
    if (_currentIdea != null) {
      if (_ideas.any((i) => i.id == _currentIdea!.id)) {
        await updateIdea(_currentIdea!);
      } else {
        await addIdea(_currentIdea!);
      }
    }
  }
  
  /// Descarta a ideia atual
  void discardCurrentIdea() {
    _currentIdea = null;
    notifyListeners();
  }
}
