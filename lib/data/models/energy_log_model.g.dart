// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'energy_log_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EnergyLogModelAdapter extends TypeAdapter<EnergyLogModel> {
  @override
  final int typeId = 3;

  @override
  EnergyLogModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return EnergyLogModel(
      id: fields[0] as String?,
      date: fields[1] as DateTime,
      period: fields[2] as int,
      energyLevel: fields[3] as int,
      focusLevel: fields[4] as int,
      motivationLevel: fields[5] as int,
      factors: (fields[6] as List?)?.cast<String>(),
      notes: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, EnergyLogModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.period)
      ..writeByte(3)
      ..write(obj.energyLevel)
      ..writeByte(4)
      ..write(obj.focusLevel)
      ..writeByte(5)
      ..write(obj.motivationLevel)
      ..writeByte(6)
      ..write(obj.factors)
      ..writeByte(7)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EnergyLogModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
