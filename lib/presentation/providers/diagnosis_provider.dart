import 'package:flutter/foundation.dart';
import 'package:focora/domain/entities/diagnosis_entity.dart';
import 'package:focora/domain/entities/diagnosis_question_entity.dart';
import 'package:focora/data/repositories/diagnosis_repository.dart';

/// Provider para gerenciar o estado do diagnóstico de procrastinação
class DiagnosisProvider with ChangeNotifier {
  /// Repositório de diagnósticos
  final DiagnosisRepository _repository;
  
  /// Lista de perguntas do diagnóstico
  final List<DiagnosisQuestionEntity> _questions = diagnosisQuestions;
  
  /// Índice da pergunta atual
  int _currentQuestionIndex = 0;
  
  /// Respostas selecionadas pelo usuário
  final Map<String, DiagnosisAnswerOption> _selectedAnswers = {};
  
  /// Resultado do diagnóstico
  DiagnosisEntity? _diagnosisResult;
  
  /// Construtor
  DiagnosisProvider(this._repository) {
    loadDiagnosis();
  }
  
  /// Retorna a lista de perguntas
  List<DiagnosisQuestionEntity> get questions => _questions;
  
  /// Retorna a pergunta atual
  DiagnosisQuestionEntity get currentQuestion => _questions[_currentQuestionIndex];
  
  /// Retorna o índice da pergunta atual
  int get currentQuestionIndex => _currentQuestionIndex;
  
  /// Retorna o total de perguntas
  int get totalQuestions => _questions.length;
  
  /// Retorna se há uma próxima pergunta
  bool get hasNextQuestion => _currentQuestionIndex < _questions.length - 1;
  
  /// Retorna se há uma pergunta anterior
  bool get hasPreviousQuestion => _currentQuestionIndex > 0;
  
  /// Retorna o resultado do diagnóstico
  DiagnosisEntity? get diagnosisResult => _diagnosisResult;
  
  /// Retorna se o diagnóstico foi concluído
  bool get isDiagnosisCompleted => _diagnosisResult != null;
  
  /// Retorna a resposta selecionada para a pergunta atual
  DiagnosisAnswerOption? getSelectedAnswer(String questionId) {
    return _selectedAnswers[questionId];
  }
  
  /// Carrega o diagnóstico mais recente do repositório
  Future<void> loadDiagnosis() async {
    _diagnosisResult = _repository.getLatestDiagnosis();
    notifyListeners();
  }
  
  /// Seleciona uma resposta para a pergunta atual
  void selectAnswer(DiagnosisAnswerOption answer) {
    _selectedAnswers[currentQuestion.id] = answer;
    notifyListeners();
  }
  
  /// Avança para a próxima pergunta
  void nextQuestion() {
    if (hasNextQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    } else {
      // Se não houver mais perguntas, calcula o resultado
      _calculateDiagnosisResult();
    }
  }
  
  /// Volta para a pergunta anterior
  void previousQuestion() {
    if (hasPreviousQuestion) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }
  
  /// Calcula o resultado do diagnóstico
  Future<void> _calculateDiagnosisResult() async {
    // Inicializa os scores para cada tipo de procrastinador
    final Map<ProcrastinatorType, int> scores = {
      for (var type in ProcrastinatorType.values) type: 0,
    };
    
    // Soma os scores de cada resposta selecionada
    for (var entry in _selectedAnswers.entries) {
      final answer = entry.value;
      for (var scoreEntry in answer.scores.entries) {
        scores[scoreEntry.key] = (scores[scoreEntry.key] ?? 0) + scoreEntry.value;
      }
    }
    
    // Encontra o tipo com maior pontuação
    ProcrastinatorType primaryType = ProcrastinatorType.values.first;
    int highestScore = 0;
    
    for (var entry in scores.entries) {
      if (entry.value > highestScore) {
        highestScore = entry.value;
        primaryType = entry.key;
      }
    }
    
    // Cria o resultado do diagnóstico
    final result = DiagnosisEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      primaryType: primaryType.name,
      scores: {
        for (var entry in scores.entries) entry.key.name: entry.value,
      },
      date: DateTime.now(),
      recommendations: primaryType.recommendations,
    );
    
    // Salva o resultado no repositório
    await _repository.addDiagnosis(result);
    
    // Atualiza o estado
    _diagnosisResult = result;
    notifyListeners();
  }
  
  /// Reinicia o diagnóstico
  void resetDiagnosis() {
    _currentQuestionIndex = 0;
    _selectedAnswers.clear();
    _diagnosisResult = null;
    notifyListeners();
  }
}
