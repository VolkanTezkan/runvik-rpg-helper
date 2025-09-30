import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vibration/vibration.dart';
import '../blocs/dice_bloc.dart';
import '../models/dice.dart';
import '../widgets/dice_button.dart';
import '../widgets/roll_result_card.dart';
import '../widgets/modifier_controls.dart';
import '../widgets/advantage_controls.dart';
import '../widgets/roll_history.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              width: 40,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.casino,
                color: Theme.of(context).iconTheme.color,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Runvik',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              _showRollHistory(context);
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              switch (value) {
                case 'clear_history':
                  _showClearHistoryDialog(context);
                  break;
                case 'settings':
                  _showSettingsDialog(context);
                  break;
                case 'about':
                  _showAboutDialog(context);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear_history',
                child: ListTile(
                  leading: Icon(Icons.clear_all),
                  title: Text('Clear History'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Settings'),
                  dense: true,
                ),
              ),
              const PopupMenuItem(
                value: 'about',
                child: ListTile(
                  leading: Icon(Icons.info),
                  title: Text('About'),
                  dense: true,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
            opacity: 0.1, // Subtle background
          ),
        ),
        child: BlocConsumer<DiceBloc, DiceState>(
          listener: (context, state) {
            if (state.lastRoll != null && !state.isRolling) {
              _triggerHapticFeedback(state.lastRoll!);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                // Roll Result Display
                if (state.lastRoll != null)
                  RollResultCard(roll: state.lastRoll!)
                else
                  _buildWelcomeCard(),
                
                const SizedBox(height: 24),
                
                // Dice Grid - Moved to top
                _buildDiceGrid(context, state),
                
                const SizedBox(height: 16),
                
                // Quick Action Buttons - Moved under dice
                _buildQuickActions(context, state),
                
                const SizedBox(height: 24),
                
                // Advantage/Disadvantage Controls
                AdvantageControls(
                  hasAdvantage: state.hasAdvantage,
                  hasDisadvantage: state.hasDisadvantage,
                  onAdvantageToggle: () {
                    context.read<DiceBloc>().add(ToggleAdvantageEvent());
                  },
                  onDisadvantageToggle: () {
                    context.read<DiceBloc>().add(ToggleDisadvantageEvent());
                  },
                ),
                
                const SizedBox(height: 24),
                
                // Modifier Controls - Moved to bottom
                ModifierControls(
                  modifier: state.modifier,
                  diceCount: state.diceCount,
                  onModifierChanged: (value) {
                    context.read<DiceBloc>().add(SetModifierEvent(value));
                  },
                  onDiceCountChanged: (value) {
                    context.read<DiceBloc>().add(SetDiceCountEvent(value));
                  },
                ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 80,
              width: 80,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.casino,
                size: 64,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Runvik!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade300,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tap any die to start rolling',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiceGrid(BuildContext context, DiceState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Dice',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: DiceType.values.map((diceType) {
                return DiceButton(
                  diceType: diceType,
                  isLoading: state.isRolling,
                  onPressed: () {
                    context.read<DiceBloc>().add(RollDiceEvent(
                      diceType: diceType,
                      count: state.diceCount,
                      modifier: state.modifier,
                      hasAdvantage: state.hasAdvantage,
                      hasDisadvantage: state.hasDisadvantage,
                    ));
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, DiceState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildQuickActionButton(
                  context,
                  'Attack Roll',
                  Icons.flash_on,
                  () => _rollPreset(context, 'attack'),
                  state.isRolling,
                ),
                _buildQuickActionButton(
                  context,
                  'Damage (1d6)',
                  Icons.local_fire_department,
                  () => _rollPreset(context, 'damage', {'damageDie': DiceType.d6}),
                  state.isRolling,
                ),
                _buildQuickActionButton(
                  context,
                  'Saving Throw',
                  Icons.shield,
                  () => _rollPreset(context, 'save'),
                  state.isRolling,
                ),
                _buildQuickActionButton(
                  context,
                  'Skill Check',
                  Icons.star,
                  () => _rollPreset(context, 'skill'),
                  state.isRolling,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
    bool isLoading,
  ) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      onPressed: isLoading ? null : onPressed,
    );
  }

  void _rollPreset(BuildContext context, String presetType, [Map<String, dynamic>? params]) {
    context.read<DiceBloc>().add(RollPresetEvent(
      presetType: presetType,
      parameters: params ?? {},
    ));
  }

  void _showRollHistory(BuildContext context) {
    final diceBloc = context.read<DiceBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (modalContext) => BlocProvider.value(
        value: diceBloc,
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.3,
          builder: (context, scrollController) => Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: RollHistory(scrollController: scrollController),
          ),
        ),
      ),
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    final diceBloc = context.read<DiceBloc>();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear History'),
        content: const Text('Are you sure you want to clear all roll history?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              diceBloc.add(ClearHistoryEvent());
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('App Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            const ListTile(
              leading: Icon(Icons.vibration),
              title: Text('Haptic Feedback'),
              subtitle: Text('Vibration on dice rolls'),
              trailing: Icon(Icons.check, color: Colors.green),
              dense: true,
            ),
            const ListTile(
              leading: Icon(Icons.dark_mode),
              title: Text('Dark Theme'),
              subtitle: Text('Always enabled for RPG atmosphere'),
              trailing: Icon(Icons.check, color: Colors.green),
              dense: true,
            ),
            const ListTile(
              leading: Icon(Icons.history),
              title: Text('Roll History'),
              subtitle: Text('Keeps last 50 rolls'),
              trailing: Icon(Icons.check, color: Colors.green),
              dense: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
              width: 40,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.casino),
            ),
            const SizedBox(width: 12),
            const Text('About Runvik'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Runvik RPG Helper',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'A comprehensive tabletop RPG helper app with dice rolling, advantage/disadvantage mechanics, and roll history.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              'Features:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('• All standard RPG dice (D4-D100)'),
            Text('• Advantage/Disadvantage system'),
            Text('• Custom modifiers and dice counts'),
            Text('• Critical hit/failure detection'),
            Text('• Haptic feedback'),
            Text('• Roll history tracking'),
            Text('• Quick action presets'),
            SizedBox(height: 16),
            Text(
              'Perfect for D&D, Pathfinder, and other tabletop RPGs!',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _triggerHapticFeedback(DiceRoll roll) async {
    if ((await Vibration.hasVibrator()) == true) {
      if (roll.isCriticalSuccess) {
        // Long vibration for critical success
        Vibration.vibrate(duration: 200);
      } else if (roll.isCriticalFailure) {
        // Double vibration for critical failure
        Vibration.vibrate(duration: 100);
        await Future.delayed(const Duration(milliseconds: 100));
        Vibration.vibrate(duration: 100);
      } else {
        // Short vibration for normal rolls
        Vibration.vibrate(duration: 50);
      }
    }
  }
}