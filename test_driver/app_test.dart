import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

/// Testes End-to-End para o aplicativo Focora
void main() {
  group('Focora E2E Tests', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });

    group('App Launch and Navigation', () {
      test('should launch app and show splash screen', () async {
        // Aguardar o splash screen aparecer
        await driver.waitFor(find.byType('SplashScreen'));
        
        // Aguardar a navegação para o onboarding ou dashboard
        await driver.waitFor(find.byType('OnboardingScreen'), timeout: const Duration(seconds: 10));
      });

      test('should complete onboarding flow', () async {
        // Aguardar tela de onboarding
        await driver.waitFor(find.byType('OnboardingScreen'));
        
        // Navegar através das telas de onboarding
        await driver.tap(find.text('Começar'));
        await driver.waitFor(find.byType('DiagnosisScreen'));
        
        // Completar diagnóstico (responder algumas perguntas)
        await driver.tap(find.text('Sempre'));
        await driver.tap(find.text('Próxima'));
        
        await driver.tap(find.text('Frequentemente'));
        await driver.tap(find.text('Próxima'));
        
        await driver.tap(find.text('Às vezes'));
        await driver.tap(find.text('Finalizar'));
        
        // Aguardar resultado do diagnóstico
        await driver.waitFor(find.byType('DiagnosisResultScreen'));
        await driver.tap(find.text('Continuar'));
        
        // Deve chegar ao dashboard
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
      });
    });

    group('Dashboard Functionality', () {
      test('should display dashboard sections', () async {
        // Aguardar dashboard carregar
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Verificar seções principais
        await driver.waitFor(find.text('Como está sua energia?'));
        await driver.waitFor(find.text('Para hoje'));
        await driver.waitFor(find.text('Caixa de entrada'));
        await driver.waitFor(find.text('Em andamento'));
      });

      test('should register energy level', () async {
        // Aguardar dashboard
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Tocar em "Registrar agora"
        await driver.tap(find.text('Registrar agora'));
        
        // Aguardar tela de registro de energia
        await driver.waitFor(find.byType('EnergyLogScreen'));
        
        // Selecionar níveis de energia
        await driver.tap(find.byValueKey('energy_level_4'));
        await driver.tap(find.byValueKey('focus_level_4'));
        await driver.tap(find.byValueKey('motivation_level_3'));
        
        // Salvar registro
        await driver.tap(find.text('Salvar'));
        
        // Deve voltar ao dashboard
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Verificar se o card de energia apareceu
        await driver.waitFor(find.byValueKey('energy_card'));
      });

      test('should add new task to inbox', () async {
        // Aguardar dashboard
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Navegar para inbox
        await driver.tap(find.text('Caixa de Entrada'));
        await driver.waitFor(find.byType('InboxScreen'));
        
        // Adicionar nova tarefa
        await driver.tap(find.byValueKey('add_task_button'));
        
        // Preencher formulário de tarefa
        await driver.enterText(find.byValueKey('task_title_field'), 'Tarefa de Teste E2E');
        await driver.enterText(find.byValueKey('task_description_field'), 'Descrição da tarefa criada no teste E2E');
        
        // Selecionar prioridade
        await driver.tap(find.byValueKey('priority_medium'));
        
        // Salvar tarefa
        await driver.tap(find.text('Salvar'));
        
        // Verificar se a tarefa apareceu na lista
        await driver.waitFor(find.text('Tarefa de Teste E2E'));
      });
    });

    group('Navigation Flow', () {
      test('should navigate through all main screens', () async {
        // Aguardar dashboard
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Navegar para Pomodoro
        await driver.tap(find.text('Pomodoro'));
        await driver.waitFor(find.byType('PomodoroScreen'));
        
        // Voltar ao dashboard
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Navegar para Coach
        await driver.tap(find.text('Coach'));
        await driver.waitFor(find.byType('CoachScreen'));
        
        // Voltar ao dashboard
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Navegar para Ócio
        await driver.tap(find.text('Ócio'));
        await driver.waitFor(find.byType('OcioScreen'));
        
        // Voltar ao dashboard
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Navegar para Insights
        await driver.tap(find.byValueKey('insights_button'));
        await driver.waitFor(find.byType('InsightsScreen'));
        
        // Voltar ao dashboard
        driver.tap(find.pageBack());
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
      });

      test('should handle deep navigation flows', () async {
        // Aguardar dashboard
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Fluxo: Dashboard -> Inbox -> Add Task -> Back to Inbox -> Back to Dashboard
        await driver.tap(find.text('Caixa de Entrada'));
        await driver.waitFor(find.byType('InboxScreen'));
        
        await driver.tap(find.byValueKey('add_task_button'));
        await driver.enterText(find.byValueKey('task_title_field'), 'Tarefa de Navegação');
        await driver.tap(find.text('Salvar'));
        
        await driver.waitFor(find.text('Tarefa de Navegação'));
        
        // Voltar ao dashboard
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Verificar se a tarefa aparece no dashboard
        await driver.waitFor(find.text('Tarefa de Navegação'));
      });
    });

    group('Pomodoro Flow', () {
      test('should start and complete pomodoro session', () async {
        // Aguardar dashboard
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Navegar para Pomodoro
        await driver.tap(find.text('Pomodoro'));
        await driver.waitFor(find.byType('PomodoroScreen'));
        
        // Verificar estado inicial
        await driver.waitFor(find.text('25:00'));
        await driver.waitFor(find.text('Iniciar'));
        
        // Iniciar sessão Pomodoro
        await driver.tap(find.text('Iniciar'));
        
        // Verificar que o timer começou
        await driver.waitFor(find.text('Pausar'));
        
        // Aguardar alguns segundos para ver o timer funcionando
        await Future.delayed(const Duration(seconds: 3));
        
        // Pausar sessão
        await driver.tap(find.text('Pausar'));
        
        // Verificar que o timer pausou
        await driver.waitFor(find.text('Continuar'));
        
        // Reiniciar sessão
        await driver.tap(find.text('Reiniciar'));
        
        // Verificar que voltou ao estado inicial
        await driver.waitFor(find.text('25:00'));
        await driver.waitFor(find.text('Iniciar'));
      });
    });

    group('Coach Flow', () {
      test('should add and view thoughts', () async {
        // Aguardar dashboard
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Navegar para Coach
        await driver.tap(find.text('Coach'));
        await driver.waitFor(find.byType('CoachScreen'));
        
        // Adicionar novo pensamento
        await driver.tap(find.byValueKey('add_thought_button'));
        
        // Preencher formulário de pensamento
        await driver.enterText(find.byValueKey('thought_content_field'), 'Pensamento de teste E2E');
        await driver.tap(find.byValueKey('thought_type_negative'));
        
        // Salvar pensamento
        await driver.tap(find.text('Salvar'));
        
        // Verificar se o pensamento apareceu na lista
        await driver.waitFor(find.text('Pensamento de teste E2E'));
        
        // Abrir detalhes do pensamento
        await driver.tap(find.text('Pensamento de teste E2E'));
        
        // Verificar tela de detalhes
        await driver.waitFor(find.byValueKey('thought_detail_screen'));
        
        // Voltar para a lista
        driver.tap(find.pageBack());
        await driver.waitFor(find.byType('CoachScreen'));
      });
    });

    group('Insights Flow', () {
      test('should view insights data', () async {
        // Aguardar dashboard
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Navegar para Insights
        await driver.tap(find.byValueKey('insights_button'));
        await driver.waitFor(find.byType('InsightsScreen'));
        
        // Verificar elementos da tela
        await driver.waitFor(find.text('Produtividade'));
        await driver.waitFor(find.text('Energia'));
        
        // Mudar período de análise
        await driver.tap(find.text('Semana'));
        await driver.waitFor(find.text('Mês'));
        await driver.tap(find.text('Mês'));
        
        // Voltar ao dashboard
        driver.tap(find.pageBack());
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
      });
    });
  });
}
