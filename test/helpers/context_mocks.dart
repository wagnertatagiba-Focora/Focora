import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:focora/presentation/providers/energy_provider.dart';
import 'package:focora/presentation/providers/project_provider.dart';
import 'package:focora/domain/entities/task_entity.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';
import 'package:focora/domain/entities/project_entity.dart';

/// Sistema de mocks de contexto para simular diferentes estados da aplicação
class ContextMocks {
  /// Cria um contexto para usuário novo (primeira vez usando o app)
  static AppContextMock createNewUserContext() {
    return AppContextMock(
      name: 'Novo Usuário',
      description: 'Usuário que está usando o app pela primeira vez',
      taskProvider: _createEmptyTaskProvider(),
      energyProvider: _createEmptyEnergyProvider(),
      projectProvider: _createEmptyProjectProvider(),
    );
  }

  /// Cria um contexto para usuário produtivo (muitas tarefas e dados)
  static AppContextMock createProductiveUserContext() {
    return AppContextMock(
      name: 'Usuário Produtivo',
      description: 'Usuário ativo com muitas tarefas e registros de energia',
      taskProvider: _createProductiveTaskProvider(),
      energyProvider: _createActiveEnergyProvider(),
      projectProvider: _createActiveProjectProvider(),
    );
  }

  /// Cria um contexto para usuário procrastinador (tarefas atrasadas)
  static AppContextMock createProcrastinatorContext() {
    return AppContextMock(
      name: 'Usuário Procrastinador',
      description: 'Usuário com muitas tarefas atrasadas e baixa energia',
      taskProvider: _createProcrastinatorTaskProvider(),
      energyProvider: _createLowEnergyProvider(),
      projectProvider: _createStagnantProjectProvider(),
    );
  }

  /// Cria um contexto para usuário em recuperação (melhorando gradualmente)
  static AppContextMock createRecoveringUserContext() {
    return AppContextMock(
      name: 'Usuário em Recuperação',
      description: 'Usuário que está melhorando seus hábitos gradualmente',
      taskProvider: _createRecoveringTaskProvider(),
      energyProvider: _createImprovingEnergyProvider(),
      projectProvider: _createRecoveringProjectProvider(),
    );
  }

  /// Cria um contexto para usuário estressado (sobrecarga de trabalho)
  static AppContextMock createStressedUserContext() {
    return AppContextMock(
      name: 'Usuário Estressado',
      description: 'Usuário sobrecarregado com muitas tarefas urgentes',
      taskProvider: _createOverloadedTaskProvider(),
      energyProvider: _createStressedEnergyProvider(),
      projectProvider: _createOverloadedProjectProvider(),
    );
  }

  /// Cria um contexto para usuário equilibrado (estado ideal)
  static AppContextMock createBalancedUserContext() {
    return AppContextMock(
      name: 'Usuário Equilibrado',
      description: 'Usuário com bom equilíbrio entre trabalho e descanso',
      taskProvider: _createBalancedTaskProvider(),
      energyProvider: _createBalancedEnergyProvider(),
      projectProvider: _createBalancedProjectProvider(),
    );
  }

  // Métodos privados para criar providers específicos

  static MockTaskProvider _createEmptyTaskProvider() {
    final provider = MockTaskProvider();
    when(provider.tasks).thenReturn([]);
    when(provider.todayTasks).thenReturn([]);
    when(provider.inboxTasks).thenReturn([]);
    when(provider.inProgressTasks).thenReturn([]);
    when(provider.completedTasks).thenReturn([]);
    when(provider.overdueTasks).thenReturn([]);
    _setupAsyncMethods(provider);
    return provider;
  }

