import 'package:flutter/material.dart';
import 'package:focora/app/routes.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/domain/entities/diagnosis_entity.dart';
import 'package:focora/presentation/providers/diagnosis_provider.dart';
import 'package:provider/provider.dart';

/// Tela de resultado do diagnóstico de procrastinação
class DiagnosisResultScreen extends StatelessWidget {
  const DiagnosisResultScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final diagnosisProvider = Provider.of<DiagnosisProvider>(context);
    final diagnosisResult = diagnosisProvider.diagnosisResult;
    
    if (diagnosisResult == null) {
      // Se não houver resultado, redireciona para a tela de diagnóstico
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Nenhum resultado de diagnóstico encontrado.'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.onboarding,
                  );
                },
                child: const Text('Fazer diagnóstico'),
              ),
            ],
          ),
        ),
      );
    }
    
    // Encontra o tipo de procrastinador correspondente
    final primaryType = ProcrastinatorType.values.firstWhere(
      (type) => type.name == diagnosisResult.primaryType,
      orElse: () => ProcrastinatorType.perfectionist,
    );
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seu Perfil'),
        backgroundColor: FocoraTheme.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cabeçalho
            const Center(
              child: Text(
                'Seu Perfil de Procrastinação',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: FocoraTheme.primaryColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            
            // Tipo principal
            _buildProfileCard(
              context,
              title: 'Seu tipo principal é:',
              content: primaryType.name,
              description: primaryType.description,
              icon: _getIconForType(primaryType),
              color: FocoraTheme.secondaryColor,
            ),
            const SizedBox(height: 24),
            
            // Recomendações
            _buildRecommendationsCard(
              context,
              recommendations: diagnosisResult.recommendations,
            ),
            const SizedBox(height: 24),
            
            // Gráfico de pontuação (simplificado)
            _buildScoresCard(context, scores: diagnosisResult.scores),
            const SizedBox(height: 32),
            
            // Botão para continuar
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    AppRoutes.dashboard,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  backgroundColor: FocoraTheme.secondaryColor,
                ),
                child: const Text(
                  'Começar a usar o Focora',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Retorna o ícone correspondente ao tipo de procrastinador
  IconData _getIconForType(ProcrastinatorType type) {
    switch (type) {
      case ProcrastinatorType.perfectionist:
        return Icons.star;
      case ProcrastinatorType.dreamer:
        return Icons.cloud;
      case ProcrastinatorType.worrier:
        return Icons.warning_amber;
      case ProcrastinatorType.challenger:
        return Icons.timer;
      case ProcrastinatorType.overloader:
        return Icons.layers;
      case ProcrastinatorType.bored:
        return Icons.mood_bad;
    }
  }
  
  /// Constrói o cartão do perfil principal
  Widget _buildProfileCard(
    BuildContext context, {
    required String title,
    required String content,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
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
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: FocoraTheme.textSecondaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  content,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
  
  /// Constrói o cartão de recomendações
  Widget _buildRecommendationsCard(
    BuildContext context, {
    required List<String> recommendations,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb,
                  color: FocoraTheme.tertiaryColor,
                ),
                const SizedBox(width: 8),
                Text(
                  'Recomendações para você',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: FocoraTheme.tertiaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...recommendations.map((recommendation) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 20,
                    color: FocoraTheme.accentColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(recommendation),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
  
  /// Constrói o cartão de pontuações
  Widget _buildScoresCard(
    BuildContext context, {
    required Map<String, int> scores,
  }) {
    // Ordena os tipos por pontuação
    final sortedScores = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    return Card(
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
              'Sua pontuação por tipo',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            ...sortedScores.map((entry) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: entry.value / 15, // Valor máximo possível é 15
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _getColorForScore(entry.value),
                    ),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
  
  /// Retorna a cor correspondente à pontuação
  Color _getColorForScore(int score) {
    if (score >= 10) {
      return FocoraTheme.secondaryColor;
    } else if (score >= 5) {
      return FocoraTheme.accentColor;
    } else {
      return FocoraTheme.textTertiaryColor;
    }
  }
}
