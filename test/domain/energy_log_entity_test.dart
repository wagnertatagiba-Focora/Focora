import 'package:flutter_test/flutter_test.dart';
import 'package:focora/domain/entities/energy_log_entity.dart';

void main() {
  group('EnergyLogEntity', () {
    test('should create an energy log with correct properties', () {
      final date = DateTime(2023, 1, 1);
      final energyLog = EnergyLogEntity(
        id: '1',
        date: date,
        period: FocoraDayPeriod.morning,
        energyLevel: 4,
        focusLevel: 3,
        motivationLevel: 5,
        notes: 'Feeling energetic',
      );

      expect(energyLog.id, '1');
      expect(energyLog.date, date);
      expect(energyLog.period, FocoraDayPeriod.morning);
      expect(energyLog.energyLevel, 4);
      expect(energyLog.focusLevel, 3);
      expect(energyLog.motivationLevel, 5);
      expect(energyLog.notes, 'Feeling energetic');
    });

    test('should update energy log properties correctly', () {
      final date = DateTime(2023, 1, 1);
      final energyLog = EnergyLogEntity(
        id: '1',
        date: date,
        period: FocoraDayPeriod.morning,
        energyLevel: 4,
        focusLevel: 3,
        motivationLevel: 5,
      );

      final updatedLog = energyLog.copyWith(
        energyLevel: 2,
        focusLevel: 2,
        motivationLevel: 3,
        notes: 'Feeling tired',
      );
      
      expect(updatedLog.id, energyLog.id);
      expect(updatedLog.date, date);
      expect(updatedLog.period, FocoraDayPeriod.morning);
      expect(updatedLog.energyLevel, 2);
      expect(updatedLog.focusLevel, 2);
      expect(updatedLog.motivationLevel, 3);
      expect(updatedLog.notes, 'Feeling tired');
    });
    
    test('should add and remove factors', () {
      final energyLog = EnergyLogEntity(
        energyLevel: 3,
        focusLevel: 3,
        motivationLevel: 3,
      );
      
      expect(energyLog.factors, isEmpty);
      
      final updatedLog = energyLog.addFactor('Good sleep');
      expect(updatedLog.factors, contains('Good sleep'));
      expect(updatedLog.factors.length, 1);
      
      final finalLog = updatedLog.addFactor('Exercise');
      expect(finalLog.factors, contains('Good sleep'));
      expect(finalLog.factors, contains('Exercise'));
      expect(finalLog.factors.length, 2);
      
      final logWithFactorRemoved = finalLog.removeFactor('Good sleep');
      expect(logWithFactorRemoved.factors, isNot(contains('Good sleep')));
      expect(logWithFactorRemoved.factors, contains('Exercise'));
      expect(logWithFactorRemoved.factors.length, 1);
    });
    
    test('should calculate average level correctly', () {
      final energyLog = EnergyLogEntity(
        energyLevel: 2,
        focusLevel: 3,
        motivationLevel: 4,
      );
      
      expect(energyLog.averageLevel, 3.0);
      
      final lowLog = EnergyLogEntity(
        energyLevel: 1,
        focusLevel: 1,
        motivationLevel: 1,
      );
      
      expect(lowLog.averageLevel, 1.0);
      
      final highLog = EnergyLogEntity(
        energyLevel: 5,
        focusLevel: 5,
        motivationLevel: 5,
      );
      
      expect(highLog.averageLevel, 5.0);
    });
    
    test('should format date and time correctly', () {
      final energyLog = EnergyLogEntity(
        date: DateTime(2023, 5, 15, 14, 30),
        energyLevel: 3,
        focusLevel: 3,
        motivationLevel: 3,
      );
      
      expect(energyLog.formattedDate, '15/05/2023');
      expect(energyLog.formattedTime, '14:30');
    });
  });
  
  group('FocoraDayPeriod', () {
    test('should return correct name for each period', () {
      expect(FocoraDayPeriod.morning.name, 'Manhã');
      expect(FocoraDayPeriod.afternoon.name, 'Tarde');
      expect(FocoraDayPeriod.evening.name, 'Noite');
      expect(FocoraDayPeriod.night.name, 'Madrugada');
    });
    
    test('should return correct hour ranges for each period', () {
      expect(FocoraDayPeriod.morning.startHour, 6);
      expect(FocoraDayPeriod.morning.endHour, 12);
      
      expect(FocoraDayPeriod.afternoon.startHour, 12);
      expect(FocoraDayPeriod.afternoon.endHour, 18);
      
      expect(FocoraDayPeriod.evening.startHour, 18);
      expect(FocoraDayPeriod.evening.endHour, 24);
      
      expect(FocoraDayPeriod.night.startHour, 0);
      expect(FocoraDayPeriod.night.endHour, 6);
    });
  });
}
