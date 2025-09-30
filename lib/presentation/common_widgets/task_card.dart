import 'package:flutter/material.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/domain/entities/task_entity.dart';
import 'package:intl/intl.dart';

/// Widget que exibe um cartão de tarefa
class TaskCard extends StatelessWidget {
  /// Tarefa a ser exibida
  final TaskEntity task;
  
  /// Função chamada quando a tarefa é marcada como concluída
  final Function(String)? onComplete;
  
  /// Função chamada quando a tarefa é tocada
  final Function(TaskEntity)? onTap;
  
  /// Construtor
  const TaskCard({
    super.key,
    required this.task,
    this.onComplete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: task.isOverdue 
              ? FocoraTheme.errorColor.withOpacity(0.5)
              : Colors.transparent,
          width: task.isOverdue ? 1 : 0,
        ),
      ),
      child: InkWell(
        onTap: onTap != null ? () => onTap!(task) : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkbox para marcar como concluída
              _buildCheckbox(),
              const SizedBox(width: 12),
              
              // Conteúdo principal
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Título da tarefa
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : null,
                        color: task.status == TaskStatus.completed
                            ? FocoraTheme.textSecondaryColor
                            : FocoraTheme.textPrimaryColor,
                      ),
                    ),
                    
                    // Descrição da tarefa (se houver)
                    if (task.description != null && task.description!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          task.description!,
                          style: TextStyle(
                            fontSize: 14,
                            color: FocoraTheme.textSecondaryColor,
                            decoration: task.status == TaskStatus.completed
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    
                    // Metadados da tarefa
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: _buildMetadata(),
                    ),
                  ],
                ),
              ),
              
              // Indicador de prioridade
              _buildPriorityIndicator(),
            ],
          ),
        ),
      ),
    );
  }
  
  /// Constrói o checkbox para marcar a tarefa como concluída
  Widget _buildCheckbox() {
    return Transform.scale(
      scale: 1.1,
      child: Checkbox(
        value: task.status == TaskStatus.completed,
        onChanged: onComplete != null 
            ? (value) {
                if (value == true) {
                  onComplete!(task.id);
                }
              }
            : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        activeColor: FocoraTheme.secondaryColor,
      ),
    );
  }
  
  /// Constrói os metadados da tarefa (data, contextos, etc.)
  Widget _buildMetadata() {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        // Data de vencimento
        if (task.dueDate != null)
          _buildChip(
            icon: Icons.calendar_today,
            label: DateFormat('dd/MM/yyyy').format(task.dueDate!),
            color: task.isOverdue ? FocoraTheme.errorColor : null,
          ),
        
        // Projeto
        if (task.projectId != null)
          _buildChip(
            icon: Icons.folder_outlined,
            label: 'Projeto', // Idealmente, seria o nome do projeto
            color: FocoraTheme.accentColor,
          ),
        
        // Contextos
        for (final context in task.contexts.take(2))
          _buildChip(
            icon: Icons.label_outline,
            label: context,
          ),
        
        // Indicador de mais contextos
        if (task.contexts.length > 2)
          _buildChip(
            icon: Icons.more_horiz,
            label: '+${task.contexts.length - 2}',
          ),
        
        // Nível de energia
        _buildEnergyLevel(),
      ],
    );
  }
  
  /// Constrói um chip para exibir metadados
  Widget _buildChip({
    required IconData icon,
    required String label,
    Color? color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: (color ?? FocoraTheme.secondaryColor).withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: color ?? FocoraTheme.secondaryColor,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color ?? FocoraTheme.secondaryColor,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Constrói o indicador de nível de energia
  Widget _buildEnergyLevel() {
    final Color color;
    final String label;
    
    switch (task.energyLevel) {
      case 1:
        color = Colors.blue;
        label = 'Baixa';
        break;
      case 2:
        color = Colors.green;
        label = 'Média-Baixa';
        break;
      case 3:
        color = Colors.amber;
        label = 'Média';
        break;
      case 4:
        color = Colors.orange;
        label = 'Média-Alta';
        break;
      case 5:
        color = Colors.red;
        label = 'Alta';
        break;
      default:
        color = Colors.grey;
        label = 'Indefinida';
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.bolt,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Constrói o indicador de prioridade
  Widget _buildPriorityIndicator() {
    final Color color;
    final IconData icon;
    
    switch (task.priority) {
      case TaskPriority.low:
        color = Color(task.priority.colorValue);
        icon = Icons.arrow_downward;
        break;
      case TaskPriority.medium:
        color = Color(task.priority.colorValue);
        icon = Icons.remove;
        break;
      case TaskPriority.high:
        color = Color(task.priority.colorValue);
        icon = Icons.arrow_upward;
        break;
      case TaskPriority.urgent:
        color = Color(task.priority.colorValue);
        icon = Icons.priority_high;
        break;
    }
    
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 16,
        color: color,
      ),
    );
  }
}
