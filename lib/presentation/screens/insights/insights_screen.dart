import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:focora/domain/entities/task_entity.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';
import 'package:focora/domain/entities/thought_entity.dart';
import 'package:focora/domain/entities/idea_entity.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:focora/presentation/providers/energy_provider.dart';
import 'package:focora/presentation/providers/thought_provider.dart';
import 'package:focora/presentation/providers/idea_provider.dart';
import 'package:focora/app/theme.dart';

/// Tela de insights e análises
class InsightsScreen extends StatefulWidget {
  /// Construtor
  const InsightsScreen({Key? key}) : super(key: key);

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Insights'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Produtividade'),
            Tab(text: 'Energia'),
            Tab(text: 'Correlações'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          ProductivityInsightsTab(),
          EnergyInsightsTab(),
          CorrelationsTab(),
        ],
      ),
    );
  }
}

/// Tab de insights de produtividade
class ProductivityInsightsTab extends StatelessWidget {
  /// Construtor
  const ProductivityInsightsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = taskProvider.tasks;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Visão Geral',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          
          // Cards de estatísticas
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  context,
                  'Tarefas Concluídas',
                  '${taskProvider.completedTasks.length}',
                  Icons.check_circle,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  context,
                  'Em Andamento',
                  '0',
                  Icons.pending_actions,
                  Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Tab de insights de energia
class EnergyInsightsTab extends StatelessWidget {
  /// Construtor
  const EnergyInsightsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Dados de energia insuficientes para análise'),
    );
  }
}

/// Tab de correlações
class CorrelationsTab extends StatelessWidget {
  /// Construtor
  const CorrelationsTab({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Dados insuficientes para análise de correlações'),
    );
  }
}
