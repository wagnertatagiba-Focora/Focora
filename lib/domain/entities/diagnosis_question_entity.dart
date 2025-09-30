import 'package:focora/domain/entities/diagnosis_entity.dart';

/// Entidade que representa uma pergunta do diagnóstico de procrastinação
class DiagnosisQuestionEntity {
  /// Identificador único da pergunta
  final String id;
  
  /// Texto da pergunta
  final String question;
  
  /// Opções de resposta
  final List<DiagnosisAnswerOption> options;
  
  /// Construtor
  DiagnosisQuestionEntity({
    required this.id,
    required this.question,
    required this.options,
  });
}

/// Classe que representa uma opção de resposta para uma pergunta de diagnóstico
class DiagnosisAnswerOption {
  /// Texto da opção de resposta
  final String text;
  
  /// Pontuação para cada tipo de procrastinador
  final Map<ProcrastinatorType, int> scores;
  
  /// Construtor
  DiagnosisAnswerOption({
    required this.text,
    required this.scores,
  });
}

/// Lista de perguntas para o diagnóstico de procrastinação
final List<DiagnosisQuestionEntity> diagnosisQuestions = [
  DiagnosisQuestionEntity(
    id: 'q1',
    question: 'Quando você adia uma tarefa importante, geralmente é porque:',
    options: [
      DiagnosisAnswerOption(
        text: 'Quer fazê-la perfeitamente e teme não conseguir',
        scores: {
          ProcrastinatorType.perfectionist: 3,
          ProcrastinatorType.worrier: 2,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.overloader: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Tem muitas outras coisas para fazer e se sente sobrecarregado',
        scores: {
          ProcrastinatorType.overloader: 3,
          ProcrastinatorType.worrier: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'A tarefa parece entediante ou desinteressante',
        scores: {
          ProcrastinatorType.bored: 3,
          ProcrastinatorType.challenger: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.worrier: 0,
          ProcrastinatorType.overloader: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Prefere pensar e planejar antes de agir',
        scores: {
          ProcrastinatorType.dreamer: 3,
          ProcrastinatorType.perfectionist: 1,
          ProcrastinatorType.worrier: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.overloader: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
    ],
  ),
  DiagnosisQuestionEntity(
    id: 'q2',
    question: 'Como você geralmente se sente quando está procrastinando?',
    options: [
      DiagnosisAnswerOption(
        text: 'Ansioso e preocupado com possíveis falhas',
        scores: {
          ProcrastinatorType.worrier: 3,
          ProcrastinatorType.perfectionist: 1,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.overloader: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Entediado e em busca de algo mais estimulante',
        scores: {
          ProcrastinatorType.bored: 3,
          ProcrastinatorType.challenger: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.worrier: 0,
          ProcrastinatorType.overloader: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Sobrecarregado e sem saber por onde começar',
        scores: {
          ProcrastinatorType.overloader: 3,
          ProcrastinatorType.worrier: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Calmo, pois trabalha melhor sob pressão',
        scores: {
          ProcrastinatorType.challenger: 3,
          ProcrastinatorType.dreamer: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.worrier: 0,
          ProcrastinatorType.overloader: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
    ],
  ),
  DiagnosisQuestionEntity(
    id: 'q3',
    question: 'Qual destas situações mais te impede de concluir tarefas?',
    options: [
      DiagnosisAnswerOption(
        text: 'Ficar revisando e aperfeiçoando o trabalho repetidamente',
        scores: {
          ProcrastinatorType.perfectionist: 3,
          ProcrastinatorType.worrier: 1,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.overloader: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Ter muitas ideias, mas dificuldade em executá-las',
        scores: {
          ProcrastinatorType.dreamer: 3,
          ProcrastinatorType.perfectionist: 1,
          ProcrastinatorType.worrier: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.overloader: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Não sentir urgência até que o prazo esteja muito próximo',
        scores: {
          ProcrastinatorType.challenger: 3,
          ProcrastinatorType.bored: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.worrier: 0,
          ProcrastinatorType.overloader: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Ter tantas responsabilidades que fica difícil priorizar',
        scores: {
          ProcrastinatorType.overloader: 3,
          ProcrastinatorType.worrier: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
    ],
  ),
  DiagnosisQuestionEntity(
    id: 'q4',
    question: 'Quando você finalmente começa uma tarefa adiada, geralmente:',
    options: [
      DiagnosisAnswerOption(
        text: 'Trabalha intensamente sob pressão e consegue terminar no prazo',
        scores: {
          ProcrastinatorType.challenger: 3,
          ProcrastinatorType.dreamer: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.worrier: 0,
          ProcrastinatorType.overloader: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Perde interesse rapidamente e busca algo mais estimulante',
        scores: {
          ProcrastinatorType.bored: 3,
          ProcrastinatorType.dreamer: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.worrier: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.overloader: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Preocupa-se excessivamente se está fazendo corretamente',
        scores: {
          ProcrastinatorType.worrier: 3,
          ProcrastinatorType.perfectionist: 2,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.overloader: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Dedica muito tempo a detalhes para garantir perfeição',
        scores: {
          ProcrastinatorType.perfectionist: 3,
          ProcrastinatorType.worrier: 1,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.overloader: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
    ],
  ),
  DiagnosisQuestionEntity(
    id: 'q5',
    question: 'Qual estratégia você acha que mais te ajudaria a superar a procrastinação?',
    options: [
      DiagnosisAnswerOption(
        text: 'Tornar tarefas monótonas mais interessantes e desafiadoras',
        scores: {
          ProcrastinatorType.bored: 3,
          ProcrastinatorType.challenger: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.worrier: 0,
          ProcrastinatorType.overloader: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Aprender a aceitar que "bom o suficiente" é melhor que perfeito',
        scores: {
          ProcrastinatorType.perfectionist: 3,
          ProcrastinatorType.worrier: 1,
          ProcrastinatorType.dreamer: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.overloader: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Ter um sistema para organizar e priorizar múltiplas tarefas',
        scores: {
          ProcrastinatorType.overloader: 3,
          ProcrastinatorType.dreamer: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.worrier: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
      DiagnosisAnswerOption(
        text: 'Transformar ideias em planos de ação concretos e detalhados',
        scores: {
          ProcrastinatorType.dreamer: 3,
          ProcrastinatorType.overloader: 1,
          ProcrastinatorType.perfectionist: 0,
          ProcrastinatorType.worrier: 0,
          ProcrastinatorType.challenger: 0,
          ProcrastinatorType.bored: 0,
        },
      ),
    ],
  ),
];
