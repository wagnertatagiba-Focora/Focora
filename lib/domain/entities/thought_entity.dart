import 'package:uuid/uuid.dart';

/// Tipos de distorções cognitivas
enum CognitiveDistortion {
  /// Pensamento de tudo ou nada
  allOrNothing,
  
  /// Generalização excessiva
  overgeneralization,
  
  /// Filtro mental
  mentalFilter,
  
  /// Desqualificação do positivo
  disqualifyingPositive,
  
  /// Conclusões precipitadas
  jumpingToConclusions,
  
  /// Ampliação ou minimização
  magnificationOrMinimization,
  
  /// Raciocínio emocional
  emotionalReasoning,
  
  /// Afirmações de "deveria"
  shouldStatements,
  
  /// Rotulação
  labeling,
  
  /// Personalização
  personalization,
  
  /// Procrastinação como evitação
  avoidance,
  
  /// Nenhuma distorção identificada
  none,
}

/// Extensão para obter o nome e a descrição da distorção cognitiva
extension CognitiveDistortionExtension on CognitiveDistortion {
  /// Retorna o nome da distorção cognitiva
  String get name {
    switch (this) {
      case CognitiveDistortion.allOrNothing:
        return 'Pensamento de tudo ou nada';
      case CognitiveDistortion.overgeneralization:
        return 'Generalização excessiva';
      case CognitiveDistortion.mentalFilter:
        return 'Filtro mental';
      case CognitiveDistortion.disqualifyingPositive:
        return 'Desqualificação do positivo';
      case CognitiveDistortion.jumpingToConclusions:
        return 'Conclusões precipitadas';
      case CognitiveDistortion.magnificationOrMinimization:
        return 'Ampliação ou minimização';
      case CognitiveDistortion.emotionalReasoning:
        return 'Raciocínio emocional';
      case CognitiveDistortion.shouldStatements:
        return 'Afirmações de "deveria"';
      case CognitiveDistortion.labeling:
        return 'Rotulação';
      case CognitiveDistortion.personalization:
        return 'Personalização';
      case CognitiveDistortion.avoidance:
        return 'Procrastinação como evitação';
      case CognitiveDistortion.none:
        return 'Nenhuma distorção identificada';
    }
  }
  
  /// Retorna a descrição da distorção cognitiva
  String get description {
    switch (this) {
      case CognitiveDistortion.allOrNothing:
        return 'Ver as situações em termos absolutos, preto ou branco, sem meio-termo.';
      case CognitiveDistortion.overgeneralization:
        return 'Tirar uma conclusão geral a partir de um único incidente ou evidência.';
      case CognitiveDistortion.mentalFilter:
        return 'Focar exclusivamente nos detalhes negativos e ignorar os aspectos positivos.';
      case CognitiveDistortion.disqualifyingPositive:
        return 'Rejeitar experiências positivas insistindo que "não contam".';
      case CognitiveDistortion.jumpingToConclusions:
        return 'Fazer interpretações negativas sem fatos definitivos para apoiá-las.';
      case CognitiveDistortion.magnificationOrMinimization:
        return 'Exagerar a importância de problemas ou minimizar qualidades.';
      case CognitiveDistortion.emotionalReasoning:
        return 'Assumir que sentimentos negativos refletem a realidade.';
      case CognitiveDistortion.shouldStatements:
        return 'Ter regras rígidas sobre como você ou outros "deveriam" agir.';
      case CognitiveDistortion.labeling:
        return 'Atribuir rótulos globais a si mesmo ou aos outros em vez de descrever comportamentos específicos.';
      case CognitiveDistortion.personalization:
        return 'Assumir responsabilidade por eventos externos que estão fora do seu controle.';
      case CognitiveDistortion.avoidance:
        return 'Adiar tarefas para evitar desconforto emocional ou medo de falhar.';
      case CognitiveDistortion.none:
        return 'Não foi identificada nenhuma distorção cognitiva neste pensamento.';
    }
  }
  
