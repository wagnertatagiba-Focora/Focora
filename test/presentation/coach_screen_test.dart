import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:focora/presentation/screens/coach/coach_screen.dart';
import 'package:focora/presentation/providers/thought_provider.dart';

// Gerar arquivo de mock
@GenerateMocks([ThoughtProvider])
import 'coach_screen_test.mocks.dart';

void main() {
  group('CoachScreen', () {
    late MockThoughtProvider mockThoughtProvider;

    setUp(() {
      mockThoughtProvider = MockThoughtProvider();
      
      // Configurar os mocks com dados vazios para simplificar os testes
      when(mockThoughtProvider.thoughts).thenReturn([]);
      when(mockThoughtProvider.recentThoughts).thenReturn([]);
      when(mockThoughtProvider.loadThoughts()).thenAnswer((_) async {});
      when(mockThoughtProvider.commonDistortions).thenReturn([]);
      when(mockThoughtProvider.commonEmotions).thenReturn([]);
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<ThoughtProvider>.value(
            value: mockThoughtProvider,
            child: const CoachScreen(),
          ),
        ),
      );
      
      // Act
      await tester.pump();
      
      // Assert
      expect(find.text('Coach Cognitivo'), findsOneWidget);
    });
  });
}
