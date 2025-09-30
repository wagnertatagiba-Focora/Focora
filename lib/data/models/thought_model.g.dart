// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thought_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThoughtModelAdapter extends TypeAdapter<ThoughtModel> {
  @override
  final int typeId = 5;

  @override
  ThoughtModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ThoughtModel(
      id: fields[0] as String?,
      content: fields[1] as String,
      date: fields[2] as DateTime?,
      situation: fields[3] as String?,
      emotions: (fields[4] as List?)?.cast<String>(),
      emotionIntensity: fields[5] as int,
      distortions: (fields[6] as List?)?.cast<int>(),
      alternativeThought: fields[7] as String?,
      outcome: fields[8] as String?,
      taskId: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ThoughtModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.content)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.situation)
      ..writeByte(4)
      ..write(obj.emotions)
      ..writeByte(5)
      ..write(obj.emotionIntensity)
      ..writeByte(6)
      ..write(obj.distortions)
      ..writeByte(7)
      ..write(obj.alternativeThought)
      ..writeByte(8)
      ..write(obj.outcome)
      ..writeByte(9)
      ..write(obj.taskId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThoughtModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