  /// Retorna uma sugestão para lidar com a distorção cognitiva
  String get suggestion {
    switch (this) {
      case CognitiveDistortion.allOrNothing:
        return 'Procure os tons de cinza na situação. Raramente as coisas são completamente boas ou ruins.';
      case CognitiveDistortion.overgeneralization:
        return 'Questione se você está usando palavras como "sempre" ou "nunca". Busque contra-exemplos.';
      case CognitiveDistortion.mentalFilter:
        return 'Faça um esforço consciente para reconhecer aspectos positivos da situação.';
      case CognitiveDistortion.disqualifyingPositive:
        return 'Pratique aceitar elogios e reconhecer suas conquistas, por menores que sejam.';
      case CognitiveDistortion.jumpingToConclusions:
        return 'Pergunte-se: "Quais são as evidências para essa conclusão? Existem outras explicações possíveis?"';
      case CognitiveDistortion.magnificationOrMinimization:
        return 'Avalie a situação em uma escala de 0 a 10 para obter uma perspectiva mais realista.';
      case CognitiveDistortion.emotionalReasoning:
        return 'Lembre-se que sentimentos não são fatos. Separe o que você sente do que é objetivamente verdadeiro.';
      case CognitiveDistortion.shouldStatements:
        return 'Substitua "deveria" por "preferiria" ou "seria bom se". Aceite que nem tudo é perfeito.';
      case CognitiveDistortion.labeling:
        return 'Descreva comportamentos específicos em vez de rotular a pessoa ou situação.';
      case CognitiveDistortion.personalization:
        return 'Pergunte-se: "Isso está realmente sob meu controle? Quais outros fatores estão envolvidos?"';
      case CognitiveDistortion.avoidance:
        return 'Use a técnica Pomodoro para começar com apenas 5 minutos na tarefa que está evitando.';
      case CognitiveDistortion.none:
        return 'Continue observando seus pensamentos e identificando padrões que possam surgir.';
    }
  }
}

/// Entidade que representa um pensamento registrado pelo usuário
class ThoughtEntity {
  /// Identificador único do pensamento
  final String id;
  
  /// Conteúdo do pensamento
  final String content;
  
  /// Data e hora do registro
  final DateTime date;
  
  /// Situação que desencadeou o pensamento
  final String? situation;
  
  /// Emoções associadas ao pensamento
  final List<String> emotions;
  
  /// Intensidade da emoção (1-10)
  final int emotionIntensity;
  
  /// Distorções cognitivas identificadas
  final List<CognitiveDistortion> distortions;
  
  /// Pensamento alternativo mais equilibrado
  final String? alternativeThought;
  
  /// Resultado após a reflexão
  final String? outcome;
  
  /// Tarefa associada ao pensamento
  final String? taskId;
  
  /// Construtor
  ThoughtEntity({
    String? id,
    required this.content,
    DateTime? date,
    this.situation,
    List<String>? emotions,
    this.emotionIntensity = 5,
    List<CognitiveDistortion>? distortions,
    this.alternativeThought,
    this.outcome,
    this.taskId,
  })  : id = id ?? const Uuid().v4(),
        date = date ?? DateTime.now(),
        emotions = emotions ?? [],
        distortions = distortions ?? [];
  
  /// Cria uma cópia do pensamento com os campos atualizados
  ThoughtEntity copyWith({
    String? content,
    String? situation,
    List<String>? emotions,
    int? emotionIntensity,
    List<CognitiveDistortion>? distortions,
    String? alternativeThought,
    String? outcome,
    String? taskId,
  }) {
    return ThoughtEntity(
      id: id,
      content: content ?? this.content,
      date: date,
      situation: situation ?? this.situation,
      emotions: emotions ?? this.emotions,
      emotionIntensity: emotionIntensity ?? this.emotionIntensity,
      distortions: distortions ?? this.distortions,
      alternativeThought: alternativeThought ?? this.alternativeThought,
      outcome: outcome ?? this.outcome,
      taskId: taskId ?? this.taskId,
    );
  }
  
  /// Adiciona uma distorção cognitiva ao pensamento
  ThoughtEntity addDistortion(CognitiveDistortion distortion) {
    if (!distortions.contains(distortion)) {
      final newDistortions = List<CognitiveDistortion>.from(distortions)..add(distortion);
      return copyWith(distortions: newDistortions);
    }
    return this;
  }
  
  /// Remove uma distorção cognitiva do pensamento
  ThoughtEntity removeDistortion(CognitiveDistortion distortion) {
    if (distortions.contains(distortion)) {
      final newDistortions = List<CognitiveDistortion>.from(distortions)..remove(distortion);
      return copyWith(distortions: newDistortions);
    }
    return this;
  }
  
  /// Adiciona uma emoção ao pensamento
  ThoughtEntity addEmotion(String emotion) {
    if (!emotions.contains(emotion)) {
      final newEmotions = List<String>.from(emotions)..add(emotion);
      return copyWith(emotions: newEmotions);
    }
    return this;
  }
  
  /// Remove uma emoção do pensamento
  ThoughtEntity removeEmotion(String emotion) {
    if (emotions.contains(emotion)) {
      final newEmotions = List<String>.from(emotions)..remove(emotion);
      return copyWith(emotions: newEmotions);
    }
    return this;
  }
}
