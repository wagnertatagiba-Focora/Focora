import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:focora/data/models/task_model.dart';
import 'package:focora/data/models/project_model.dart';
import 'package:focora/data/models/energy_log_model.dart';
import 'package:focora/data/models/diagnosis_model.dart';
import 'package:focora/data/models/thought_model.dart';
import 'package:focora/data/models/idea_model.dart';

/// Serviço para inicialização e gerenciamento do Hive
class HiveService {
  /// Inicializa o Hive
  static Future<void> init() async {
    // Inicializa o Hive com o diretório de documentos
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);
    
    // Registra os adaptadores
    Hive.registerAdapter(TaskModelAdapter());
    Hive.registerAdapter(ProjectModelAdapter());
    Hive.registerAdapter(EnergyLogModelAdapter());
    Hive.registerAdapter(DiagnosisModelAdapter());
    Hive.registerAdapter(ThoughtModelAdapter());
    Hive.registerAdapter(IdeaModelAdapter());
    
    // Abre as caixas
    await Hive.openBox<TaskModel>('tasks');
    await Hive.openBox<ProjectModel>('projects');
    await Hive.openBox<EnergyLogModel>('energy_logs');
    await Hive.openBox<DiagnosisModel>('diagnoses');
    await Hive.openBox<ThoughtModel>('thoughts');
    await Hive.openBox<IdeaModel>('ideas');
    await Hive.openBox<bool>('settings');
  }
  
  /// Fecha o Hive
  static Future<void> close() async {
    await Hive.close();
  }
  
  /// Limpa todos os dados
  static Future<void> clearAll() async {
    await Hive.box<TaskModel>('tasks').clear();
    await Hive.box<ProjectModel>('projects').clear();
    await Hive.box<EnergyLogModel>('energy_logs').clear();
    await Hive.box<DiagnosisModel>('diagnoses').clear();
    await Hive.box<ThoughtModel>('thoughts').clear();
    await Hive.box<IdeaModel>('ideas').clear();
    await Hive.box<bool>('settings').clear();
  }
}
