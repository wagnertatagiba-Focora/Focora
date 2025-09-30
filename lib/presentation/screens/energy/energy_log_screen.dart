import 'package:flutter/material.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';
import 'package:focora/presentation/common_widgets/energy_card.dart';
import 'package:focora/presentation/providers/energy_provider.dart';
import 'package:provider/provider.dart';

/// Tela de registro de energia
class EnergyLogScreen extends StatefulWidget {
  const EnergyLogScreen({super.key});

  @override
  State<EnergyLogScreen> createState() => _EnergyLogScreenState();
}

class _EnergyLogScreenState extends State<EnergyLogScreen> {
  int _energyLevel = 3;
  int _focusLevel = 3;
  int _motivationLevel = 3;
  final TextEditingController _notesController = TextEditingController();
  final List<String> _selectedFactors = [];
  
  // Lista de fatores comuns
  final List<String> _commonFactors = [
    'Boa noite de sono',
    'Sono insuficiente',
    'Exercício físico',
    'Alimentação saudável',
    'Alimentação pesada',
    'Café/Cafeína',
    'Estresse',
    'Ambiente calmo',
    'Ambiente barulhento',
    'Boa hidratação',
    'Desidratação',
    'Meditação',
    'Música',
  ];
  
  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Energia'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Período atual
            _buildCurrentPeriod(),
            const SizedBox(height: 24),
            
            // Nível de energia
            _buildEnergySlider(),
            const SizedBox(height: 24),
            
            // Nível de foco
            _buildFocusSlider(),
            const SizedBox(height: 24),
            
            // Nível de motivação
            _buildMotivationSlider(),
            const SizedBox(height: 24),
            
            // Fatores
            _buildFactorsSection(),
            const SizedBox(height: 24),
            
            // Notas
            _buildNotesField(),
            const SizedBox(height: 32),
            
