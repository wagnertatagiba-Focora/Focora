import 'package:flutter/material.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/domain/entities/thought_entity.dart';
import 'package:focora/presentation/providers/thought_provider.dart';
import 'package:provider/provider.dart';

/// Tela do Coach Cognitivo
class CoachScreen extends StatefulWidget {
  /// Construtor
  const CoachScreen({super.key});

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> with SingleTickerProviderStateMixin {
  /// Controlador das abas
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coach Cognitivo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Diário'),
            Tab(text: 'Insights'),
            Tab(text: 'Técnicas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _ThoughtJournalTab(),
          _InsightsTab(),
          _TechniquesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddThoughtDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
  
  /// Exibe o diálogo para adicionar um pensamento
  void _showAddThoughtDialog(BuildContext context) {
    final thoughtController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Registrar Pensamento'),
        content: TextField(
          controller: thoughtController,
          decoration: const InputDecoration(
            hintText: 'O que está passando pela sua mente?',
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              if (thoughtController.text.isNotEmpty) {
                final thoughtProvider = Provider.of<ThoughtProvider>(context, listen: false);
                thoughtProvider.createNewThought(thoughtController.text);
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ThoughtEditorScreen(),
                  ),
                );
              }
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }
}

/// Aba do diário de pensamentos
class _ThoughtJournalTab extends StatelessWidget {
  /// Construtor
  const _ThoughtJournalTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThoughtProvider>(
      builder: (context, thoughtProvider, child) {
        final thoughts = thoughtProvider.recentThoughts;
        
        if (thoughts.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum pensamento registrado ainda.\nToque no botão + para começar.',
              textAlign: TextAlign.center,
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: thoughts.length,
          itemBuilder: (context, index) {
            final thought = thoughts[index];
            return _ThoughtCard(thought: thought);
          },
        );
      },
    );
  }
}

/// Aba de insights
class _InsightsTab extends StatelessWidget {
  /// Construtor
  const _InsightsTab();

  @override
  Widget build(BuildContext context) {
    return Consumer<ThoughtProvider>(
      builder: (context, thoughtProvider, child) {
        final commonDistortions = thoughtProvider.commonDistortions;
        final commonEmotions = thoughtProvider.commonEmotions;
        
        if (commonDistortions.isEmpty && commonEmotions.isEmpty) {
          return const Center(
            child: Text(
              'Registre alguns pensamentos para ver insights sobre seus padrões.',
              textAlign: TextAlign.center,
            ),
          );
        }
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Seus Padrões de Pensamento',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Distorções cognitivas
              if (commonDistortions.isNotEmpty) ...[
                const Text(
                  'Distorções Cognitivas Comuns',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...commonDistortions.take(3).map((entry) => _DistortionCard(
                  distortion: entry.key,
                  count: entry.value,
                )),
                const SizedBox(height: 24),
              ],
              
              // Emoções comuns
              if (commonEmotions.isNotEmpty) ...[
                const Text(
                  'Emoções Frequentes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                ...commonEmotions.take(3).map((entry) => _EmotionCard(
                  emotion: entry.key,
                  count: entry.value,
                )),
              ],
            ],
          ),
        );
      },
    );
  }
}

/// Aba de técnicas
class _TechniquesTab extends StatelessWidget {
  /// Construtor
  const _TechniquesTab();

