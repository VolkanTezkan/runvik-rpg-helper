import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/dice.dart';
import '../services/dice_service.dart';

// Events
abstract class DiceEvent {}

class RollDiceEvent extends DiceEvent {
  final DiceType diceType;
  final int count;
  final int modifier;
  final bool hasAdvantage;
  final bool hasDisadvantage;

  RollDiceEvent({
    required this.diceType,
    this.count = 1,
    this.modifier = 0,
    this.hasAdvantage = false,
    this.hasDisadvantage = false,
  });
}

class RollPresetEvent extends DiceEvent {
  final String presetType;
  final Map<String, dynamic> parameters;

  RollPresetEvent({
    required this.presetType,
    this.parameters = const {},
  });
}

class ClearHistoryEvent extends DiceEvent {}

class ToggleAdvantageEvent extends DiceEvent {}

class ToggleDisadvantageEvent extends DiceEvent {}

class SetModifierEvent extends DiceEvent {
  final int modifier;
  SetModifierEvent(this.modifier);
}

class SetDiceCountEvent extends DiceEvent {
  final int count;
  SetDiceCountEvent(this.count);
}

// States
class DiceState {
  final List<DiceRoll> rollHistory;
  final DiceRoll? lastRoll;
  final bool hasAdvantage;
  final bool hasDisadvantage;
  final int modifier;
  final int diceCount;
  final bool isRolling;

  const DiceState({
    this.rollHistory = const [],
    this.lastRoll,
    this.hasAdvantage = false,
    this.hasDisadvantage = false,
    this.modifier = 0,
    this.diceCount = 1,
    this.isRolling = false,
  });

  DiceState copyWith({
    List<DiceRoll>? rollHistory,
    DiceRoll? lastRoll,
    bool? hasAdvantage,
    bool? hasDisadvantage,
    int? modifier,
    int? diceCount,
    bool? isRolling,
  }) {
    return DiceState(
      rollHistory: rollHistory ?? this.rollHistory,
      lastRoll: lastRoll,
      hasAdvantage: hasAdvantage ?? this.hasAdvantage,
      hasDisadvantage: hasDisadvantage ?? this.hasDisadvantage,
      modifier: modifier ?? this.modifier,
      diceCount: diceCount ?? this.diceCount,
      isRolling: isRolling ?? this.isRolling,
    );
  }
}

// BLoC
class DiceBloc extends Bloc<DiceEvent, DiceState> {
  DiceBloc() : super(const DiceState()) {
    on<RollDiceEvent>(_onRollDice);
    on<RollPresetEvent>(_onRollPreset);
    on<ClearHistoryEvent>(_onClearHistory);
    on<ToggleAdvantageEvent>(_onToggleAdvantage);
    on<ToggleDisadvantageEvent>(_onToggleDisadvantage);
    on<SetModifierEvent>(_onSetModifier);
    on<SetDiceCountEvent>(_onSetDiceCount);
  }

  Future<void> _onRollDice(RollDiceEvent event, Emitter<DiceState> emit) async {
    emit(state.copyWith(isRolling: true));
    
    // Add a small delay for animation effect
    await Future.delayed(const Duration(milliseconds: 300));
    
    final roll = DiceService.rollDice(
      diceType: event.diceType,
      count: event.count,
      modifier: event.modifier,
      hasAdvantage: event.hasAdvantage,
      hasDisadvantage: event.hasDisadvantage,
    );
    
    final newHistory = [roll, ...state.rollHistory];
    
    // Keep only last 50 rolls to prevent memory issues
    if (newHistory.length > 50) {
      newHistory.removeRange(50, newHistory.length);
    }
    
    emit(state.copyWith(
      rollHistory: newHistory,
      lastRoll: roll,
      isRolling: false,
    ));
  }

  Future<void> _onRollPreset(RollPresetEvent event, Emitter<DiceState> emit) async {
    emit(state.copyWith(isRolling: true));
    
    await Future.delayed(const Duration(milliseconds: 300));
    
    DiceRoll roll;
    
    switch (event.presetType) {
      case 'attack':
        roll = DiceService.rollAttack(
          attackModifier: event.parameters['modifier'] ?? 0,
          hasAdvantage: event.parameters['hasAdvantage'] ?? false,
          hasDisadvantage: event.parameters['hasDisadvantage'] ?? false,
        );
        break;
      case 'damage':
        roll = DiceService.rollWeaponDamage(
          damageDie: event.parameters['damageDie'] ?? DiceType.d6,
          diceCount: event.parameters['diceCount'] ?? 1,
          damageModifier: event.parameters['damageModifier'] ?? 0,
          isCritical: event.parameters['isCritical'] ?? false,
        );
        break;
      case 'save':
        roll = DiceService.rollSavingThrow(
          saveModifier: event.parameters['saveModifier'] ?? 0,
          hasAdvantage: event.parameters['hasAdvantage'] ?? false,
          hasDisadvantage: event.parameters['hasDisadvantage'] ?? false,
        );
        break;
      case 'skill':
        roll = DiceService.rollSkillCheck(
          skillModifier: event.parameters['skillModifier'] ?? 0,
          hasAdvantage: event.parameters['hasAdvantage'] ?? false,
          hasDisadvantage: event.parameters['hasDisadvantage'] ?? false,
        );
        break;
      default:
        return;
    }
    
    final newHistory = [roll, ...state.rollHistory];
    if (newHistory.length > 50) {
      newHistory.removeRange(50, newHistory.length);
    }
    
    emit(state.copyWith(
      rollHistory: newHistory,
      lastRoll: roll,
      isRolling: false,
    ));
  }

  void _onClearHistory(ClearHistoryEvent event, Emitter<DiceState> emit) {
    emit(state.copyWith(rollHistory: [], lastRoll: null));
  }

  void _onToggleAdvantage(ToggleAdvantageEvent event, Emitter<DiceState> emit) {
    emit(state.copyWith(
      hasAdvantage: !state.hasAdvantage,
      hasDisadvantage: false, // Can't have both
    ));
  }

  void _onToggleDisadvantage(ToggleDisadvantageEvent event, Emitter<DiceState> emit) {
    emit(state.copyWith(
      hasDisadvantage: !state.hasDisadvantage,
      hasAdvantage: false, // Can't have both
    ));
  }

  void _onSetModifier(SetModifierEvent event, Emitter<DiceState> emit) {
    emit(state.copyWith(modifier: event.modifier));
  }

  void _onSetDiceCount(SetDiceCountEvent event, Emitter<DiceState> emit) {
    emit(state.copyWith(diceCount: event.count));
  }
}