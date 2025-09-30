import 'package:flutter/material.dart';

class ModifierControls extends StatelessWidget {
  final int modifier;
  final int diceCount;
  final ValueChanged<int> onModifierChanged;
  final ValueChanged<int> onDiceCountChanged;

  const ModifierControls({
    super.key,
    required this.modifier,
    required this.diceCount,
    required this.onModifierChanged,
    required this.onDiceCountChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Roll Settings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            
            // Dice Count Control
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Number of Dice:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: diceCount > 1 
                          ? () => onDiceCountChanged(diceCount - 1)
                          : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Container(
                        width: 40,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '$diceCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: diceCount < 10 
                          ? () => onDiceCountChanged(diceCount + 1)
                          : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Modifier Control
            Row(
              children: [
                const Expanded(
                  flex: 2,
                  child: Text(
                    'Modifier:',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: modifier > -20 
                          ? () => onModifierChanged(modifier - 1)
                          : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Container(
                        width: 60,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          modifier >= 0 ? '+$modifier' : '$modifier',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: modifier < 20 
                          ? () => onModifierChanged(modifier + 1)
                          : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            // Quick modifier buttons
            const SizedBox(height: 16),
            const Text(
              'Quick Modifiers:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildQuickModifierButton(-5, onModifierChanged),
                _buildQuickModifierButton(-3, onModifierChanged),
                _buildQuickModifierButton(-1, onModifierChanged),
                _buildQuickModifierButton(0, onModifierChanged),
                _buildQuickModifierButton(1, onModifierChanged),
                _buildQuickModifierButton(3, onModifierChanged),
                _buildQuickModifierButton(5, onModifierChanged),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickModifierButton(int value, ValueChanged<int> onPressed) {
    return SizedBox(
      width: 50,
      height: 32,
      child: OutlinedButton(
        onPressed: () => onPressed(value),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          side: BorderSide(
            color: modifier == value ? Colors.orange : Colors.grey,
            width: modifier == value ? 2 : 1,
          ),
        ),
        child: Text(
          value >= 0 ? '+$value' : '$value',
          style: TextStyle(
            fontSize: 12,
            fontWeight: modifier == value ? FontWeight.bold : FontWeight.normal,
            color: modifier == value ? Colors.orange : null,
          ),
        ),
      ),
    );
  }
}