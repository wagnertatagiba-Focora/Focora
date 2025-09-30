import 'package:flutter/material.dart';
import 'package:focora/app/routes.dart';
import 'package:focora/app/theme.dart';

/// Tela de onboarding do aplicativo Focora
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  /// Controlador do PageView
  final PageController _pageController = PageController();
  
  /// Índice da página atual
  int _currentPage = 0;
  
  /// Lista de páginas do onboarding
  final List<OnboardingPage> _pages = [
    OnboardingPage(
      title: 'Bem-vindo ao Focora',
      description: 'Transforme sua relação com a produtividade e supere a procrastinação de uma vez por todas.',
      image: 'assets/images/onboarding_1.png',
      color: FocoraTheme.primaryColor,
    ),
    OnboardingPage(
      title: 'Entenda seu Perfil',
      description: 'Descubra seu tipo de procrastinador e receba estratégias personalizadas para suas necessidades específicas.',
      image: 'assets/images/onboarding_2.png',
      color: FocoraTheme.secondaryColor,
    ),
    OnboardingPage(
      title: 'Organize suas Tarefas',
      description: 'Capture, processe e organize suas tarefas com um sistema inspirado na metodologia GTD (Getting Things Done).',
      image: 'assets/images/onboarding_3.png',
      color: FocoraTheme.accentColor,
    ),
    OnboardingPage(
      title: 'Mantenha o Foco',
      description: 'Use o timer Pomodoro e outras técnicas comprovadas para manter o foco e aumentar sua produtividade.',
      image: 'assets/images/onboarding_4.png',
      color: FocoraTheme.tertiaryColor,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Páginas de onboarding
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _buildPage(_pages[index]);
            },
          ),
          
          // Indicadores de página
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => _buildDotIndicator(index),
              ),
            ),
          ),
          
          // Botões de navegação
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Botão Pular
                if (_currentPage < _pages.length - 1)
                  TextButton(
                    onPressed: () {
                      _pageController.animateToPage(
                        _pages.length - 1,
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: const Text('Pular'),
                  )
                else
                  const SizedBox(width: 80),
                
                // Botão Próximo ou Começar
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _pages.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      // Navegar para a tela de diagnóstico
                      Navigator.pushReplacementNamed(
                        context,
                        AppRoutes.diagnosis,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    backgroundColor: _pages[_currentPage].color,
                  ),
                  child: Text(
                    _currentPage < _pages.length - 1 ? 'Próximo' : 'Começar',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Constrói uma página de onboarding
  Widget _buildPage(OnboardingPage page) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            page.color.withOpacity(0.8),
            page.color.withOpacity(0.6),
            page.color.withOpacity(0.4),
            Colors.white,
          ],
          stops: const [0.0, 0.3, 0.6, 1.0],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Imagem
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(top: 60),
              child: Image.asset(
                page.image,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  // Placeholder para quando a imagem não estiver disponível
                  return Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      color: page.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.image,
                      size: 80,
                      color: page.color,
                    ),
                  );
                },
              ),
            ),
          ),
          
          // Conteúdo
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  page.title,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: FocoraTheme.textPrimaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  page.description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: FocoraTheme.textSecondaryColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  /// Constrói um indicador de página
  Widget _buildDotIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: _currentPage == index ? 24 : 8,
      decoration: BoxDecoration(
        color: _currentPage == index
            ? _pages[_currentPage].color
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

/// Classe que representa uma página de onboarding
class OnboardingPage {
  /// Título da página
  final String title;
  
  /// Descrição da página
  final String description;
  
  /// Caminho da imagem
  final String image;
  
  /// Cor da página
  final Color color;
  
  /// Construtor
  OnboardingPage({
    required this.title,
    required this.description,
    required this.image,
    required this.color,
  });
}
