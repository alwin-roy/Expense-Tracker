// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incomeCategory_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncomeCategoryBoxAdapter extends TypeAdapter<IncomeCategoryBox> {
  @override
  final int typeId = 3;

  @override
  IncomeCategoryBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return IncomeCategoryBox(
      category: fields[0] as String,
      imageUrl: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, IncomeCategoryBox obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.category)
      ..writeByte(1)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncomeCategoryBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
