import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focora/app/routes.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';
import 'package:focora/presentation/common_widgets/energy_card.dart';
import 'package:focora/presentation/providers/energy_provider.dart';

/// Widget para a seção de energia no dashboard
class DashboardEnergySection extends StatelessWidget {
  const DashboardEnergySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<EnergyProvider>(
      builder: (context, energyProvider, child) {
        final latestLog = energyProvider.latestLogForCurrentPeriod;
        final currentPeriod = getCurrentPeriod();
        
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Como está sua energia?',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Implementar histórico de energia
                    },
                    child: const Text('Ver histórico'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              
              if (latestLog != null)
                // Exibe o registro mais recente
                EnergyCard(
                  key: const Key('energy_card'),
                  energyLog: latestLog,
                )
              else
                // Exibe um card para registrar a energia
                Card(
                  key: const Key('energy_register_card'),
                  margin: EdgeInsets.zero,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navegar para a tela de registro de energia
                      Navigator.pushNamed(context, AppRoutes.energyLog);
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Text(
                            'Registre sua energia para o período da ${currentPeriod.name}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              // Navegar para a tela de registro de energia
                              Navigator.pushNamed(context, AppRoutes.energyLog);
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            ),
                            child: const Text('Registrar agora'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// Retorna o período atual do dia
FocoraDayPeriod getCurrentPeriod() {
  final hour = DateTime.now().hour;
  
  if (hour >= 5 && hour < 12) {
    return FocoraDayPeriod.morning;
  } else if (hour >= 12 && hour < 18) {
    return FocoraDayPeriod.afternoon;
  } else {
    return FocoraDayPeriod.evening;
  }
}
