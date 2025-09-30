import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focora/presentation/common_widgets/task_card.dart';
import 'package:focora/presentation/providers/task_provider.dart';

/// Widget para a seção de tarefas de hoje no dashboard
class DashboardTodayTasksSection extends StatelessWidget {
  const DashboardTodayTasksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final todayTasks = taskProvider.todayTasks;
        
        return Column(
          key: const Key('today_tasks_section'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Para hoje',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implementar visualização de todas as tarefas para hoje
                    },
                    child: const Text('Ver todas'),
                  ),
                ],
              ),
            ),
            
            if (todayTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Nenhuma tarefa para hoje',
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
                itemCount: todayTasks.length > 3 ? 3 : todayTasks.length,
                itemBuilder: (context, index) {
                  final task = todayTasks[index];
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
