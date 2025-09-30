import 'package:flutter/material.dart';
import 'package:focora/app/routes.dart';
import 'package:focora/app/theme.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';
import 'package:focora/presentation/common_widgets/energy_card.dart';
import 'package:focora/presentation/common_widgets/task_card.dart';
import 'package:focora/presentation/providers/energy_provider.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:provider/provider.dart';

/// Tela de dashboard do aplicativo Focora
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    
    // Adiciona dados de exemplo para desenvolvimento
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final energyProvider = Provider.of<EnergyProvider>(context, listen: false);
      
      taskProvider.addSampleTasks();
      energyProvider.addSampleEnergyLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Focora'),
        actions: [
          IconButton(
            icon: const Icon(Icons.insights_outlined),
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.insights);
            },
            tooltip: 'Insights',
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Implementar notificações
            },
            tooltip: 'Notificações',
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Implementar configurações
            },
            tooltip: 'Configurações',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Implementar atualização
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seção de energia
              _buildEnergySection(),
              
              // Seção de tarefas para hoje
              _buildTodayTasksSection(),
              
              // Seção de tarefas em andamento
              _buildInProgressTasksSection(),
              
              // Seção de caixa de entrada
              _buildInboxSection(),
              
              // Seção do Coach Cognitivo
              _buildCoachSection(),
              
              // Seção do Ócio Criativo
              _buildOcioSection(),
              
              // Seção de Insights
              _buildInsightsSection(),
              
              // Espaço no final
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementar adição de tarefa
          Navigator.pushNamed(context, AppRoutes.inbox);
        },
        backgroundColor: FocoraTheme.secondaryColor,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          
          // Navegar para a tela correspondente
          switch (index) {
            case 0:
              // Já estamos na tela de dashboard
              break;
            case 1:
              Navigator.pushNamed(context, AppRoutes.inbox);
              break;
            case 2:
              Navigator.pushNamed(context, AppRoutes.pomodoro);
              break;
            case 3:
              Navigator.pushNamed(context, AppRoutes.coach);
              break;
            case 4:
              Navigator.pushNamed(context, AppRoutes.ocio);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inbox_outlined),
            activeIcon: Icon(Icons.inbox),
            label: 'Caixa de Entrada',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.timer_outlined),
            activeIcon: Icon(Icons.timer),
            label: 'Pomodoro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.psychology_outlined),
            activeIcon: Icon(Icons.psychology),
            label: 'Coach',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.lightbulb_outlined),
            activeIcon: Icon(Icons.lightbulb),
            label: 'Ócio',
          ),
        ],
      ),
    );
  }
  
  /// Constrói a seção de energia
  Widget _buildEnergySection() {
    return Consumer<EnergyProvider>(
      builder: (context, energyProvider, child) {
        final latestLog = energyProvider.latestLogForCurrentPeriod;
        final currentPeriod = getCurrentPeriod();
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Como está sua energia?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implementar histórico de energia
                    },
                    child: const Text('Ver histórico'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              if (latestLog != null)
                // Exibe o registro mais recente
                EnergyCard(
                  key: const Key('energy_card'),
                  energyLog: latestLog,
                )
              else
                // Exibe um card para registrar a energia
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navegar para a tela de registro de energia
                      Navigator.pushNamed(context, AppRoutes.energyLog);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Registre sua energia para o período da ${currentPeriod.name}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Navegar para a tela de registro de energia
                              Navigator.pushNamed(context, AppRoutes.energyLog);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Registrar agora'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
  
  /// Constrói a seção de tarefas para hoje
  Widget _buildTodayTasksSection() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final todayTasks = taskProvider.todayTasks;
        
        return Column(
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
  
  /// Constrói a seção de tarefas em andamento
  Widget _buildInProgressTasksSection() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final inProgressTasks = taskProvider.inProgressTasks;
        
        return Column(
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
  
  /// Constrói a seção de caixa de entrada
  Widget _buildInboxSection() {
    return Consumer<TaskProvider>(
      builder: (context, taskProvider, child) {
        final inboxTasks = taskProvider.inboxTasks;
        
        return Column(
          key: const Key('inbox_card'),
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
  
  /// Constrói a seção do Coach Cognitivo
  Widget _buildCoachSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Coach Cognitivo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.coach);
                },
                child: const Text('Acessar'),
              ),
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.coach);
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.psychology,
                          size: 32,
                          color: FocoraTheme.tertiaryColor,
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Diário de Pensamentos',
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
                      'Identifique padrões de pensamento que levam à procrastinação e desenvolva estratégias para superá-los.',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.coach);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FocoraTheme.tertiaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Registrar Pensamento'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  /// Constrói a seção do Ócio Criativo
  Widget _buildOcioSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ócio Criativo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.ocio);
                },
                child: const Text('Acessar'),
              ),
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.ocio);
              },
              borderRadius: BorderRadius.circular(16),
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
                          color: FocoraTheme.accentColor,
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Modo Ócio Criativo',
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
                      'Dedique um tempo ao pensamento livre, sem distrações digitais, e capture as ideias que surgirem durante esse período.',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.ocio);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: FocoraTheme.accentColor,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Iniciar Modo Ócio'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  /// Constrói a seção de Insights
  Widget _buildInsightsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Insights e Análises',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRoutes.insights);
                },
                child: const Text('Acessar'),
              ),
            ],
          ),
        ),
        
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            margin: EdgeInsets.zero,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.insights);
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.insights,
                          size: 32,
                          color: Colors.purple.shade400,
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Análises Personalizadas',
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
                      'Visualize estatísticas detalhadas sobre sua produtividade, energia e padrões de comportamento para otimizar sua rotina.',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.insights);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade400,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: const Text('Ver Insights'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
