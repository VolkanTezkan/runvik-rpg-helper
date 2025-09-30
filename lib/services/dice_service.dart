import 'dart:math';
import '../models/dice.dart';

class DiceService {
  static final Random _random = Random();

  static DiceRoll rollDice({
    required DiceType diceType,
    int count = 1,
    int modifier = 0,
    bool hasAdvantage = false,
    bool hasDisadvantage = false,
  }) {
    List<int> rolls = [];
    
    // For advantage/disadvantage, we need to roll 2 dice when rolling a single d20
    if ((hasAdvantage || hasDisadvantage) && diceType == DiceType.d20 && count == 1) {
      rolls = [
        _rollSingleDie(diceType.sides),
        _rollSingleDie(diceType.sides),
      ];
    } else {
      // Normal rolling
      for (int i = 0; i < count; i++) {
        rolls.add(_rollSingleDie(diceType.sides));
      }
    }
    
    return DiceRoll.create(
      diceType: diceType,
      count: count,
      modifier: modifier,
      hasAdvantage: hasAdvantage,
      hasDisadvantage: hasDisadvantage,
      rolls: rolls,
    );
  }

  static int _rollSingleDie(int sides) {
    return _random.nextInt(sides) + 1;
  }

  static List<DiceRoll> rollMultipleDice(List<Map<String, dynamic>> diceConfigs) {
    return diceConfigs.map((config) {
      return rollDice(
        diceType: config['diceType'] as DiceType,
        count: config['count'] as int? ?? 1,
        modifier: config['modifier'] as int? ?? 0,
        hasAdvantage: config['hasAdvantage'] as bool? ?? false,
        hasDisadvantage: config['hasDisadvantage'] as bool? ?? false,
      );
    }).toList();
  }

  // Common D&D weapon presets
  static DiceRoll rollWeaponDamage({
    required DiceType damageDie,
    int diceCount = 1,
    int damageModifier = 0,
    bool isCritical = false,
  }) {
    int totalCount = isCritical ? diceCount * 2 : diceCount;
    
    return rollDice(
      diceType: damageDie,
      count: totalCount,
      modifier: damageModifier,
    );
  }

  static DiceRoll rollAttack({
    int attackModifier = 0,
    bool hasAdvantage = false,
    bool hasDisadvantage = false,
  }) {
    return rollDice(
      diceType: DiceType.d20,
      count: 1,
      modifier: attackModifier,
      hasAdvantage: hasAdvantage,
      hasDisadvantage: hasDisadvantage,
    );
  }

  static DiceRoll rollSavingThrow({
    int saveModifier = 0,
    bool hasAdvantage = false,
    bool hasDisadvantage = false,
  }) {
    return rollDice(
      diceType: DiceType.d20,
      count: 1,
      modifier: saveModifier,
      hasAdvantage: hasAdvantage,
      hasDisadvantage: hasDisadvantage,
    );
  }

  static DiceRoll rollSkillCheck({
    int skillModifier = 0,
    bool hasAdvantage = false,
    bool hasDisadvantage = false,
  }) {
    return rollDice(
      diceType: DiceType.d20,
      count: 1,
      modifier: skillModifier,
      hasAdvantage: hasAdvantage,
      hasDisadvantage: hasDisadvantage,
    );
  }

  // Generate character stats (4d6, drop lowest)
  static int rollCharacterStat() {
    List<int> rolls = List.generate(4, (_) => _rollSingleDie(6));
    rolls.sort((a, b) => b.compareTo(a)); // Sort descending
    return rolls.take(3).reduce((a, b) => a + b); // Take top 3
  }

  static List<int> rollAllCharacterStats() {
    return List.generate(6, (_) => rollCharacterStat());
  }
}