  static MockTaskProvider _createProductiveTaskProvider() {
    final provider = MockTaskProvider();
    final tasks = [
      _createTask('Revisar relatório mensal', TaskStatus.inProgress, TaskPriority.high, DateTime.now()),
      _createTask('Preparar apresentação', TaskStatus.inProgress, TaskPriority.medium, DateTime.now()),
      _createTask('Responder emails importantes', TaskStatus.completed, TaskPriority.medium),
      _createTask('Planejar próxima sprint', TaskStatus.inbox, TaskPriority.low),
      _createTask('Atualizar documentação', TaskStatus.completed, TaskPriority.low),
    ];
    
    when(provider.tasks).thenReturn(tasks);
    when(provider.todayTasks).thenReturn(tasks.where((t) => t.isDueToday && t.status != TaskStatus.completed).toList());
    when(provider.inboxTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.inbox).toList());
    when(provider.inProgressTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.inProgress).toList());
    when(provider.completedTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.completed).toList());
    when(provider.overdueTasks).thenReturn([]);
    _setupAsyncMethods(provider);
    return provider;
  }

  static MockTaskProvider _createProcrastinatorTaskProvider() {
    final provider = MockTaskProvider();
    final tasks = [
      _createTask('Tarefa atrasada há 3 dias', TaskStatus.inProgress, TaskPriority.high, DateTime.now().subtract(const Duration(days: 3))),
      _createTask('Projeto importante atrasado', TaskStatus.inProgress, TaskPriority.high, DateTime.now().subtract(const Duration(days: 5))),
      _createTask('Email urgente não respondido', TaskStatus.inbox, TaskPriority.high, DateTime.now().subtract(const Duration(days: 1))),
      _createTask('Relatório pendente', TaskStatus.inbox, TaskPriority.medium, DateTime.now().subtract(const Duration(days: 2))),
      _createTask('Limpeza da casa', TaskStatus.inbox, TaskPriority.low, DateTime.now().subtract(const Duration(days: 7))),
    ];
    
    when(provider.tasks).thenReturn(tasks);
    when(provider.todayTasks).thenReturn([]);
    when(provider.inboxTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.inbox).toList());
    when(provider.inProgressTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.inProgress).toList());
    when(provider.completedTasks).thenReturn([]);
    when(provider.overdueTasks).thenReturn(tasks.where((t) => t.isOverdue).toList());
    _setupAsyncMethods(provider);
    return provider;
  }

  static MockTaskProvider _createRecoveringTaskProvider() {
    final provider = MockTaskProvider();
    final tasks = [
      _createTask('Exercício matinal', TaskStatus.completed, TaskPriority.medium, DateTime.now()),
      _createTask('Meditar 10 minutos', TaskStatus.completed, TaskPriority.low, DateTime.now()),
      _createTask('Organizar mesa de trabalho', TaskStatus.inProgress, TaskPriority.low, DateTime.now()),
      _createTask('Ler 20 páginas do livro', TaskStatus.inProgress, TaskPriority.low, DateTime.now()),
      _createTask('Planejar semana', TaskStatus.inbox, TaskPriority.medium),
    ];
    
    when(provider.tasks).thenReturn(tasks);
    when(provider.todayTasks).thenReturn(tasks.where((t) => t.isDueToday && t.status != TaskStatus.completed).toList());
    when(provider.inboxTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.inbox).toList());
    when(provider.inProgressTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.inProgress).toList());
    when(provider.completedTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.completed).toList());
    when(provider.overdueTasks).thenReturn([]);
    _setupAsyncMethods(provider);
    return provider;
  }

  static MockTaskProvider _createOverloadedTaskProvider() {
    final provider = MockTaskProvider();
    final tasks = [
      _createTask('Apresentação para CEO', TaskStatus.inProgress, TaskPriority.high, DateTime.now()),
      _createTask('Corrigir bug crítico', TaskStatus.inProgress, TaskPriority.high, DateTime.now()),
      _createTask('Reunião com cliente', TaskStatus.inProgress, TaskPriority.high, DateTime.now()),
      _createTask('Revisar código da equipe', TaskStatus.inbox, TaskPriority.high),
      _createTask('Atualizar sistema', TaskStatus.inbox, TaskPriority.high),
      _createTask('Responder 15 emails', TaskStatus.inbox, TaskPriority.medium),
      _createTask('Preparar relatório semanal', TaskStatus.inbox, TaskPriority.medium),
      _createTask('Organizar documentos', TaskStatus.inbox, TaskPriority.low),
    ];
    
    when(provider.tasks).thenReturn(tasks);
    when(provider.todayTasks).thenReturn(tasks.where((t) => t.isDueToday && t.status != TaskStatus.completed).toList());
    when(provider.inboxTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.inbox).toList());
    when(provider.inProgressTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.inProgress).toList());
    when(provider.completedTasks).thenReturn([]);
    when(provider.overdueTasks).thenReturn([]);
    _setupAsyncMethods(provider);
    return provider;
  }

  static MockTaskProvider _createBalancedTaskProvider() {
    final provider = MockTaskProvider();
    final tasks = [
      _createTask('Revisar projeto principal', TaskStatus.inProgress, TaskPriority.high, DateTime.now()),
      _createTask('Exercitar-se', TaskStatus.completed, TaskPriority.medium, DateTime.now()),
      _createTask('Ler artigo técnico', TaskStatus.inProgress, TaskPriority.low, DateTime.now()),
      _createTask('Planejar fim de semana', TaskStatus.inbox, TaskPriority.low),
      _createTask('Ligar para família', TaskStatus.completed, TaskPriority.medium, DateTime.now()),
    ];
    
    when(provider.tasks).thenReturn(tasks);
    when(provider.todayTasks).thenReturn(tasks.where((t) => t.isDueToday && t.status != TaskStatus.completed).toList());
    when(provider.inboxTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.inbox).toList());
    when(provider.inProgressTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.inProgress).toList());
    when(provider.completedTasks).thenReturn(tasks.where((t) => t.status == TaskStatus.completed).toList());
    when(provider.overdueTasks).thenReturn([]);
    _setupAsyncMethods(provider);
    return provider;
  }

  static MockEnergyProvider _createEmptyEnergyProvider() {
    final provider = MockEnergyProvider();
    when(provider.energyLogs).thenReturn([]);
    when(provider.todayLogs).thenReturn([]);
    when(provider.latestLog).thenReturn(null);
    when(provider.latestLogForCurrentPeriod).thenReturn(null);
    _setupEnergyAsyncMethods(provider);
    return provider;
  }

  static MockEnergyProvider _createActiveEnergyProvider() {
    final provider = MockEnergyProvider();
    final logs = [
      _createEnergyLog(DateTime.now(), FocoraDayPeriod.morning, 4, 4, 4),
      _createEnergyLog(DateTime.now(), FocoraDayPeriod.afternoon, 4, 3, 4),
      _createEnergyLog(DateTime.now().subtract(const Duration(days: 1)), FocoraDayPeriod.morning, 5, 4, 5),
    ];
    
    when(provider.energyLogs).thenReturn(logs);
    when(provider.todayLogs).thenReturn(logs.where((l) => l.isToday).toList());
    when(provider.latestLog).thenReturn(logs.first);
    when(provider.latestLogForCurrentPeriod).thenReturn(logs.first);
    _setupEnergyAsyncMethods(provider);
    return provider;
  }

  static MockEnergyProvider _createLowEnergyProvider() {
    final provider = MockEnergyProvider();
    final logs = [
      _createEnergyLog(DateTime.now(), FocoraDayPeriod.morning, 2, 2, 1),
      _createEnergyLog(DateTime.now(), FocoraDayPeriod.afternoon, 1, 1, 2),
      _createEnergyLog(DateTime.now().subtract(const Duration(days: 1)), FocoraDayPeriod.morning, 2, 1, 1),
    ];
    
    when(provider.energyLogs).thenReturn(logs);
    when(provider.todayLogs).thenReturn(logs.where((l) => l.isToday).toList());
    when(provider.latestLog).thenReturn(logs.first);
    when(provider.latestLogForCurrentPeriod).thenReturn(logs.first);
    _setupEnergyAsyncMethods(provider);
    return provider;
  }

  static MockEnergyProvider _createImprovingEnergyProvider() {
    final provider = MockEnergyProvider();
    final logs = [
      _createEnergyLog(DateTime.now(), FocoraDayPeriod.morning, 3, 3, 3),
      _createEnergyLog(DateTime.now().subtract(const Duration(days: 1)), FocoraDayPeriod.morning, 2, 2, 2),
      _createEnergyLog(DateTime.now().subtract(const Duration(days: 2)), FocoraDayPeriod.morning, 2, 1, 2),
    ];
    
    when(provider.energyLogs).thenReturn(logs);
    when(provider.todayLogs).thenReturn(logs.where((l) => l.isToday).toList());
    when(provider.latestLog).thenReturn(logs.first);
    when(provider.latestLogForCurrentPeriod).thenReturn(logs.first);
    _setupEnergyAsyncMethods(provider);
    return provider;
  }

  static MockEnergyProvider _createStressedEnergyProvider() {
    final provider = MockEnergyProvider();
    final logs = [
      _createEnergyLog(DateTime.now(), FocoraDayPeriod.morning, 2, 5, 2),
      _createEnergyLog(DateTime.now(), FocoraDayPeriod.afternoon, 1, 4, 1),
      _createEnergyLog(DateTime.now().subtract(const Duration(days: 1)), FocoraDayPeriod.morning, 2, 5, 2),
    ];
    
    when(provider.energyLogs).thenReturn(logs);
    when(provider.todayLogs).thenReturn(logs.where((l) => l.isToday).toList());
    when(provider.latestLog).thenReturn(logs.first);
    when(provider.latestLogForCurrentPeriod).thenReturn(logs.first);
    _setupEnergyAsyncMethods(provider);
    return provider;
  }

  static MockEnergyProvider _createBalancedEnergyProvider() {
    final provider = MockEnergyProvider();
    final logs = [
      _createEnergyLog(DateTime.now(), FocoraDayPeriod.morning, 4, 4, 4),
      _createEnergyLog(DateTime.now(), FocoraDayPeriod.afternoon, 3, 3, 4),
      _createEnergyLog(DateTime.now().subtract(const Duration(days: 1)), FocoraDayPeriod.morning, 4, 4, 4),
    ];
    
    when(provider.energyLogs).thenReturn(logs);
    when(provider.todayLogs).thenReturn(logs.where((l) => l.isToday).toList());
    when(provider.latestLog).thenReturn(logs.first);
    when(provider.latestLogForCurrentPeriod).thenReturn(logs.first);
    _setupEnergyAsyncMethods(provider);
    return provider;
  }

  static MockProjectProvider _createEmptyProjectProvider() {
    final provider = MockProjectProvider();
    when(provider.projects).thenReturn([]);
    when(provider.activeProjects).thenReturn([]);
    when(provider.completedProjects).thenReturn([]);
    when(provider.pausedProjects).thenReturn([]);
    when(provider.overdueProjects).thenReturn([]);
    return provider;
  }

  static MockProjectProvider _createActiveProjectProvider() {
    final provider = MockProjectProvider();
    final projects = [
      _createProject('Aplicativo Focora', ProjectStatus.active),
      _createProject('Website da Empresa', ProjectStatus.active),
      _createProject('Curso Online', ProjectStatus.completed),
    ];
    
    when(provider.projects).thenReturn(projects);
    when(provider.activeProjects).thenReturn(projects.where((p) => p.status == ProjectStatus.active).toList());
    when(provider.completedProjects).thenReturn(projects.where((p) => p.status == ProjectStatus.completed).toList());
    when(provider.pausedProjects).thenReturn([]);
    when(provider.overdueProjects).thenReturn([]);
    return provider;
  }

  static MockProjectProvider _createStagnantProjectProvider() {
    final provider = MockProjectProvider();
    final projects = [
      _createProject('Projeto Abandonado', ProjectStatus.paused),
      _createProject('Ideia Antiga', ProjectStatus.paused),
      _createProject('Projeto Atrasado', ProjectStatus.active, DateTime.now().subtract(const Duration(days: 30))),
    ];
    
    when(provider.projects).thenReturn(projects);
    when(provider.activeProjects).thenReturn(projects.where((p) => p.status == ProjectStatus.active).toList());
    when(provider.completedProjects).thenReturn([]);
    when(provider.pausedProjects).thenReturn(projects.where((p) => p.status == ProjectStatus.paused).toList());
    when(provider.overdueProjects).thenReturn(projects.where((p) => p.isOverdue).toList());
    return provider;
  }

  static MockProjectProvider _createRecoveringProjectProvider() {
    final provider = MockProjectProvider();
    final projects = [
      _createProject('Hábitos Saudáveis', ProjectStatus.active),
      _createProject('Organização Pessoal', ProjectStatus.active),
      _createProject('Projeto Antigo', ProjectStatus.completed),
    ];
    
    when(provider.projects).thenReturn(projects);
    when(provider.activeProjects).thenReturn(projects.where((p) => p.status == ProjectStatus.active).toList());
    when(provider.completedProjects).thenReturn(projects.where((p) => p.status == ProjectStatus.completed).toList());
    when(provider.pausedProjects).thenReturn([]);
    when(provider.overdueProjects).thenReturn([]);
    return provider;
  }

  static MockProjectProvider _createOverloadedProjectProvider() {
    final provider = MockProjectProvider();
    final projects = [
      _createProject('Projeto Urgente A', ProjectStatus.active, DateTime.now()),
      _createProject('Projeto Urgente B', ProjectStatus.active, DateTime.now()),
      _createProject('Projeto Urgente C', ProjectStatus.active, DateTime.now()),
      _createProject('Projeto Atrasado', ProjectStatus.active, DateTime.now().subtract(const Duration(days: 5))),
    ];
    
    when(provider.projects).thenReturn(projects);
    when(provider.activeProjects).thenReturn(projects.where((p) => p.status == ProjectStatus.active).toList());
    when(provider.completedProjects).thenReturn([]);
    when(provider.pausedProjects).thenReturn([]);
    when(provider.overdueProjects).thenReturn(projects.where((p) => p.isOverdue).toList());
    return provider;
  }

  static MockProjectProvider _createBalancedProjectProvider() {
    final provider = MockProjectProvider();
    final projects = [
      _createProject('Projeto Principal', ProjectStatus.active),
      _createProject('Projeto Pessoal', ProjectStatus.active),
      _createProject('Projeto Concluído', ProjectStatus.completed),
    ];
    
    when(provider.projects).thenReturn(projects);
    when(provider.activeProjects).thenReturn(projects.where((p) => p.status == ProjectStatus.active).toList());
    when(provider.completedProjects).thenReturn(projects.where((p) => p.status == ProjectStatus.completed).toList());
    when(provider.pausedProjects).thenReturn([]);
    when(provider.overdueProjects).thenReturn([]);
    return provider;
  }

  // Métodos auxiliares para criar entidades

  static TaskEntity _createTask(String title, TaskStatus status, TaskPriority priority, [DateTime? dueDate]) {
    return TaskEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      status: status,
      priority: priority,
      dueDate: dueDate,
    );
  }

  static EnergyLogEntity _createEnergyLog(DateTime date, FocoraDayPeriod period, int energy, int focus, int motivation) {
    return EnergyLogEntity(
      date: date,
      period: period,
      energyLevel: energy,
      focusLevel: focus,
      motivationLevel: motivation,
    );
  }

  static ProjectEntity _createProject(String name, ProjectStatus status, [DateTime? dueDate]) {
    return ProjectEntity(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      status: status,
      dueDate: dueDate,
    );
  }

  static void _setupAsyncMethods(MockTaskProvider provider) {
    when(provider.loadTasks()).thenAnswer((_) async {});
    when(provider.addSampleTasks()).thenAnswer((_) async {});
  }

  static void _setupEnergyAsyncMethods(MockEnergyProvider provider) {
    when(provider.loadEnergyLogs()).thenAnswer((_) async {});
    when(provider.addSampleEnergyLogs()).thenAnswer((_) async {});
  }
}

