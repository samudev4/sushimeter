// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sushi_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SushiEntryAdapter extends TypeAdapter<SushiEntry> {
  @override
  final int typeId = 0;

  @override
  SushiEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SushiEntry(
      fields[0] as int,
      fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, SushiEntry obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pieces)
      ..writeByte(1)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SushiEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
