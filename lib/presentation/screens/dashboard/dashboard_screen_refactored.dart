import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focora/app/routes.dart';
import 'package:focora/presentation/providers/energy_provider.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:focora/presentation/screens/dashboard/widgets/dashboard_energy_section.dart';
import 'package:focora/presentation/screens/dashboard/widgets/dashboard_today_tasks_section.dart';
import 'package:focora/presentation/screens/dashboard/widgets/dashboard_inbox_section.dart';
import 'package:focora/presentation/screens/dashboard/widgets/dashboard_in_progress_section.dart';

/// Tela de dashboard refatorada do aplicativo Focora
class DashboardScreenRefactored extends StatefulWidget {
  const DashboardScreenRefactored({super.key});

  @override
  State<DashboardScreenRefactored> createState() => _DashboardScreenRefactoredState();
}

class _DashboardScreenRefactoredState extends State<DashboardScreenRefactored> {
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _initializeSampleData();
  }

  /// Inicializa dados de exemplo para desenvolvimento
  void _initializeSampleData() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      
      final taskProvider = Provider.of<TaskProvider>(context, listen: false);
      final energyProvider = Provider.of<EnergyProvider>(context, listen: false);
      
      taskProvider.addSampleTasks();
      energyProvider.addSampleEnergyLogs();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// Constrói a AppBar
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Focora'),
      actions: [
        IconButton(
          key: const Key('insights_button'),
          icon: const Icon(Icons.insights_outlined),
          onPressed: () => Navigator.pushNamed(context, AppRoutes.insights),
          tooltip: 'Insights',
        ),
        IconButton(
          key: const Key('notifications_button'),
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Implementar notificações
          },
          tooltip: 'Notificações',
        ),
        IconButton(
          key: const Key('settings_button'),
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            // Implementar configurações
          },
          tooltip: 'Configurações',
        ),
      ],
    );
  }

  /// Constrói o corpo da tela
  Widget _buildBody() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de energia
            const DashboardEnergySection(),
            
            // Seção de tarefas para hoje
            const DashboardTodayTasksSection(),
            
            // Seção de tarefas em andamento
            const DashboardInProgressSection(),
            
            // Seção de caixa de entrada
            const DashboardInboxSection(),
            
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
    );
  }

  /// Manipula o refresh da tela
  Future<void> _handleRefresh() async {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    final energyProvider = Provider.of<EnergyProvider>(context, listen: false);
    
    await Future.wait([
      taskProvider.loadTasks(),
      energyProvider.loadEnergyLogs(),
    ]);
  }

  /// Constrói a seção do Coach Cognitivo
  Widget _buildCoachSection() {
    return Column(
      key: const Key('coach_section'),
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
                onPressed: () => Navigator.pushNamed(context, AppRoutes.coach),
                child: const Text('Acessar'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.coach),
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.psychology,
                      size: 32,
                      color: Colors.blue,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Transforme pensamentos limitantes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Use técnicas de reestruturação cognitiva para superar a procrastinação',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
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
      key: const Key('ocio_section'),
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
                onPressed: () => Navigator.pushNamed(context, AppRoutes.ocio),
                child: const Text('Explorar'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.ocio),
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb,
                      size: 32,
                      color: Colors.orange,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Capture ideias e insights',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Transforme momentos de pausa em oportunidades criativas',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
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
      key: const Key('insights_section'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Seus Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushNamed(context, AppRoutes.insights),
                child: const Text('Ver todos'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: InkWell(
              onTap: () => Navigator.pushNamed(context, AppRoutes.insights),
              borderRadius: BorderRadius.circular(16),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.analytics,
                      size: 32,
                      color: Colors.green,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Analise seus padrões',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Descubra insights sobre sua produtividade e energia',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
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

  /// Constrói a barra de navegação inferior
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: _handleBottomNavTap,
      type: BottomNavigationBarType.fixed,
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
    );
  }

  /// Manipula o toque na barra de navegação inferior
  void _handleBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Já está no dashboard
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
  }
}
