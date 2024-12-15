// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ExpenseBoxAdapter extends TypeAdapter<ExpenseBox> {
  @override
  final int typeId = 0;

  @override
  ExpenseBox read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ExpenseBox(
      amount: fields[0] as int,
      description: fields[1] as String,
      category: fields[2] as String,
      date: fields[3] as DateTime,
      categoryImgUrl: fields[4] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ExpenseBox obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.amount)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.categoryImgUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseBoxAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
