import 'package:flutter/material.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/domain/entities/idea_entity.dart';
import 'package:focora/presentation/providers/idea_provider.dart';
import 'package:provider/provider.dart';

/// Tela do Modo Ócio Criativo
class OcioScreen extends StatefulWidget {
  /// Construtor
  const OcioScreen({super.key});

  @override
  State<OcioScreen> createState() => _OcioScreenState();
}

class _OcioScreenState extends State<OcioScreen> with SingleTickerProviderStateMixin {
  /// Controlador das abas
  late TabController _tabController;
  
  /// Controlador do temporizador
  int _timerMinutes = 15;
  bool _timerRunning = false;
  int _remainingSeconds = 0;
  
  /// Controladores de texto
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _tagController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    // Carrega as ideias
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ideaProvider = Provider.of<IdeaProvider>(context, listen: false);
      ideaProvider.loadIdeas();
    });
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ócio Criativo'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Modo Ócio'),
            Tab(text: 'Minhas Ideias'),
            Tab(text: 'Insights'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOcioModeTab(),
          _buildIdeasTab(),
          _buildInsightsTab(),
        ],
      ),
      floatingActionButton: _tabController.index == 1
          ? FloatingActionButton(
              onPressed: _showAddIdeaDialog,
              backgroundColor: FocoraTheme.tertiaryColor,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
  
  /// Constrói a aba do Modo Ócio
  Widget _buildOcioModeTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Explicação do Modo Ócio
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
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
                      Icon(
                        Icons.lightbulb_outline,
                        size: 32,
                        color: FocoraTheme.tertiaryColor,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'O que é o Modo Ócio Criativo?',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'O Ócio Criativo é um estado mental onde você permite que sua mente divague livremente, sem culpa ou pressão. É nesse estado que muitas vezes surgem as melhores ideias e soluções criativas.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Use este modo para dedicar um tempo ao pensamento livre, sem distrações digitais, e capture as ideias que surgirem.',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Temporizador
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
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
                      Icon(
                        Icons.timer_outlined,
                        size: 32,
                        color: FocoraTheme.tertiaryColor,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Temporizador de Ócio',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Defina um tempo para seu momento de ócio criativo. Durante este período, desligue as notificações e encontre um local tranquilo.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  
                  // Seletor de tempo
                  if (!_timerRunning)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: _timerMinutes > 5
                              ? () {
                                  setState(() {
                                    _timerMinutes -= 5;
                                  });
                                }
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          '$_timerMinutes min',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 16),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline),
                          onPressed: _timerMinutes < 60
                              ? () {
                                  setState(() {
                                    _timerMinutes += 5;
                                  });
                                }
                              : null,
                        ),
                      ],
                    )
                  else
                    Center(
                      child: Text(
                        '${_remainingSeconds ~/ 60}:${(_remainingSeconds % 60).toString().padLeft(2, '0')}',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                  
                  // Botão de iniciar/parar
                  Center(
                    child: ElevatedButton(
                      onPressed: _toggleTimer,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _timerRunning
                            ? Colors.red.shade400
                            : FocoraTheme.tertiaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        _timerRunning ? 'Parar' : 'Iniciar',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Captura de ideias
          Card(
            margin: EdgeInsets.zero,
            elevation: 2,
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
                      Icon(
                        Icons.edit_outlined,
                        size: 32,
                        color: FocoraTheme.tertiaryColor,
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Capturar Ideia',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Teve uma ideia durante seu momento de ócio? Capture-a rapidamente aqui:',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  
                  // Formulário de captura rápida
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Título da ideia',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descrição',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: _captureIdea,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: FocoraTheme.tertiaryColor,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                      ),
                      child: const Text(
                        'Salvar Ideia',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Constrói a aba de ideias
  Widget _buildIdeasTab() {
    return Consumer<IdeaProvider>(
      builder: (context, ideaProvider, child) {
        final ideas = ideaProvider.ideas;
        
        if (ideas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhuma ideia capturada ainda',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Use o Modo Ócio para capturar suas ideias',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: ideas.length,
          itemBuilder: (context, index) {
            final idea = ideas[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: InkWell(
                onTap: () => _showIdeaDetails(idea),
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: FocoraTheme.tertiaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                idea.category.icon,
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  idea.title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  idea.category.name,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Color(idea.status.color).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              idea.status.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(idea.status.color),
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (idea.description.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Text(
                          idea.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ],
                      if (idea.tags.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: idea.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: FocoraTheme.secondaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '#$tag',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: FocoraTheme.secondaryColor,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  /// Constrói a aba de insights
  Widget _buildInsightsTab() {
    return Consumer<IdeaProvider>(
      builder: (context, ideaProvider, child) {
        final ideas = ideaProvider.ideas;
        
        if (ideas.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.insights_outlined,
                  size: 64,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                Text(
                  'Nenhum dado disponível',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Capture ideias para ver insights',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          );
        }
        
        final commonCategories = ideaProvider.commonCategories;
        final commonTags = ideaProvider.commonTags;
        
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Estatísticas gerais
              Card(
                margin: EdgeInsets.zero,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Estatísticas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatCard(
                            'Total de Ideias',
                            ideas.length.toString(),
                            Icons.lightbulb_outline,
                            FocoraTheme.tertiaryColor,
                          ),
                          _buildStatCard(
                            'Em Desenvolvimento',
                            ideaProvider.inDevelopmentIdeas.length.toString(),
                            Icons.construction_outlined,
                            FocoraTheme.secondaryColor,
                          ),
                          _buildStatCard(
                            'Implementadas',
                            ideaProvider.implementedIdeas.length.toString(),
                            Icons.check_circle_outline,
                            FocoraTheme.primaryColor,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Categorias mais comuns
              if (commonCategories.isNotEmpty)
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Categorias Mais Comuns',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...commonCategories.take(5).map((entry) {
                          final category = entry.key;
                          final count = entry.value;
                          final percentage = (count / ideas.length) * 100;
                          
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      category.icon,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      category.name,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '$count (${percentage.toStringAsFixed(0)}%)',
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: count / ideas.length,
                                  backgroundColor: Colors.grey.shade200,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FocoraTheme.tertiaryColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              
              const SizedBox(height: 24),
              
              // Tags mais comuns
              if (commonTags.isNotEmpty)
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tags Mais Comuns',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: commonTags.take(10).map((entry) {
                            final tag = entry.key;
                            final count = entry.value;
                            
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: FocoraTheme.secondaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                '#$tag ($count)',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: FocoraTheme.secondaryColor,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
  
  /// Constrói um card de estatística
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 30,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  
  /// Inicia ou para o temporizador
  void _toggleTimer() {
    setState(() {
      if (_timerRunning) {
        _timerRunning = false;
      } else {
        _timerRunning = true;
        _remainingSeconds = _timerMinutes * 60;
        _startTimer();
      }
    });
  }
  
  /// Inicia o temporizador
  void _startTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!_timerRunning) return;
      
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
          _startTimer();
        } else {
          _timerRunning = false;
          _showTimerCompleteDialog();
        }
      });
    });
  }
  
  /// Exibe o diálogo de temporizador completo
  void _showTimerCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tempo de Ócio Completo'),
        content: const Text(
          'Seu tempo de ócio criativo terminou. Teve alguma ideia durante este período?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _tabController.animateTo(0);
            },
            child: const Text('Sim, vou registrar'),
          ),
        ],
      ),
    );
  }
  
  /// Captura uma ideia
  void _captureIdea() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe um título para a ideia.'),
        ),
      );
      return;
    }
    
    final ideaProvider = Provider.of<IdeaProvider>(context, listen: false);
    
    final idea = IdeaEntity(
      title: title,
      description: description,
    );
    
    ideaProvider.addIdea(idea);
    
    _titleController.clear();
    _descriptionController.clear();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ideia capturada com sucesso!'),
      ),
    );
    
    // Navega para a aba de ideias
    _tabController.animateTo(1);
  }
  
  /// Exibe o diálogo de adicionar ideia
  void _showAddIdeaDialog() {
    final ideaProvider = Provider.of<IdeaProvider>(context, listen: false);
    ideaProvider.createNewIdea('', '');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Ideia'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  ideaProvider.updateCurrentTitle(value);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  ideaProvider.updateCurrentDescription(value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<IdeaCategory>(
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                value: IdeaCategory.other,
                items: IdeaCategory.values.map((category) {
                  return DropdownMenuItem<IdeaCategory>(
                    value: category,
                    child: Row(
                      children: [
                        Text(category.icon),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ideaProvider.updateCurrentCategory(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _tagController,
                decoration: const InputDecoration(
                  labelText: 'Tags (separadas por vírgula)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ideaProvider.discardCurrentIdea();
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final currentIdea = ideaProvider.currentIdea;
              if (currentIdea != null && currentIdea.title.isNotEmpty) {
                // Adiciona as tags
                final tags = _tagController.text
                    .split(',')
                    .map((tag) => tag.trim())
                    .where((tag) => tag.isNotEmpty)
                    .toList();
                
                for (final tag in tags) {
                  ideaProvider.addTagToCurrent(tag);
                }
                
                ideaProvider.saveCurrentIdea();
                _tagController.clear();
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, informe um título para a ideia.'),
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
  
  /// Exibe os detalhes de uma ideia
  void _showIdeaDetails(IdeaEntity idea) {
    final ideaProvider = Provider.of<IdeaProvider>(context, listen: false);
    ideaProvider.setCurrentIdea(idea);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(idea.title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Categoria e status
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: FocoraTheme.tertiaryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(idea.category.icon),
                        const SizedBox(width: 4),
                        Text(
                          idea.category.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: FocoraTheme.tertiaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Color(idea.status.color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      idea.status.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(idea.status.color),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Descrição
              const Text(
                'Descrição:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                idea.description,
                style: const TextStyle(fontSize: 14),
              ),
              
              const SizedBox(height: 16),
              
              // Data de captura
              const Text(
                'Capturada em:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${idea.captureDate.day}/${idea.captureDate.month}/${idea.captureDate.year} às ${idea.captureDate.hour}:${idea.captureDate.minute.toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 14),
              ),
              
              const SizedBox(height: 16),
              
              // Tags
              if (idea.tags.isNotEmpty) ...[
                const Text(
                  'Tags:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: idea.tags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: FocoraTheme.secondaryColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        '#$tag',
                        style: TextStyle(
                          fontSize: 12,
                          color: FocoraTheme.secondaryColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Notas
              if (idea.notes != null && idea.notes!.isNotEmpty) ...[
                const Text(
                  'Notas:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  idea.notes!,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
              ],
              
              // Próximos passos
              if (idea.nextSteps != null && idea.nextSteps!.isNotEmpty) ...[
                const Text(
                  'Próximos Passos:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  idea.nextSteps!,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
              ],
              
              // Recursos
              if (idea.resources != null && idea.resources!.isNotEmpty) ...[
                const Text(
                  'Recursos Necessários:',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  idea.resources!,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ideaProvider.setCurrentIdea(null);
            },
            child: const Text('Fechar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _showEditIdeaDialog(idea);
            },
            child: const Text('Editar'),
          ),
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Atualizar Status'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: IdeaStatus.values.map((status) {
                      return ListTile(
                        title: Text(status.name),
                        leading: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Color(status.color),
                            shape: BoxShape.circle,
                          ),
                        ),
                        onTap: () {
                          ideaProvider.updateIdeaStatus(idea.id, status);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  ),
                ),
              );
            },
            child: const Text('Status'),
          ),
        ],
      ),
    );
  }
  
  /// Exibe o diálogo de editar ideia
  void _showEditIdeaDialog(IdeaEntity idea) {
    final ideaProvider = Provider.of<IdeaProvider>(context, listen: false);
    ideaProvider.setCurrentIdea(idea);
    
    final titleController = TextEditingController(text: idea.title);
    final descriptionController = TextEditingController(text: idea.description);
    final notesController = TextEditingController(text: idea.notes ?? '');
    final nextStepsController = TextEditingController(text: idea.nextSteps ?? '');
    final resourcesController = TextEditingController(text: idea.resources ?? '');
    final tagController = TextEditingController(text: idea.tags.join(', '));
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Editar Ideia'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  ideaProvider.updateCurrentTitle(value);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  ideaProvider.updateCurrentDescription(value);
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<IdeaCategory>(
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                value: idea.category,
                items: IdeaCategory.values.map((category) {
                  return DropdownMenuItem<IdeaCategory>(
                    value: category,
                    child: Row(
                      children: [
                        Text(category.icon),
                        const SizedBox(width: 8),
                        Text(category.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    ideaProvider.updateCurrentCategory(value);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: tagController,
                decoration: const InputDecoration(
                  labelText: 'Tags (separadas por vírgula)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Notas',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  ideaProvider.updateCurrentNotes(value);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nextStepsController,
                decoration: const InputDecoration(
                  labelText: 'Próximos Passos',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  ideaProvider.updateCurrentNextSteps(value);
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: resourcesController,
                decoration: const InputDecoration(
                  labelText: 'Recursos Necessários',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                onChanged: (value) {
                  ideaProvider.updateCurrentResources(value);
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ideaProvider.setCurrentIdea(null);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              final currentIdea = ideaProvider.currentIdea;
              if (currentIdea != null && currentIdea.title.isNotEmpty) {
                // Atualiza as tags
                final tags = tagController.text
                    .split(',')
                    .map((tag) => tag.trim())
                    .where((tag) => tag.isNotEmpty)
                    .toList();
                
                final updatedIdea = currentIdea.copyWith(tags: tags);
                ideaProvider.updateIdea(updatedIdea);
                
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Por favor, informe um título para a ideia.'),
                  ),
                );
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
