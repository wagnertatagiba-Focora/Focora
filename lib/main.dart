import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:focora/app/app.dart';
import 'package:focora/data/services/hive_service.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:focora/presentation/providers/project_provider.dart';
import 'package:focora/presentation/providers/energy_provider.dart';
import 'package:focora/presentation/providers/diagnosis_provider.dart';
import 'package:focora/presentation/providers/thought_provider.dart';
import 'package:focora/presentation/providers/idea_provider.dart';
import 'package:focora/core/services/service_locator.dart';
import 'package:focora/data/repositories/task_repository.dart';
import 'package:focora/data/repositories/project_repository.dart';
import 'package:focora/data/repositories/energy_log_repository.dart';
import 'package:focora/data/repositories/diagnosis_repository.dart';
import 'package:focora/data/repositories/thought_repository.dart';
import 'package:focora/data/repositories/idea_repository.dart';

/// Ponto de entrada do aplicativo Focora
void main() async {
  // Garantir que os widgets do Flutter estejam inicializados
  WidgetsFlutterBinding.ensureInitialized();
  
  // Carregar variáveis de ambiente
  try {
    await dotenv.load(fileName: '.env.development');
  } catch (e) {
    // Criar um arquivo .env.development vazio se não existir
    debugPrint('Arquivo .env.development não encontrado. Usando configurações padrão.');
  }
  
  // Inicializar o Hive
  await HiveService.init();
  
  // Configurar o serviço de injeção de dependência
  await setupServiceLocator();
  
  // Adicionar dados de exemplo para desenvolvimento
  final taskRepository = serviceLocator<TaskRepository>();
  final projectRepository = serviceLocator<ProjectRepository>();
  final energyLogRepository = serviceLocator<EnergyLogRepository>();
  final diagnosisRepository = serviceLocator<DiagnosisRepository>();
  final thoughtRepository = serviceLocator<ThoughtRepository>();
  final ideaRepository = serviceLocator<IdeaRepository>();
  
  await taskRepository.addSampleTasks();
  await projectRepository.addSampleProjects();
  await energyLogRepository.addSampleEnergyLogs();
  await diagnosisRepository.addSampleDiagnosis();
  await thoughtRepository.addSampleThoughts();
  await ideaRepository.addSampleIdeas();
  
  // Iniciar o aplicativo com os providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TaskProvider(taskRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectProvider(projectRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => EnergyProvider(energyLogRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => DiagnosisProvider(diagnosisRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ThoughtProvider(thoughtRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => IdeaProvider(ideaRepository),
        ),
      ],
      child: const FocoraApp(),
    ),
  );
}
