import 'package:flutter/material.dart';

/// NavigatorObserver personalizado para testes de navegação
class TestNavigatorObserver extends NavigatorObserver {
  /// Lista de rotas que foram navegadas
  final List<String> navigatedRoutes = [];
  
  /// Lista de rotas que foram removidas
  final List<String> removedRoutes = [];
  
  /// Lista de rotas que foram substituídas
  final List<NavigationEvent> navigationEvents = [];
  
  /// Rota atual
  String? currentRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    
    final routeName = route.settings.name ?? 'unknown';
    navigatedRoutes.add(routeName);
    currentRoute = routeName;
    
    navigationEvents.add(NavigationEvent(
      type: NavigationType.push,
      routeName: routeName,
      previousRoute: previousRoute?.settings.name,
    ));
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    
    final routeName = route.settings.name ?? 'unknown';
    removedRoutes.add(routeName);
    currentRoute = previousRoute?.settings.name;
    
    navigationEvents.add(NavigationEvent(
      type: NavigationType.pop,
      routeName: routeName,
      previousRoute: previousRoute?.settings.name,
    ));
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    
    final newRouteName = newRoute?.settings.name ?? 'unknown';
    final oldRouteName = oldRoute?.settings.name ?? 'unknown';
    
    removedRoutes.add(oldRouteName);
    navigatedRoutes.add(newRouteName);
    currentRoute = newRouteName;
    
    navigationEvents.add(NavigationEvent(
      type: NavigationType.replace,
      routeName: newRouteName,
      previousRoute: oldRouteName,
    ));
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    
    final routeName = route.settings.name ?? 'unknown';
    removedRoutes.add(routeName);
    currentRoute = previousRoute?.settings.name;
    
    navigationEvents.add(NavigationEvent(
      type: NavigationType.remove,
      routeName: routeName,
      previousRoute: previousRoute?.settings.name,
    ));
  }

  /// Verifica se uma rota específica foi navegada
  bool hasNavigatedTo(String routeName) {
    return navigatedRoutes.contains(routeName);
  }

  /// Verifica se uma rota específica foi removida
  bool hasRemovedRoute(String routeName) {
    return removedRoutes.contains(routeName);
  }

  /// Obtém o número de vezes que uma rota foi navegada
  int getNavigationCount(String routeName) {
    return navigatedRoutes.where((route) => route == routeName).length;
  }

  /// Obtém o último evento de navegação
  NavigationEvent? get lastNavigationEvent {
    return navigationEvents.isNotEmpty ? navigationEvents.last : null;
  }

  /// Obtém todos os eventos de navegação de um tipo específico
  List<NavigationEvent> getEventsByType(NavigationType type) {
    return navigationEvents.where((event) => event.type == type).toList();
  }

  /// Verifica se a navegação seguiu uma sequência específica
  bool hasNavigationSequence(List<String> expectedSequence) {
    if (expectedSequence.length > navigatedRoutes.length) {
      return false;
    }
    
    for (int i = 0; i <= navigatedRoutes.length - expectedSequence.length; i++) {
      bool matches = true;
      for (int j = 0; j < expectedSequence.length; j++) {
        if (navigatedRoutes[i + j] != expectedSequence[j]) {
          matches = false;
          break;
        }
      }
      if (matches) return true;
    }
    
    return false;
  }

  /// Limpa todos os registros de navegação
  void clear() {
    navigatedRoutes.clear();
    removedRoutes.clear();
    navigationEvents.clear();
    currentRoute = null;
  }

  /// Obtém um resumo das navegações para debug
  String getNavigationSummary() {
    final buffer = StringBuffer();
    buffer.writeln('=== Navigation Summary ===');
    buffer.writeln('Current Route: $currentRoute');
    buffer.writeln('Total Navigations: ${navigatedRoutes.length}');
    buffer.writeln('Total Removals: ${removedRoutes.length}');
    buffer.writeln('Navigation History: ${navigatedRoutes.join(' -> ')}');
    buffer.writeln('Events:');
    
    for (final event in navigationEvents) {
      buffer.writeln('  ${event.type.name}: ${event.routeName}');
    }
    
    return buffer.toString();
  }
}

/// Tipos de eventos de navegação
enum NavigationType {
  push,
  pop,
  replace,
  remove,
}

/// Representa um evento de navegação
class NavigationEvent {
  final NavigationType type;
  final String routeName;
  final String? previousRoute;
  final DateTime timestamp;

  NavigationEvent({
    required this.type,
    required this.routeName,
    this.previousRoute,
  }) : timestamp = DateTime.now();

  @override
  String toString() {
    return 'NavigationEvent(type: $type, route: $routeName, previous: $previousRoute, time: $timestamp)';
  }
}

/// Helper para criar um MaterialApp com NavigatorObserver para testes
class NavigationTestHelper {
  static TestNavigatorObserver? _observer;
  
  /// Obtém o observer atual
  static TestNavigatorObserver get observer {
    _observer ??= TestNavigatorObserver();
    return _observer!;
  }

  /// Cria um MaterialApp configurado para testes de navegação
  static MaterialApp createTestApp({
    required Widget home,
    Map<String, WidgetBuilder>? routes,
    String? initialRoute,
    RouteFactory? onGenerateRoute,
    RouteFactory? onUnknownRoute,
    List<NavigatorObserver>? additionalObservers,
  }) {
    final testObserver = TestNavigatorObserver();
    _observer = testObserver;
    
    final observers = <NavigatorObserver>[testObserver];
    if (additionalObservers != null) {
      observers.addAll(additionalObservers);
    }

    return MaterialApp(
      home: home,
      routes: routes ?? {},
      initialRoute: initialRoute,
      onGenerateRoute: onGenerateRoute,
      onUnknownRoute: onUnknownRoute,
      navigatorObservers: observers,
    );
  }

  /// Limpa o observer atual
  static void clearObserver() {
    _observer?.clear();
    _observer = null;
  }
}
