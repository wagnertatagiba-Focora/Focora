import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:focora/presentation/screens/insights/insights_screen.dart';
import 'package:focora/presentation/providers/task_provider.dart';
import 'package:focora/presentation/providers/energy_provider.dart';

// Gerar arquivo de mock
@GenerateMocks([TaskProvider, EnergyProvider])
import 'insights_screen_test.mocks.dart';

void main() {
  group('InsightsScreen', () {
    late MockTaskProvider mockTaskProvider;
    late MockEnergyProvider mockEnergyProvider;

    setUp(() {
      mockTaskProvider = MockTaskProvider();
      mockEnergyProvider = MockEnergyProvider();
      
      // Configurar os mocks com dados vazios para simplificar os testes
      when(mockTaskProvider.tasks).thenReturn([]);
      when(mockTaskProvider.completedTasks).thenReturn([]);
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: MultiProvider(
            providers: [
              ChangeNotifierProvider<TaskProvider>.value(value: mockTaskProvider),
              ChangeNotifierProvider<EnergyProvider>.value(value: mockEnergyProvider),
            ],
            child: const InsightsScreen(),
          ),
        ),
      );
      
      // Act
      await tester.pump();
      
      // Assert
      expect(find.text('Insights'), findsOneWidget);
    });
  });
}
