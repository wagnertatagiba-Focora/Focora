import 'package:uuid/uuid.dart';

/// Categoria de ideia
enum IdeaCategory {
  /// Ideia de projeto pessoal
  personal,
  
  /// Ideia de projeto profissional
  professional,
  
  /// Ideia de aprendizado
  learning,
  
  /// Ideia de criatividade
  creative,
  
  /// Ideia de solução de problema
  problemSolving,
  
  /// Ideia de melhoria de processo
  processImprovement,
  
  /// Ideia de produto
  product,
  
  /// Ideia de serviço
  service,
  
  /// Outra categoria
  other,
}

/// Extensão para obter o nome e a descrição da categoria de ideia
extension IdeaCategoryExtension on IdeaCategory {
  /// Retorna o nome da categoria de ideia
  String get name {
    switch (this) {
      case IdeaCategory.personal:
        return 'Projeto Pessoal';
      case IdeaCategory.professional:
        return 'Projeto Profissional';
      case IdeaCategory.learning:
        return 'Aprendizado';
      case IdeaCategory.creative:
        return 'Criatividade';
      case IdeaCategory.problemSolving:
        return 'Solução de Problema';
      case IdeaCategory.processImprovement:
        return 'Melhoria de Processo';
      case IdeaCategory.product:
        return 'Produto';
      case IdeaCategory.service:
        return 'Serviço';
      case IdeaCategory.other:
        return 'Outra';
    }
  }
  
  /// Retorna o ícone da categoria de ideia
  String get icon {
    switch (this) {
      case IdeaCategory.personal:
        return '🏠';
      case IdeaCategory.professional:
        return '💼';
      case IdeaCategory.learning:
        return '📚';
      case IdeaCategory.creative:
        return '🎨';
      case IdeaCategory.problemSolving:
        return '🔧';
      case IdeaCategory.processImprovement:
        return '📈';
      case IdeaCategory.product:
        return '📦';
      case IdeaCategory.service:
        return '🛎️';
      case IdeaCategory.other:
        return '💡';
    }
  }
}

/// Status de uma ideia
enum IdeaStatus {
  /// Ideia capturada
  captured,
  
  /// Ideia em desenvolvimento
  inDevelopment,
  
  /// Ideia implementada
  implemented,
  
  /// Ideia arquivada
  archived,
}

/// Extensão para obter o nome e a descrição do status de ideia
extension IdeaStatusExtension on IdeaStatus {
  /// Retorna o nome do status de ideia
  String get name {
    switch (this) {
      case IdeaStatus.captured:
        return 'Capturada';
      case IdeaStatus.inDevelopment:
        return 'Em Desenvolvimento';
      case IdeaStatus.implemented:
        return 'Implementada';
      case IdeaStatus.archived:
        return 'Arquivada';
    }
  }
  
  /// Retorna a cor do status de ideia
  int get color {
    switch (this) {
      case IdeaStatus.captured:
        return 0xFF9E9E9E; // Cinza
      case IdeaStatus.inDevelopment:
        return 0xFF2196F3; // Azul
      case IdeaStatus.implemented:
        return 0xFF4CAF50; // Verde
      case IdeaStatus.archived:
        return 0xFF607D8B; // Azul acinzentado
    }
  }
}

/// Entidade que representa uma ideia capturada durante o ócio criativo
class IdeaEntity {
  /// Identificador único da ideia
  final String id;
  
  /// Título da ideia
  final String title;
  
  /// Descrição da ideia
  final String description;
  
  /// Data e hora da captura
  final DateTime captureDate;
  
  /// Categoria da ideia
  final IdeaCategory category;
  
  /// Status da ideia
  final IdeaStatus status;
  
  /// Tags associadas à ideia
  final List<String> tags;
  
  /// Notas adicionais
  final String? notes;
  
  /// Próximos passos
  final String? nextSteps;
  
  /// Recursos necessários
  final String? resources;
  
  /// Projeto associado à ideia
  final String? projectId;
  
  /// Tarefa associada à ideia
  final String? taskId;
  
  /// Construtor
  IdeaEntity({
    String? id,
    required this.title,
    required this.description,
    DateTime? captureDate,
    this.category = IdeaCategory.other,
    this.status = IdeaStatus.captured,
    List<String>? tags,
    this.notes,
    this.nextSteps,
    this.resources,
    this.projectId,
    this.taskId,
  })  : id = id ?? const Uuid().v4(),
        captureDate = captureDate ?? DateTime.now(),
        tags = tags ?? [];
  
  /// Cria uma cópia da ideia com os campos atualizados
  IdeaEntity copyWith({
    String? title,
    String? description,
    IdeaCategory? category,
    IdeaStatus? status,
    List<String>? tags,
    String? notes,
    String? nextSteps,
    String? resources,
    String? projectId,
    String? taskId,
  }) {
    return IdeaEntity(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      captureDate: captureDate,
      category: category ?? this.category,
      status: status ?? this.status,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      nextSteps: nextSteps ?? this.nextSteps,
      resources: resources ?? this.resources,
      projectId: projectId ?? this.projectId,
      taskId: taskId ?? this.taskId,
    );
  }
  
  /// Adiciona uma tag à ideia
  IdeaEntity addTag(String tag) {
    if (!tags.contains(tag)) {
      final newTags = List<String>.from(tags)..add(tag);
      return copyWith(tags: newTags);
    }
    return this;
  }
  
  /// Remove uma tag da ideia
  IdeaEntity removeTag(String tag) {
    if (tags.contains(tag)) {
      final newTags = List<String>.from(tags)..remove(tag);
      return copyWith(tags: newTags);
    }
    return this;
  }
  
  /// Converte a ideia para uma tarefa
  Map<String, dynamic> toTask() {
    return {
      'title': title,
      'description': description,
      'tags': tags,
      'projectId': projectId,
    };
  }
  
  /// Converte a ideia para um projeto
  Map<String, dynamic> toProject() {
    return {
      'name': title,
      'description': description,
      'tags': tags,
    };
  }
}
