// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnosis_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiagnosisModelAdapter extends TypeAdapter<DiagnosisModel> {
  @override
  final int typeId = 4;

  @override
  DiagnosisModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiagnosisModel(
      id: fields[0] as String?,
      date: fields[1] as DateTime?,
      primaryType: fields[2] as String,
      secondaryType: fields[3] as String?,
      scores: (fields[4] as Map).cast<String, int>(),
      recommendations: (fields[5] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, DiagnosisModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.primaryType)
      ..writeByte(3)
      ..write(obj.secondaryType)
      ..writeByte(4)
      ..write(obj.scores)
      ..writeByte(5)
      ..write(obj.recommendations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiagnosisModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
