// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      id: fields[0] as String?,
      title: fields[1] as String,
      description: fields[2] as String?,
      status: fields[3] as int,
      priority: fields[4] as int,
      createdAt: fields[5] as DateTime?,
      updatedAt: fields[6] as DateTime?,
      dueDate: fields[7] as DateTime?,
      completedAt: fields[8] as DateTime?,
      estimatedTime: fields[9] as int?,
      actualTime: fields[10] as int?,
      projectId: fields[11] as String?,
      contexts: (fields[12] as List?)?.cast<String>(),
      tags: (fields[13] as List?)?.cast<String>(),
      notes: fields[14] as String?,
      isRecurring: fields[15] as bool,
      recurrencePattern: fields[16] as String?,
      energyLevel: fields[17] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.status)
      ..writeByte(4)
      ..write(obj.priority)
      ..writeByte(5)
      ..write(obj.createdAt)
      ..writeByte(6)
      ..write(obj.updatedAt)
      ..writeByte(7)
      ..write(obj.dueDate)
      ..writeByte(8)
      ..write(obj.completedAt)
      ..writeByte(9)
      ..write(obj.estimatedTime)
      ..writeByte(10)
      ..write(obj.actualTime)
      ..writeByte(11)
      ..write(obj.projectId)
      ..writeByte(12)
      ..write(obj.contexts)
      ..writeByte(13)
      ..write(obj.tags)
      ..writeByte(14)
      ..write(obj.notes)
      ..writeByte(15)
      ..write(obj.isRecurring)
      ..writeByte(16)
      ..write(obj.recurrencePattern)
      ..writeByte(17)
      ..write(obj.energyLevel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TaskModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
