import 'package:hive/hive.dart';

part 'dice.g.dart';

@HiveType(typeId: 0)
enum DiceType {
  @HiveField(0)
  d4(4),
  @HiveField(1)
  d6(6),
  @HiveField(2)
  d8(8),
  @HiveField(3)
  d10(10),
  @HiveField(4)
  d12(12),
  @HiveField(5)
  d20(20),
  @HiveField(6)
  d100(100);

  const DiceType(this.sides);
  final int sides;

  String get displayName => 'D$sides';
}

@HiveType(typeId: 1)
class DiceRoll {
  @HiveField(0)
  final DiceType diceType;
  
  @HiveField(1)
  final int count;
  
  @HiveField(2)
  final int modifier;
  
  @HiveField(3)
  final bool hasAdvantage;
  
  @HiveField(4)
  final bool hasDisadvantage;
  
  @HiveField(5)
  final DateTime timestamp;
  
  @HiveField(6)
  final List<int> individualRolls;
  
  @HiveField(7)
  final int total;

  DiceRoll({
    required this.diceType,
    this.count = 1,
    this.modifier = 0,
    this.hasAdvantage = false,
    this.hasDisadvantage = false,
    required this.timestamp,
    required this.individualRolls,
    required this.total,
  });

  factory DiceRoll.create({
    required DiceType diceType,
    int count = 1,
    int modifier = 0,
    bool hasAdvantage = false,
    bool hasDisadvantage = false,
    required List<int> rolls,
  }) {
    int calculatedTotal;
    
    if ((hasAdvantage || hasDisadvantage) && diceType == DiceType.d20 && count == 1) {
      if (hasAdvantage) {
        calculatedTotal = rolls.reduce((a, b) => a > b ? a : b);
      } else {
        calculatedTotal = rolls.reduce((a, b) => a < b ? a : b);
      }
    } else {
      calculatedTotal = rolls.reduce((a, b) => a + b);
    }
    
    calculatedTotal += modifier;
    
    return DiceRoll(
      diceType: diceType,
      count: count,
      modifier: modifier,
      hasAdvantage: hasAdvantage,
      hasDisadvantage: hasDisadvantage,
      timestamp: DateTime.now(),
      individualRolls: rolls,
      total: calculatedTotal,
    );
  }

  bool get isCriticalSuccess => diceType == DiceType.d20 && individualRolls.contains(20);
  bool get isCriticalFailure => diceType == DiceType.d20 && individualRolls.contains(1);

  String get rollDescription {
    String baseDesc = '$count${diceType.displayName}';
    if (modifier != 0) {
      baseDesc += modifier > 0 ? '+$modifier' : '$modifier';
    }
    if (hasAdvantage) baseDesc += ' (Advantage)';
    if (hasDisadvantage) baseDesc += ' (Disadvantage)';
    return baseDesc;
  }
}