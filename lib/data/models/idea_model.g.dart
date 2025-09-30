// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'idea_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IdeaModelAdapter extends TypeAdapter<IdeaModel> {
  @override
  final int typeId = 6;

  @override
  IdeaModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IdeaModel(
      id: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String,
      captureDate: fields[3] as DateTime?,
      category: fields[4] as int,
      status: fields[5] as int,
      tags: (fields[6] as List?)?.cast<String>(),
      notes: fields[7] as String?,
      nextSteps: fields[8] as String?,
      resources: fields[9] as String?,
      projectId: fields[10] as String?,
      taskId: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, IdeaModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.captureDate)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.tags)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.nextSteps)
      ..writeByte(9)
      ..write(obj.resources)
      ..writeByte(10)
      ..write(obj.projectId)
      ..writeByte(11)
      ..write(obj.taskId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IdeaModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
