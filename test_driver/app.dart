import 'package:flutter/material.dart';
import 'package:flutter_driver/driver_extension.dart';
import 'package:focora/main.dart' as app;

/// Aplicativo instrumentado para testes E2E com flutter_driver
void main() {
  // Habilita a extensão do Flutter Driver
  enableFlutterDriverExtension();
  
  // Executa o aplicativo principal
  app.main();
}
