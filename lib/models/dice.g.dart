// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DiceRollAdapter extends TypeAdapter<DiceRoll> {
  @override
  final int typeId = 1;

  @override
  DiceRoll read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DiceRoll(
      diceType: fields[0] as DiceType,
      count: fields[1] as int,
      modifier: fields[2] as int,
      hasAdvantage: fields[3] as bool,
      hasDisadvantage: fields[4] as bool,
      timestamp: fields[5] as DateTime,
      individualRolls: (fields[6] as List).cast<int>(),
      total: fields[7] as int,
    );
  }

  @override
  void write(BinaryWriter writer, DiceRoll obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.diceType)
      ..writeByte(1)
      ..write(obj.count)
      ..writeByte(2)
      ..write(obj.modifier)
      ..writeByte(3)
      ..write(obj.hasAdvantage)
      ..writeByte(4)
      ..write(obj.hasDisadvantage)
      ..writeByte(5)
      ..write(obj.timestamp)
      ..writeByte(6)
      ..write(obj.individualRolls)
      ..writeByte(7)
      ..write(obj.total);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiceRollAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DiceTypeAdapter extends TypeAdapter<DiceType> {
  @override
  final int typeId = 0;

  @override
  DiceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DiceType.d4;
      case 1:
        return DiceType.d6;
      case 2:
        return DiceType.d8;
      case 3:
        return DiceType.d10;
      case 4:
        return DiceType.d12;
      case 5:
        return DiceType.d20;
      case 6:
        return DiceType.d100;
      default:
        return DiceType.d4;
    }
  }

  @override
  void write(BinaryWriter writer, DiceType obj) {
    switch (obj) {
      case DiceType.d4:
        writer.writeByte(0);
        break;
      case DiceType.d6:
        writer.writeByte(1);
        break;
      case DiceType.d8:
        writer.writeByte(2);
        break;
      case DiceType.d10:
        writer.writeByte(3);
        break;
      case DiceType.d12:
        writer.writeByte(4);
        break;
      case DiceType.d20:
        writer.writeByte(5);
        break;
      case DiceType.d100:
        writer.writeByte(6);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