            // Botão de salvar
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveEnergyLog,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: FocoraTheme.secondaryColor,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Salvar Registro',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            // Visualização prévia
            _buildPreview(),
          ],
        ),
      ),
    );
  }
  
  /// Constrói a seção do período atual
  Widget _buildCurrentPeriod() {
    final currentPeriod = getCurrentPeriod();
    final now = DateTime.now();
    final formattedDate = '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';
    final formattedTime = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(
              _getPeriodIcon(currentPeriod),
              size: 48,
              color: _getPeriodColor(currentPeriod),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Período da ${currentPeriod.name}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$formattedDate às $formattedTime',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Constrói o slider de energia
  Widget _buildEnergySlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nível de Energia',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getEnergyColor(_energyLevel),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$_energyLevel',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: _energyLevel.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: _getEnergyLabel(_energyLevel),
          activeColor: _getEnergyColor(_energyLevel),
          onChanged: (value) {
            setState(() {
              _energyLevel = value.round();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Muito baixa',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Muito alta',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// Constrói o slider de foco
  Widget _buildFocusSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nível de Foco',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getFocusColor(_focusLevel),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$_focusLevel',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: _focusLevel.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: _getFocusLabel(_focusLevel),
          activeColor: _getFocusColor(_focusLevel),
          onChanged: (value) {
            setState(() {
              _focusLevel = value.round();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Muito distraído',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Muito focado',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// Constrói o slider de motivação
  Widget _buildMotivationSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Nível de Motivação',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: _getMotivationColor(_motivationLevel),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$_motivationLevel',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Slider(
          value: _motivationLevel.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          label: _getMotivationLabel(_motivationLevel),
          activeColor: _getMotivationColor(_motivationLevel),
          onChanged: (value) {
            setState(() {
              _motivationLevel = value.round();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Desmotivado',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              'Muito motivado',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  /// Constrói a seção de fatores
  Widget _buildFactorsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fatores que influenciaram',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _commonFactors.map((factor) {
            final isSelected = _selectedFactors.contains(factor);
            return FilterChip(
              label: Text(factor),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedFactors.add(factor);
                  } else {
                    _selectedFactors.remove(factor);
                  }
                });
              },
              backgroundColor: Colors.grey.shade200,
              selectedColor: FocoraTheme.secondaryColor.withOpacity(0.2),
              checkmarkColor: FocoraTheme.secondaryColor,
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text('Adicionar fator personalizado'),
          onPressed: () {
            _showAddFactorDialog();
          },
        ),
      ],
    );
  }
  
  /// Constrói o campo de notas
  Widget _buildNotesField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notas (opcional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _notesController,
          decoration: const InputDecoration(
            hintText: 'Adicione notas sobre como você está se sentindo...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
        ),
      ],
    );
  }
  
  /// Constrói a visualização prévia do registro
  Widget _buildPreview() {
    final energyLog = EnergyLogEntity(
      energyLevel: _energyLevel,
      focusLevel: _focusLevel,
      motivationLevel: _motivationLevel,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      factors: _selectedFactors,
    );
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Visualização prévia',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        EnergyCard(energyLog: energyLog),
      ],
    );
  }
  
  /// Exibe o diálogo para adicionar um fator personalizado
  void _showAddFactorDialog() {
    final TextEditingController controller = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Adicionar fator'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Digite o fator',
              border: OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final factor = controller.text.trim();
                if (factor.isNotEmpty) {
                  setState(() {
                    _selectedFactors.add(factor);
                  });
                }
                Navigator.pop(context);
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }
  
  /// Salva o registro de energia
  void _saveEnergyLog() {
    final energyProvider = Provider.of<EnergyProvider>(context, listen: false);
    
    final energyLog = EnergyLogEntity(
      energyLevel: _energyLevel,
      focusLevel: _focusLevel,
      motivationLevel: _motivationLevel,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      factors: _selectedFactors,
    );
    
    energyProvider.addEnergyLog(energyLog);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registro de energia salvo com sucesso!'),
      ),
    );
    
    Navigator.pop(context);
  }
  
  /// Retorna o ícone do período
  IconData _getPeriodIcon(FocoraDayPeriod period) {
    switch (period) {
      case FocoraDayPeriod.morning:
        return Icons.wb_sunny;
      case FocoraDayPeriod.afternoon:
        return Icons.wb_twighlight;
      case FocoraDayPeriod.evening:
        return Icons.nightlight_round;
      case FocoraDayPeriod.night:
        return Icons.bedtime;
    }
  }
  
  /// Retorna a cor do período
  Color _getPeriodColor(FocoraDayPeriod period) {
    switch (period) {
      case FocoraDayPeriod.morning:
        return Colors.orange;
      case FocoraDayPeriod.afternoon:
        return Colors.amber;
      case FocoraDayPeriod.evening:
        return Colors.indigo;
      case FocoraDayPeriod.night:
        return Colors.purple;
    }
  }
  
  /// Retorna o rótulo do nível de energia
  String _getEnergyLabel(int level) {
    switch (level) {
      case 1:
        return 'Muito baixa';
      case 2:
        return 'Baixa';
      case 3:
        return 'Média';
      case 4:
        return 'Alta';
      case 5:
        return 'Muito alta';
      default:
        return 'Média';
    }
  }
  
  /// Retorna a cor do nível de energia
  Color _getEnergyColor(int level) {
    switch (level) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.amber;
      case 4:
        return Colors.lightGreen;
      case 5:
        return Colors.green;
      default:
        return Colors.amber;
    }
  }
  
  /// Retorna o rótulo do nível de foco
  String _getFocusLabel(int level) {
    switch (level) {
      case 1:
        return 'Muito distraído';
      case 2:
        return 'Distraído';
      case 3:
        return 'Neutro';
      case 4:
        return 'Focado';
      case 5:
        return 'Muito focado';
      default:
        return 'Neutro';
    }
  }
  
  /// Retorna a cor do nível de foco
  Color _getFocusColor(int level) {
    switch (level) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 4:
        return Colors.indigo;
      case 5:
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }
  
  /// Retorna o rótulo do nível de motivação
  String _getMotivationLabel(int level) {
    switch (level) {
      case 1:
        return 'Desmotivado';
      case 2:
        return 'Pouco motivado';
      case 3:
        return 'Neutro';
      case 4:
        return 'Motivado';
      case 5:
        return 'Muito motivado';
      default:
        return 'Neutro';
    }
  }
  
  /// Retorna a cor do nível de motivação
  Color _getMotivationColor(int level) {
    switch (level) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.teal;
      case 4:
        return Colors.lightBlue;
      case 5:
        return Colors.blue;
      default:
        return Colors.teal;
    }
  }
}
