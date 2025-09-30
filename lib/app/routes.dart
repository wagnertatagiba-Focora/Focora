import 'package:flutter/material.dart';
import 'package:focora/presentation/screens/auth/splash_screen.dart';
import 'package:focora/presentation/screens/dashboard/dashboard_screen.dart';
import 'package:focora/presentation/screens/energy/energy_log_screen.dart';
import 'package:focora/presentation/screens/inbox/inbox_screen.dart';
import 'package:focora/presentation/screens/onboarding/diagnosis_result_screen.dart';
import 'package:focora/presentation/screens/onboarding/diagnosis_screen.dart';
import 'package:focora/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:focora/presentation/screens/pomodoro/pomodoro_screen.dart';
import 'package:focora/presentation/screens/coach/coach_screen.dart';
import 'package:focora/presentation/screens/ocio/ocio_screen.dart';
import 'package:focora/presentation/screens/insights/insights_screen.dart';

/// Classe que define as rotas do aplicativo Focora
class AppRoutes {
  // Rotas de autenticação
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String diagnosis = '/diagnosis';
  static const String diagnosisResult = '/diagnosis-result';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  
  // Rotas principais
  static const String home = '/home';
  static const String dashboard = '/dashboard';
  
  // Rotas de tarefas
  static const String inbox = '/inbox';
  static const String taskDetail = '/task-detail';
  static const String processTask = '/process-task';
  static const String eisenhowerMatrix = '/eisenhower-matrix';
  static const String projects = '/projects';
  static const String projectDetail = '/project-detail';
  
  // Rotas de foco
  static const String pomodoro = '/pomodoro';
  static const String pomodoroSettings = '/pomodoro-settings';
  
  // Rotas de energia
  static const String energyLog = '/energy-log';
  static const String energyHistory = '/energy-history';
  
  // Rotas do coach cognitivo
  static const String coach = '/coach';
  static const String thoughtDiary = '/thought-diary';
  static const String fiveWhys = '/five-whys';
  
  // Rotas do ócio criativo
  static const String ocio = '/ocio';
  static const String ideaCapture = '/idea-capture';
  
  // Rotas de insights
  static const String insights = '/insights';
  static const String energyTrends = '/energy-trends';
  static const String productivityStats = '/productivity-stats';
  
  // Rotas de configurações
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  
  /// Retorna as rotas do aplicativo
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      splash: (context) => const SplashScreen(),
      onboarding: (context) => const OnboardingScreen(),
      diagnosis: (context) => const DiagnosisScreen(),
      diagnosisResult: (context) => const DiagnosisResultScreen(),
      dashboard: (context) => const DashboardScreen(),
      inbox: (context) => const InboxScreen(),
      pomodoro: (context) => const PomodoroScreen(),
      energyLog: (context) => const EnergyLogScreen(),
      coach: (context) => const CoachScreen(),
      ocio: (context) => const OcioScreen(),
      insights: (context) => const InsightsScreen(),
      // Outras rotas serão adicionadas conforme o desenvolvimento avança
    };
  }
}
