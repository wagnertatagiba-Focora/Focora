import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focora/app/routes.dart';
import 'package:focora/presentation/common_widgets/task_card.dart';
import 'package:focora/presentation/providers/task_provider.dart';

/// Widget para a seção de caixa de entrada no dashboard
class DashboardInboxSection extends StatelessWidget {
  const DashboardInboxSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final inboxTasks = taskProvider.inboxTasks;
        
        return Column(
          key: const Key('inbox_section'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Caixa de entrada',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    key: const Key('inbox_see_all_button'),
                    onPressed: () {
                      // Navegar para a tela de caixa de entrada
                      Navigator.pushNamed(context, AppRoutes.inbox);
                    },
                    child: const Text('Ver todas'),
                  ),
                ],
              ),
            ),
            
            if (inboxTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Caixa de entrada vazia',
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
                itemCount: inboxTasks.length > 3 ? 3 : inboxTasks.length,
                itemBuilder: (context, index) {
                  final task = inboxTasks[index];
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