  @override
  Widget build(BuildContext context) {
    final techniques = [
      {
        'title': 'Técnica dos 5 Porquês',
        'description': 'Pergunte "por quê" cinco vezes para chegar à raiz de um problema ou comportamento.',
        'icon': Icons.question_answer,
      },
      {
        'title': 'Desafio de Pensamentos',
        'description': 'Identifique e questione pensamentos negativos automáticos.',
        'icon': Icons.psychology,
      },
      {
        'title': 'Registro de Distorções',
        'description': 'Identifique distorções cognitivas em seus pensamentos e crie alternativas mais equilibradas.',
        'icon': Icons.balance,
      },
      {
        'title': 'Mindfulness',
        'description': 'Pratique a atenção plena para observar seus pensamentos sem julgamento.',
        'icon': Icons.self_improvement,
      },
      {
        'title': 'Visualização Positiva',
        'description': 'Imagine-se completando tarefas com sucesso para reduzir a ansiedade.',
        'icon': Icons.visibility,
      },
    ];
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: techniques.length,
      itemBuilder: (context, index) {
        final technique = techniques[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Icon(
              technique['icon'] as IconData,
              color: FocoraTheme.primaryColor,
            ),
            title: Text(technique['title'] as String),
            subtitle: Text(technique['description'] as String),
            onTap: () {
              // TODO: Implementar detalhes da técnica
            },
          ),
        );
      },
    );
  }
}

/// Card de pensamento
class _ThoughtCard extends StatelessWidget {
  /// Pensamento
  final ThoughtEntity thought;
  
