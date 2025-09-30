import 'package:flutter/material.dart';
import 'package:focora/app/routes.dart';
import 'package:focora/app/theme.dart';
import 'package:provider/provider.dart';

/// Classe principal do aplicativo Focora
class FocoraApp extends StatelessWidget {
  const FocoraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Adicione os providers aqui conforme necessário
      ],
      child: MaterialApp(
        title: 'Focora',
        theme: FocoraTheme.lightTheme(),
        darkTheme: FocoraTheme.darkTheme(),
        themeMode: ThemeMode.light, // Inicialmente usaremos apenas o tema claro
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        routes: AppRoutes.getRoutes(),
      ),
    );
  }
}
