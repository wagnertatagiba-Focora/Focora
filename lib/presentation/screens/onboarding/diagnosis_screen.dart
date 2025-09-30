import 'package:flutter/material.dart';
import 'package:focora/app/routes.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/presentation/common_widgets/diagnosis_question_card.dart';
import 'package:focora/presentation/providers/diagnosis_provider.dart';
import 'package:focora/data/repositories/diagnosis_repository.dart';
import 'package:focora/core/services/service_locator.dart';
import 'package:provider/provider.dart';

/// Tela de diagnóstico de procrastinação
class DiagnosisScreen extends StatelessWidget {
  const DiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DiagnosisProvider(serviceLocator<DiagnosisRepository>()),
      child: const _DiagnosisScreenContent(),
    );
  }
}

class _DiagnosisScreenContent extends StatelessWidget {
  const _DiagnosisScreenContent();

  @override
  Widget build(BuildContext context) {
    final diagnosisProvider = Provider.of<DiagnosisProvider>(context);
    final currentQuestion = diagnosisProvider.currentQuestion;
    final currentIndex = diagnosisProvider.currentQuestionIndex;
    final totalQuestions = diagnosisProvider.totalQuestions;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnóstico'),
        backgroundColor: FocoraTheme.primaryColor,
      ),
      body: Column(
        children: [
          // Barra de progresso
          LinearProgressIndicator(
            value: (currentIndex + 1) / totalQuestions,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(FocoraTheme.secondaryColor),
            minHeight: 6,
          ),
          
          // Contador de perguntas
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pergunta ${currentIndex + 1} de $totalQuestions',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FocoraTheme.textSecondaryColor,
                  ),
                ),
                Text(
                  '${((currentIndex + 1) / totalQuestions * 100).toInt()}%',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: FocoraTheme.secondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          
          // Pergunta atual
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Column(
                children: [
                  // Título da seção
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Vamos descobrir seu perfil de procrastinação',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Responda com sinceridade para obter recomendações personalizadas',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: FocoraTheme.textSecondaryColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Cartão da pergunta
                  DiagnosisQuestionCard(question: currentQuestion),
                ],
              ),
            ),
          ),
          
          // Botões de navegação
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botão Voltar
                if (diagnosisProvider.hasPreviousQuestion)
                  OutlinedButton(
                    onPressed: diagnosisProvider.previousQuestion,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text('Voltar'),
                  )
                else
                  const SizedBox(width: 80),
                
                // Botão Próximo ou Concluir
                ElevatedButton(
                  onPressed: diagnosisProvider.getSelectedAnswer(currentQuestion.id) != null
                      ? () {
                          if (diagnosisProvider.hasNextQuestion) {
                            diagnosisProvider.nextQuestion();
                          } else {
                            diagnosisProvider.nextQuestion();
                            // Navegar para a tela de resultado
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.dashboard,
                            );
                          }
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text(
                    diagnosisProvider.hasNextQuestion ? 'Próximo' : 'Concluir',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
