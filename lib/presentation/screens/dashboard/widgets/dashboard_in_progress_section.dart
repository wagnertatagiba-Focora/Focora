import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focora/presentation/common_widgets/task_card.dart';
import 'package:focora/presentation/providers/task_provider.dart';

/// Widget para a seção de tarefas em andamento no dashboard
class DashboardInProgressSection extends StatelessWidget {
  const DashboardInProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final inProgressTasks = taskProvider.inProgressTasks;
        
        return Column(
          key: const Key('in_progress_section'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Em andamento',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implementar visualização de todas as tarefas em andamento
                    },
                    child: const Text('Ver todas'),
                  ),
                ],
              ),
            ),
            
            if (inProgressTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.hourglass_empty,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nenhuma tarefa em andamento',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: inProgressTasks.length > 3 ? 3 : inProgressTasks.length,
                itemBuilder: (context, index) {
                  final task = inProgressTasks[index];
                  return TaskCard(
                    task: task,
                    onComplete: (id) {
                      taskProvider.markTaskAsCompleted(id);
                    },
                    onTap: (task) {
                      // Implementar visualização de detalhes da tarefa
                    },
                  );
                },
              ),
          ],
        );
      },
    );
  }
}
