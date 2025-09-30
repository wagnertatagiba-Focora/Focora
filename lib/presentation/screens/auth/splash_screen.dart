import 'package:flutter/material.dart';
import 'package:focora/app/routes.dart';
import 'package:focora/app/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Tela de splash do aplicativo Focora
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Verificar se o usuário já passou pelo onboarding
    _checkFirstRun();
  }
  
  /// Verifica se é a primeira execução do aplicativo
  Future<void> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    final hasCompletedOnboarding = prefs.getBool('hasCompletedOnboarding') ?? false;
    final hasCompletedDiagnosis = prefs.getBool('hasCompletedDiagnosis') ?? false;
    
    // Aguardar um tempo para mostrar a tela de splash
    await Future.delayed(const Duration(seconds: 2));
    
    if (!mounted) return;
    
    // Navegar para a tela apropriada
    if (!hasCompletedOnboarding) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.onboarding);
    } else if (!hasCompletedDiagnosis) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.diagnosis);
    } else {
      Navigator.of(context).pushReplacementNamed(AppRoutes.dashboard);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: FocoraTheme.primaryGradient,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo (temporário até termos um logo oficial)
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Center(
                  child: Text(
                    'F',
                    style: TextStyle(
                      color: FocoraTheme.primaryColor,
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Nome do aplicativo
              const Text(
                'Focora',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Slogan
              const Text(
                'Transforme sua relação com a produtividade',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 48),
              // Indicador de carregamento
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
