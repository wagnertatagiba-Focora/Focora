import 'package:hive/hive.dart';
import 'package:focora/data/models/idea_model.dart';
import 'package:focora/domain/entities/idea_entity.dart';

/// Repositório para gerenciar ideias
class IdeaRepository {
  /// Caixa do Hive para armazenar ideias
  final Box<IdeaModel> _ideaBox;
  
  /// Construtor
  IdeaRepository(this._ideaBox);
  
  /// Obtém todas as ideias
  List<IdeaEntity> getAllIdeas() {
    return _ideaBox.values.map((model) => model.toEntity()).toList();
  }
  
  /// Obtém uma ideia pelo ID
  IdeaEntity? getIdeaById(String id) {
    try {
      final model = _ideaBox.values.firstWhere(
        (idea) => idea.id == id,
      );
      return model.toEntity();
    } catch (e) {
      return null;
    }
  }
  
  /// Obtém ideias por categoria
  List<IdeaEntity> getIdeasByCategory(IdeaCategory category) {
    return _ideaBox.values
        .where((idea) => idea.category == category.index)
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Obtém ideias por status
  List<IdeaEntity> getIdeasByStatus(IdeaStatus status) {
    return _ideaBox.values
        .where((idea) => idea.status == status.index)
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Obtém ideias por tag
  List<IdeaEntity> getIdeasByTag(String tag) {
    return _ideaBox.values
        .where((idea) => idea.tags.contains(tag))
        .map((model) => model.toEntity())
        .toList();
  }
  
  /// Obtém ideias recentes
  List<IdeaEntity> getRecentIdeas({int limit = 10}) {
    final ideas = _ideaBox.values
        .map((model) => model.toEntity())
        .toList();
    
    ideas.sort((a, b) => b.captureDate.compareTo(a.captureDate));
    
    return ideas.take(limit).toList();
  }
  
  /// Adiciona uma ideia
  Future<void> addIdea(IdeaEntity idea) async {
    final model = IdeaModel.fromEntity(idea);
    await _ideaBox.add(model);
  }
  
  /// Atualiza uma ideia
  Future<void> updateIdea(IdeaEntity idea) async {
    final index = _ideaBox.values.toList().indexWhere((i) => i.id == idea.id);
    if (index != -1) {
      final model = IdeaModel.fromEntity(idea);
      await _ideaBox.putAt(index, model);
    }
  }
  
  /// Remove uma ideia
  Future<void> deleteIdea(String id) async {
    final index = _ideaBox.values.toList().indexWhere((i) => i.id == id);
    if (index != -1) {
      await _ideaBox.deleteAt(index);
    }
  }
  
  /// Atualiza o status de uma ideia
  Future<void> updateIdeaStatus(String id, IdeaStatus status) async {
    final idea = getIdeaById(id);
    if (idea != null) {
      final updatedIdea = idea.copyWith(status: status);
      await updateIdea(updatedIdea);
    }
  }
  
  /// Adiciona ideias de exemplo
  Future<void> addSampleIdeas() async {
    if (_ideaBox.isEmpty) {
      final now = DateTime.now();
      
      // Ideia 1
      await addIdea(IdeaEntity(
        title: 'Aplicativo de meditação guiada',
        description: 'Um aplicativo que oferece meditações guiadas específicas para combater a procrastinação e aumentar o foco.',
        captureDate: now.subtract(const Duration(days: 5)),
        category: IdeaCategory.product,
        tags: ['meditação', 'foco', 'app'],
        notes: 'Surgiu durante uma sessão de ócio criativo após uma meditação.',
        nextSteps: 'Pesquisar aplicativos similares e identificar diferenciais.',
      ));
      
      // Ideia 2
      await addIdea(IdeaEntity(
        title: 'Sistema de recompensas personalizadas',
        description: 'Um sistema que permite ao usuário definir recompensas personalizadas para quando completar tarefas importantes.',
        captureDate: now.subtract(const Duration(days: 3)),
        category: IdeaCategory.processImprovement,
        status: IdeaStatus.inDevelopment,
        tags: ['motivação', 'recompensas', 'gamificação'],
        notes: 'Baseado em estudos sobre motivação intrínseca vs. extrínseca.',
        nextSteps: 'Criar um protótipo simples para testar com alguns usuários.',
      ));
      
      // Ideia 3
      await addIdea(IdeaEntity(
        title: 'Curso sobre produtividade sustentável',
        description: 'Um curso online que ensina técnicas de produtividade que não levam ao esgotamento.',
        captureDate: now.subtract(const Duration(hours: 12)),
        category: IdeaCategory.service,
        tags: ['curso', 'produtividade', 'bem-estar'],
        notes: 'Ideia surgiu durante uma caminhada no parque.',
        resources: 'Precisaria de uma plataforma de cursos online e equipamento para gravação.',
      ));
    }
  }
}
