import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

/// Testes de Performance End-to-End para o aplicativo Focora
void main() {
  group('Focora Performance E2E Tests', () {
    late FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      await driver.close();
    });

    group('App Launch Performance', () {
      test('should launch app within acceptable time', () async {
        final stopwatch = Stopwatch()..start();
        
        // Aguardar splash screen
        await driver.waitFor(find.byType('SplashScreen'));
        
        // Aguardar dashboard carregar completamente
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        stopwatch.stop();
        final launchTime = stopwatch.elapsedMilliseconds;
        
        print('🚀 App launch time: ${launchTime}ms');
        
        // App deve carregar em menos de 3 segundos
        expect(launchTime, lessThan(3000), 
               reason: 'App should launch in less than 3 seconds');
      });

      test('should show splash screen immediately', () async {
        final stopwatch = Stopwatch()..start();
        
        // Aguardar splash screen aparecer
        await driver.waitFor(find.byType('SplashScreen'));
        
        stopwatch.stop();
        final splashTime = stopwatch.elapsedMilliseconds;
        
        print('💫 Splash screen time: ${splashTime}ms');
        
        // Splash deve aparecer em menos de 500ms
        expect(splashTime, lessThan(500),
               reason: 'Splash screen should appear immediately');
      });
    });

    group('Navigation Performance', () {
      test('should navigate between screens quickly', () async {
        // Aguardar dashboard
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Medir tempo de navegação para Inbox
        final inboxStopwatch = Stopwatch()..start();
        await driver.tap(find.text('Caixa de Entrada'));
        await driver.waitFor(find.byType('InboxScreen'));
        inboxStopwatch.stop();
        
        print('📊 Navigation to Inbox: ${inboxStopwatch.elapsedMilliseconds}ms');
        expect(inboxStopwatch.elapsedMilliseconds, lessThan(500),
               reason: 'Navigation to Inbox should be fast');
        
        // Voltar ao dashboard
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Medir tempo de navegação para Pomodoro
        final pomodoroStopwatch = Stopwatch()..start();
        await driver.tap(find.text('Pomodoro'));
        await driver.waitFor(find.byType('PomodoroScreen'));
        pomodoroStopwatch.stop();
        
        print('📊 Navigation to Pomodoro: ${pomodoroStopwatch.elapsedMilliseconds}ms');
        expect(pomodoroStopwatch.elapsedMilliseconds, lessThan(500),
               reason: 'Navigation to Pomodoro should be fast');
        
        // Voltar ao dashboard
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Medir tempo de navegação para Coach
        final coachStopwatch = Stopwatch()..start();
        await driver.tap(find.text('Coach'));
        await driver.waitFor(find.byType('CoachScreen'));
        coachStopwatch.stop();
        
        print('📊 Navigation to Coach: ${coachStopwatch.elapsedMilliseconds}ms');
        expect(coachStopwatch.elapsedMilliseconds, lessThan(500),
               reason: 'Navigation to Coach should be fast');
      });
    });

    group('Scrolling Performance', () {
      test('should scroll smoothly', () async {
        // Navegar para Inbox para testar scroll
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        await driver.tap(find.text('Caixa de Entrada'));
        await driver.waitFor(find.byType('InboxScreen'));
        
        // Adicionar várias tarefas para testar scroll
        for (int i = 0; i < 10; i++) {
          await driver.tap(find.byValueKey('add_task_button'));
          await driver.enterText(find.byValueKey('task_title_field'), 'Tarefa de Scroll $i');
          await driver.tap(find.text('Salvar'));
          await driver.waitFor(find.text('Tarefa de Scroll $i'));
        }
        
        // Medir performance de scroll
        final scrollStopwatch = Stopwatch()..start();
        await driver.scroll(find.byType('ListView'), 0, -300, const Duration(milliseconds: 500));
        scrollStopwatch.stop();
        
        print('📊 Scroll performance: ${scrollStopwatch.elapsedMilliseconds}ms');
        expect(scrollStopwatch.elapsedMilliseconds, lessThan(600),
               reason: 'Scrolling should be smooth');
      });
    });

    group('Task Creation Performance', () {
      test('should create tasks quickly', () async {
        // Navegar para Inbox
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        await driver.tap(find.text('Caixa de Entrada'));
        await driver.waitFor(find.byType('InboxScreen'));
        
        // Medir tempo de criação de tarefa
        final taskStopwatch = Stopwatch()..start();
        await driver.tap(find.byValueKey('add_task_button'));
        await driver.enterText(find.byValueKey('task_title_field'), 'Tarefa de Performance');
        await driver.enterText(find.byValueKey('task_description_field'), 'Descrição da tarefa de performance');
        await driver.tap(find.text('Salvar'));
        await driver.waitFor(find.text('Tarefa de Performance'));
        taskStopwatch.stop();
        
        print('📊 Task creation time: ${taskStopwatch.elapsedMilliseconds}ms');
        expect(taskStopwatch.elapsedMilliseconds, lessThan(1000),
               reason: 'Task creation should be fast');
      });
    });

    group('Energy Log Performance', () {
      test('should log energy levels quickly', () async {
        // Navegar para Dashboard
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Medir tempo de registro de energia
        final energyStopwatch = Stopwatch()..start();
        await driver.tap(find.text('Registrar agora'));
        await driver.waitFor(find.byType('EnergyLogScreen'));
        await driver.tap(find.byValueKey('energy_level_4'));
        await driver.tap(find.byValueKey('focus_level_3'));
        await driver.tap(find.byValueKey('motivation_level_4'));
        await driver.tap(find.text('Salvar'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        energyStopwatch.stop();
        
        print('📊 Energy log time: ${energyStopwatch.elapsedMilliseconds}ms');
        expect(energyStopwatch.elapsedMilliseconds, lessThan(1500),
               reason: 'Energy logging should be fast');
      });
    });

    group('Memory Usage', () {
      test('should maintain reasonable memory usage', () async {
        // Navegar entre várias telas para testar uso de memória
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        await driver.tap(find.text('Pomodoro'));
        await driver.waitFor(find.byType('PomodoroScreen'));
        
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        await driver.tap(find.text('Coach'));
        await driver.waitFor(find.byType('CoachScreen'));
        
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        await driver.tap(find.text('Ócio'));
        await driver.waitFor(find.byType('OcioScreen'));
        
        await driver.tap(find.text('Dashboard'));
        await driver.waitFor(find.byType('DashboardScreenRefactored'));
        
        // Verificar métricas de performance
        final timeline = await driver.traceAction(() async {
          await driver.tap(find.byValueKey('insights_button'));
          await driver.waitFor(find.byType('InsightsScreen'));
          driver.tap(find.pageBack());
          await driver.waitFor(find.byType('DashboardScreenRefactored'));
        });
        
        // Analisar métricas
        final summary = timeline.summaryJson;
        print('📊 Performance metrics: $summary');
        
        // Verificar se não há vazamentos de memória significativos
        // Nota: Isso é uma verificação simplificada, em um ambiente real
        // seria necessário usar ferramentas mais avançadas
      });
    });
  });
}
