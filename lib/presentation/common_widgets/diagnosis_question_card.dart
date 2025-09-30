import 'package:flutter/material.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/domain/entities/diagnosis_question_entity.dart';
import 'package:focora/presentation/providers/diagnosis_provider.dart';
import 'package:provider/provider.dart';

/// Widget que exibe uma pergunta do diagnóstico de procrastinação
class DiagnosisQuestionCard extends StatelessWidget {
  /// Pergunta a ser exibida
  final DiagnosisQuestionEntity question;
  
  /// Construtor
  const DiagnosisQuestionCard({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    final diagnosisProvider = Provider.of<DiagnosisProvider>(context);
    final selectedAnswer = diagnosisProvider.getSelectedAnswer(question.id);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.question,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...question.options.map((option) => _buildOptionItem(
              context,
              option,
              isSelected: selectedAnswer == option,
              onTap: () => diagnosisProvider.selectAnswer(option),
            )),
          ],
        ),
      ),
    );
  }
  
  /// Constrói um item de opção de resposta
  Widget _buildOptionItem(
    BuildContext context,
    DiagnosisAnswerOption option,
    {
      required bool isSelected,
      required VoidCallback onTap,
    }
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? FocoraTheme.secondaryColor : Colors.grey.shade300,
              width: 2,
            ),
            color: isSelected ? FocoraTheme.secondaryColor.withOpacity(0.1) : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option.text,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? FocoraTheme.secondaryColor : null,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? FocoraTheme.secondaryColor : Colors.grey.shade400,
                    width: 2,
                  ),
                  color: isSelected ? FocoraTheme.secondaryColor : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 16,
                        color: Colors.white,
                      )
                    : null,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
