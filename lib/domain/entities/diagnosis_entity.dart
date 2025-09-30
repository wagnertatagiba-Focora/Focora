/// Entidade que representa o diagnóstico de procrastinação do usuário
class DiagnosisEntity {
  /// Identificador único do diagnóstico
  final String id;
  
  /// Tipo principal de procrastinador
  final String primaryType;
  
  /// Tipo secundário de procrastinador (opcional)
  final String? secondaryType;
  
  /// Pontuação para cada tipo de procrastinador
  final Map<String, int> scores;
  
  /// Data em que o diagnóstico foi realizado
  final DateTime date;
  
  /// Recomendações personalizadas baseadas no perfil
  final List<String> recommendations;

  /// Construtor
  DiagnosisEntity({
    required this.id,
    required this.primaryType,
    this.secondaryType,
    required this.scores,
    required this.date,
    required this.recommendations,
  });
}

/// Enum que representa os tipos de procrastinador
enum ProcrastinatorType {
  /// Perfeccionista: Adia tarefas por medo de não atingir padrões elevados
  perfectionist,
  
  /// Sonhador: Tem muitas ideias, mas dificuldade em executá-las
  dreamer,
  
  /// Preocupado: Procrastina por ansiedade e medo de falhar
  worrier,
  
  /// Desafiador: Precisa de pressão para agir, como prazos apertados
  challenger,
  
  /// Sobrecarga: Tem muitas tarefas e não sabe por onde começar
  overloader,
  
  /// Entediado: Procrastina tarefas que considera monótonas ou desinteressantes
  bored,
}

/// Extensão para obter o nome em português do tipo de procrastinador
extension ProcrastinatorTypeExtension on ProcrastinatorType {
  String get name {
    switch (this) {
      case ProcrastinatorType.perfectionist:
        return 'Perfeccionista';
      case ProcrastinatorType.dreamer:
        return 'Sonhador';
      case ProcrastinatorType.worrier:
        return 'Preocupado';
      case ProcrastinatorType.challenger:
        return 'Desafiador';
      case ProcrastinatorType.overloader:
        return 'Sobrecarga';
      case ProcrastinatorType.bored:
        return 'Entediado';
    }
  }
  
  String get description {
    switch (this) {
      case ProcrastinatorType.perfectionist:
        return 'Você adia tarefas por medo de não atingir padrões elevados. Busca a perfeição e tem dificuldade em considerar algo como "bom o suficiente".';
      case ProcrastinatorType.dreamer:
        return 'Você tem muitas ideias, mas dificuldade em transformá-las em ações concretas. Prefere planejar e imaginar do que executar.';
      case ProcrastinatorType.worrier:
        return 'Você procrastina por ansiedade e medo de falhar. Preocupa-se excessivamente com possíveis problemas e consequências negativas.';
      case ProcrastinatorType.challenger:
        return 'Você precisa de pressão para agir, como prazos apertados. Sente-se motivado pela adrenalina de fazer as coisas no último minuto.';
      case ProcrastinatorType.overloader:
        return 'Você tem muitas tarefas e não sabe por onde começar. Sente-se sobrecarregado e paralisa diante de muitas responsabilidades.';
      case ProcrastinatorType.bored:
        return 'Você procrastina tarefas que considera monótonas ou desinteressantes. Busca constantemente estímulos e novidades.';
    }
  }
  
  List<String> get recommendations {
    switch (this) {
      case ProcrastinatorType.perfectionist:
        return [
          'Defina padrões realistas antes de começar',
          'Use o timer Pomodoro para limitar o tempo de cada tarefa',
          'Pratique entregar versões "boas o suficiente" e depois refinar',
          'Celebre o progresso, não apenas o resultado final perfeito',
        ];
      case ProcrastinatorType.dreamer:
        return [
          'Divida ideias grandes em passos concretos e acionáveis',
          'Estabeleça prazos para cada etapa do processo',
          'Use a técnica do "próximo passo mínimo" para começar',
          'Mantenha um diário de ações realizadas, não apenas de ideias',
        ];
      case ProcrastinatorType.worrier:
        return [
          'Pratique a técnica dos "5 Porquês" para identificar medos reais',
          'Crie um plano B para aliviar a ansiedade sobre possíveis falhas',
          'Use o diário de pensamentos para desafiar crenças limitantes',
          'Comece com tarefas menores para construir confiança',
        ];
      case ProcrastinatorType.challenger:
        return [
          'Crie prazos artificiais antes dos prazos reais',
          'Divida projetos grandes em múltiplos "mini-prazos"',
          'Use a técnica Pomodoro para criar urgência em pequenos intervalos',
          'Encontre um parceiro de responsabilidade para check-ins regulares',
        ];
      case ProcrastinatorType.overloader:
        return [
          'Use a Matriz de Eisenhower para priorizar tarefas',
          'Pratique dizer "não" a novas responsabilidades',
          'Foque em apenas 1-3 tarefas importantes por dia',
          'Faça uma revisão semanal para organizar todas as responsabilidades',
        ];
      case ProcrastinatorType.bored:
        return [
          'Torne tarefas monótonas mais interessantes com gamificação',
          'Alterne entre diferentes tipos de tarefas para manter o interesse',
          'Use a técnica Pomodoro com intervalos frequentes',
          'Conecte tarefas entediantes a objetivos maiores e significativos',
        ];
    }
  }
}