  /// Construtor
  const _ThoughtCard({required this.thought});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          final thoughtProvider = Provider.of<ThoughtProvider>(context, listen: false);
          thoughtProvider.setCurrentThought(thought);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ThoughtEditorScreen(),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                thought.content,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              if (thought.situation != null) ...[
                Text(
                  'Situação: ${thought.situation}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
              ],
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDate(thought.date),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  if (thought.distortions.isNotEmpty)
                    Text(
                      '${thought.distortions.length} ${thought.distortions.length == 1 ? 'distorção' : 'distorções'}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[700],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Formata a data
  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final thoughtDate = DateTime(date.year, date.month, date.day);
    
    if (thoughtDate == today) {
      return 'Hoje, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (thoughtDate == yesterday) {
      return 'Ontem, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }
}

/// Card de distorção cognitiva
class _DistortionCard extends StatelessWidget {
  /// Distorção cognitiva
  final CognitiveDistortion distortion;
  
  /// Quantidade de ocorrências
  final int count;
  
  /// Construtor
  const _DistortionCard({
    required this.distortion,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    distortion.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: FocoraTheme.secondaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count ${count == 1 ? 'vez' : 'vezes'}',
                    style: TextStyle(
                      fontSize: 12,
                      color: FocoraTheme.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              distortion.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Sugestão: ${distortion.suggestion}',
              style: const TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card de emoção
class _EmotionCard extends StatelessWidget {
  /// Emoção
  final String emotion;
  
  /// Quantidade de ocorrências
  final int count;
  
  /// Construtor
  const _EmotionCard({
    required this.emotion,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              emotion,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: FocoraTheme.accentColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count ${count == 1 ? 'vez' : 'vezes'}',
                style: TextStyle(
                  fontSize: 12,
                  color: FocoraTheme.accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tela de edição de pensamento
class ThoughtEditorScreen extends StatefulWidget {
  /// Construtor
  const ThoughtEditorScreen({super.key});

  @override
  State<ThoughtEditorScreen> createState() => _ThoughtEditorScreenState();
}

class _ThoughtEditorScreenState extends State<ThoughtEditorScreen> {
  /// Controlador do conteúdo do pensamento
  late TextEditingController _contentController;
  
  /// Controlador da situação
  late TextEditingController _situationController;
  
  /// Controlador do pensamento alternativo
  late TextEditingController _alternativeThoughtController;
  
  /// Controlador do resultado
  late TextEditingController _outcomeController;
  
  /// Intensidade da emoção
  int _emotionIntensity = 5;
  
  /// Lista de emoções comuns
  final List<String> _commonEmotions = [
    'Ansiedade',
    'Frustração',
    'Medo',
    'Tristeza',
    'Raiva',
    'Vergonha',
    'Culpa',
    'Insegurança',
    'Desânimo',
    'Preocupação',
  ];
  
  @override
  void initState() {
    super.initState();
    final thoughtProvider = Provider.of<ThoughtProvider>(context, listen: false);
    final thought = thoughtProvider.currentThought;
    
    _contentController = TextEditingController(text: thought?.content ?? '');
    _situationController = TextEditingController(text: thought?.situation ?? '');
    _alternativeThoughtController = TextEditingController(text: thought?.alternativeThought ?? '');
    _outcomeController = TextEditingController(text: thought?.outcome ?? '');
    _emotionIntensity = thought?.emotionIntensity ?? 5;
  }
  
  @override
  void dispose() {
    _contentController.dispose();
    _situationController.dispose();
    _alternativeThoughtController.dispose();
    _outcomeController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Consumer<ThoughtProvider>(
      builder: (context, thoughtProvider, child) {
        final thought = thoughtProvider.currentThought;
        
        if (thought == null) {
          return const Scaffold(
            body: Center(
              child: Text('Erro ao carregar pensamento'),
            ),
          );
        }
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Editar Pensamento'),
            actions: [
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () {
                  _saveThought(context);
                },
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Conteúdo do pensamento
                const Text(
                  'Pensamento',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _contentController,
                  decoration: const InputDecoration(
                    hintText: 'O que está passando pela sua mente?',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    thoughtProvider.setCurrentThought(
                      thought.copyWith(content: value),
                    );
                  },
                ),
                const SizedBox(height: 16),
                
                // Situação
                const Text(
                  'Situação',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _situationController,
                  decoration: const InputDecoration(
                    hintText: 'O que estava acontecendo quando teve esse pensamento?',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: (value) {
                    thoughtProvider.updateCurrentSituation(value);
                  },
                ),
                const SizedBox(height: 16),
                
                // Emoções
                const Text(
                  'Emoções',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _commonEmotions.map((emotion) {
                    final isSelected = thought.emotions.contains(emotion);
                    return FilterChip(
                      label: Text(emotion),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          thoughtProvider.addEmotionToCurrent(emotion);
                        } else {
                          thoughtProvider.removeEmotionFromCurrent(emotion);
                        }
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                
                // Intensidade da emoção
                const Text(
                  'Intensidade da Emoção',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Text('1'),
                    Expanded(
                      child: Slider(
                        value: thought.emotionIntensity.toDouble(),
                        min: 1,
                        max: 10,
                        divisions: 9,
                        label: thought.emotionIntensity.toString(),
                        onChanged: (value) {
                          thoughtProvider.updateCurrentEmotionIntensity(value.toInt());
                        },
                      ),
                    ),
                    const Text('10'),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Distorções cognitivas
                const Text(
                  'Distorções Cognitivas',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: CognitiveDistortion.values
                      .where((d) => d != CognitiveDistortion.none)
                      .map((distortion) {
                    final isSelected = thought.distortions.contains(distortion);
                    return Tooltip(
                      message: distortion.description,
                      child: FilterChip(
                        label: Text(distortion.name),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            thoughtProvider.addDistortionToCurrent(distortion);
                          } else {
                            thoughtProvider.removeDistortionFromCurrent(distortion);
                          }
                        },
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                
                // Pensamento alternativo
                const Text(
                  'Pensamento Alternativo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _alternativeThoughtController,
                  decoration: const InputDecoration(
                    hintText: 'Qual seria uma forma mais equilibrada de pensar sobre isso?',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    thoughtProvider.updateCurrentAlternativeThought(value);
                  },
                ),
                const SizedBox(height: 16),
                
                // Resultado
                const Text(
                  'Resultado',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _outcomeController,
                  decoration: const InputDecoration(
                    hintText: 'Como você se sente depois de refletir sobre esse pensamento?',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                  onChanged: (value) {
                    thoughtProvider.updateCurrentOutcome(value);
                  },
                ),
                const SizedBox(height: 32),
                
                // Botões
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        thoughtProvider.discardCurrentThought();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _saveThought(context);
                      },
                      child: const Text('Salvar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Salva o pensamento
  void _saveThought(BuildContext context) {
    final thoughtProvider = Provider.of<ThoughtProvider>(context, listen: false);
    thoughtProvider.saveCurrentThought();
    Navigator.of(context).pop();
  }
}
