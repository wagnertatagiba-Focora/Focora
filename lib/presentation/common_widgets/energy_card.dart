import 'package:flutter/material.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';

/// Widget que exibe um cartão de registro de energia
class EnergyCard extends StatelessWidget {
  /// Registro de energia a ser exibido
  final EnergyLogEntity energyLog;
  
  /// Função chamada quando o registro é tocado
  final Function(EnergyLogEntity)? onTap;
  
  /// Construtor
  const EnergyCard({
    super.key,
    required this.energyLog,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap != null ? () => onTap!(energyLog) : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Período e data
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        energyLog.period.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${energyLog.formattedDate} - ${energyLog.formattedTime}',
                        style: TextStyle(
                          fontSize: 14,
                          color: FocoraTheme.textSecondaryColor,
                        ),
                      ),
                    ],
                  ),
                  
                  // Média dos níveis
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getColorForLevel(energyLog.averageLevel.round()).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        energyLog.averageLevel.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _getColorForLevel(energyLog.averageLevel.round()),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              // Níveis
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildLevelIndicator(
                      label: 'Energia',
                      level: energyLog.energyLevel,
                      icon: Icons.battery_charging_full,
                    ),
                    _buildLevelIndicator(
                      label: 'Foco',
                      level: energyLog.focusLevel,
                      icon: Icons.center_focus_strong,
                    ),
                    _buildLevelIndicator(
                      label: 'Motivação',
                      level: energyLog.motivationLevel,
                      icon: Icons.emoji_events,
                    ),
                  ],
                ),
              ),
              
              // Fatores
              if (energyLog.factors.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fatores',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: FocoraTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: energyLog.factors.map((factor) => _buildFactorChip(factor)).toList(),
                      ),
                    ],
                  ),
                ),
              
              // Notas
              if (energyLog.notes != null && energyLog.notes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Notas',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: FocoraTheme.textSecondaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        energyLog.notes!,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Constrói um indicador de nível
  Widget _buildLevelIndicator({
    required String label,
    required int level,
    required IconData icon,
  }) {
    final color = _getColorForLevel(level);
    
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: color,
                ),
                const SizedBox(height: 2),
                Text(
                  level.toString(),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: FocoraTheme.textSecondaryColor,
          ),
        ),
      ],
    );
  }
  
  /// Constrói um chip de fator
  Widget _buildFactorChip(String factor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: FocoraTheme.secondaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        factor,
        style: TextStyle(
          fontSize: 12,
          color: FocoraTheme.secondaryColor,
        ),
      ),
    );
  }
  
  /// Retorna a cor correspondente ao nível
  Color _getColorForLevel(int level) {
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
        return Colors.grey;
    }
  }
}