/// Representa um contexto mockado da aplicação
class AppContextMock {
  final String name;
  final String description;
  final MockTaskProvider taskProvider;
  final MockEnergyProvider energyProvider;
  final MockProjectProvider projectProvider;

  AppContextMock({
    required this.name,
    required this.description,
    required this.taskProvider,
    required this.energyProvider,
    required this.projectProvider,
  });

  /// Cria um MaterialApp com este contexto aplicado
  MaterialApp createTestApp({
    required Widget child,
    Map<String, WidgetBuilder>? routes,
  }) {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<TaskProvider>.value(value: taskProvider),
          ChangeNotifierProvider<EnergyProvider>.value(value: energyProvider),
          ChangeNotifierProvider<ProjectProvider>.value(value: projectProvider),
        ],
        child: child,
      ),
      routes: routes ?? {},
    );
  }

  @override
  String toString() {
    return 'AppContextMock(name: $name, description: $description)';
  }
}

// Classes para os mocks
class MockTaskProvider extends Mock implements TaskProvider {
  @override
  Future<void> addSampleTasks() async {}
}

class MockEnergyProvider extends Mock implements EnergyProvider {
  @override
  Future<void> addSampleEnergyLogs() async {}
}

class MockProjectProvider extends Mock implements ProjectProvider {
  @override
  List<ProjectEntity> get pausedProjects => [];
}
