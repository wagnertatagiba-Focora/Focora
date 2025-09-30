import 'package:flutter/material.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/domain/entities/project_entity.dart';
import 'package:intl/intl.dart';

/// Widget que exibe um cartão de projeto
class ProjectCard extends StatelessWidget {
  /// Projeto a ser exibido
  final ProjectEntity project;
  
  /// Função chamada quando o projeto é tocado
  final Function(ProjectEntity)? onTap;
  
  /// Número de tarefas no projeto
  final int taskCount;
  
  /// Número de tarefas concluídas no projeto
  final int completedTaskCount;
  
  /// Construtor
  const ProjectCard({
    super.key,
    required this.project,
    this.onTap,
    this.taskCount = 0,
    this.completedTaskCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final progress = taskCount > 0 ? completedTaskCount / taskCount : 0.0;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: project.isOverdue 
              ? FocoraTheme.errorColor.withOpacity(0.5)
              : Colors.transparent,
          width: project.isOverdue ? 1 : 0,
        ),
      ),
      child: InkWell(
        onTap: onTap != null ? () => onTap!(project) : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Row(
                children: [
                  // Ícone ou cor do projeto
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(project.color).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      project.icon != null 
                          ? IconData(int.parse(project.icon!), fontFamily: 'MaterialIcons')
                          : Icons.folder,
                      color: Color(project.color),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Nome e status do projeto
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          project.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        _buildStatusChip(),
                      ],
                    ),
                  ),
                  
                  // Menu de opções
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      // Implementar menu de opções
                    },
                  ),
                ],
              ),
              
              // Descrição do projeto
              if (project.description != null && project.description!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    project.description!,
                    style: TextStyle(
                      fontSize: 14,
                      color: FocoraTheme.textSecondaryColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              
              // Barra de progresso
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progresso',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: FocoraTheme.textSecondaryColor,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(project.color),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: progress,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(project.color)),
                      borderRadius: BorderRadius.circular(4),
                      minHeight: 6,
                    ),
                  ],
                ),
              ),
              
              // Metadados do projeto
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Contagem de tarefas
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: FocoraTheme.textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$completedTaskCount/$taskCount tarefas',
                          style: TextStyle(
                            fontSize: 14,
                            color: FocoraTheme.textSecondaryColor,
                          ),
                        ),
                      ],
                    ),
                    
                    // Data de vencimento
                    if (project.dueDate != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: project.isOverdue 
                                ? FocoraTheme.errorColor
                                : FocoraTheme.textSecondaryColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            DateFormat('dd/MM/yyyy').format(project.dueDate!),
                            style: TextStyle(
                              fontSize: 14,
                              color: project.isOverdue 
                                  ? FocoraTheme.errorColor
                                  : FocoraTheme.textSecondaryColor,
                            ),
                          ),
                        ],
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
  
  /// Constrói o chip de status do projeto
  Widget _buildStatusChip() {
    final Color color;
    final String label;
    
    switch (project.status) {
      case ProjectStatus.active:
        color = Color(project.status.colorValue);
        label = 'Ativo';
        break;
      case ProjectStatus.onHold:
        color = Color(project.status.colorValue);
        label = 'Em espera';
        break;
      case ProjectStatus.completed:
        color = Color(project.status.colorValue);
        label = 'Concluído';
        break;
      case ProjectStatus.archived:
        color = Color(project.status.colorValue);
        label = 'Arquivado';
        break;
      case ProjectStatus.cancelled:
        color = Color(project.status.colorValue);
        label = 'Cancelado';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
