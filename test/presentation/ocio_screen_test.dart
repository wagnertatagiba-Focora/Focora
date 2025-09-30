import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:focora/presentation/screens/ocio/ocio_screen.dart';
import 'package:focora/presentation/providers/idea_provider.dart';

// Gerar arquivo de mock
@GenerateMocks([IdeaProvider])
import 'ocio_screen_test.mocks.dart';

void main() {
  group('OcioScreen', () {
    late MockIdeaProvider mockIdeaProvider;

    setUp(() {
      mockIdeaProvider = MockIdeaProvider();
      
      // Configurar os mocks com dados vazios para simplificar os testes
      when(mockIdeaProvider.ideas).thenReturn([]);
      when(mockIdeaProvider.loadIdeas()).thenAnswer((_) async {});
    });

    testWidgets('should render without errors', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider<IdeaProvider>.value(
            value: mockIdeaProvider,
            child: const OcioScreen(),
          ),
        ),
      );
      
      // Act
      await tester.pump();
      
      // Assert
      expect(find.text('Ócio Criativo'), findsOneWidget);
    });
  });
}
