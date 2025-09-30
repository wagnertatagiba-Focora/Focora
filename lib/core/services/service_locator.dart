import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:focora/data/repositories/task_repository.dart';
import 'package:focora/data/repositories/project_repository.dart';
import 'package:focora/data/repositories/energy_log_repository.dart';
import 'package:focora/data/repositories/thought_repository.dart';
import 'package:focora/data/repositories/idea_repository.dart';
import 'package:focora/data/repositories/diagnosis_repository.dart';
import 'package:focora/data/models/task_model.dart';
import 'package:focora/data/models/project_model.dart';
import 'package:focora/data/models/energy_log_model.dart';
import 'package:focora/data/models/thought_model.dart';
import 'package:focora/data/models/idea_model.dart';
import 'package:focora/data/models/diagnosis_model.dart';

/// Instância global do GetIt para injeção de dependência
final GetIt serviceLocator = GetIt.instance;

/// Inicializa o serviço de injeção de dependência
Future<void> setupServiceLocator() async {
  // Registrar boxes do Hive
  serviceLocator.registerSingletonAsync<Box<TaskModel>>(
    () async => Hive.box<TaskModel>('tasks'),
  );
  
  serviceLocator.registerSingletonAsync<Box<ProjectModel>>(
    () async => Hive.box<ProjectModel>('projects'),
  );
  
  serviceLocator.registerSingletonAsync<Box<EnergyLogModel>>(
    () async => Hive.box<EnergyLogModel>('energy_logs'),
  );
  
  serviceLocator.registerSingletonAsync<Box<ThoughtModel>>(
    () async => Hive.box<ThoughtModel>('thoughts'),
  );
  
  serviceLocator.registerSingletonAsync<Box<IdeaModel>>(
    () async => Hive.box<IdeaModel>('ideas'),
  );
  
  serviceLocator.registerSingletonAsync<Box<DiagnosisModel>>(
    () async => Hive.box<DiagnosisModel>('diagnoses'),
  );
  
  // Aguardar a inicialização das boxes
  await serviceLocator.allReady();
  
  // Registrar repositórios
  serviceLocator.registerLazySingleton<TaskRepository>(
    () => TaskRepository(serviceLocator<Box<TaskModel>>()),
  );
  
  serviceLocator.registerLazySingleton<ProjectRepository>(
    () => ProjectRepository(serviceLocator<Box<ProjectModel>>()),
  );
  
  serviceLocator.registerLazySingleton<EnergyLogRepository>(
    () => EnergyLogRepository(serviceLocator<Box<EnergyLogModel>>()),
  );
  
  serviceLocator.registerLazySingleton<ThoughtRepository>(
    () => ThoughtRepository(serviceLocator<Box<ThoughtModel>>()),
  );
  
  serviceLocator.registerLazySingleton<IdeaRepository>(
    () => IdeaRepository(serviceLocator<Box<IdeaModel>>()),
  );
  
  serviceLocator.registerLazySingleton<DiagnosisRepository>(
    () => DiagnosisRepository(serviceLocator<Box<DiagnosisModel>>()),
  );
}
