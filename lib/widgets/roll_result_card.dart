import 'package:flutter/material.dart';
import '../models/dice.dart';

class RollResultCard extends StatelessWidget {
  final DiceRoll roll;

  const RollResultCard({
    super.key,
    required this.roll,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: _getResultGradient(),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Roll description
            Text(
              roll.rollDescription,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white70,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 16),
            
            // Total result
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${roll.total}',
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (roll.isCriticalSuccess || roll.isCriticalFailure) ...[
                  const SizedBox(width: 8),
                  Icon(
                    roll.isCriticalSuccess ? Icons.star : Icons.warning,
                    color: roll.isCriticalSuccess ? Colors.yellow : Colors.red,
                    size: 32,
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Individual rolls breakdown
            if (roll.individualRolls.length > 1 || 
                roll.hasAdvantage || 
                roll.hasDisadvantage ||
                roll.modifier != 0)
              _buildRollBreakdown(),
            
            // Critical result text
            if (roll.isCriticalSuccess || roll.isCriticalFailure)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  roll.isCriticalSuccess ? 'CRITICAL SUCCESS!' : 'CRITICAL FAILURE!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: roll.isCriticalSuccess ? Colors.yellow : Colors.red,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildRollBreakdown() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          // Individual dice rolls
          if (roll.individualRolls.isNotEmpty) ...[
            Text(
              'Rolls: ${roll.individualRolls.join(', ')}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            
            // Show advantage/disadvantage calculation
            if ((roll.hasAdvantage || roll.hasDisadvantage) && 
                roll.diceType == DiceType.d20 && 
                roll.individualRolls.length == 2) ...[
              const SizedBox(height: 4),
              Text(
                roll.hasAdvantage 
                  ? 'Taking higher: ${roll.individualRolls.reduce((a, b) => a > b ? a : b)}'
                  : 'Taking lower: ${roll.individualRolls.reduce((a, b) => a < b ? a : b)}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white60,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
          
          // Modifier breakdown
          if (roll.modifier != 0) ...[
            const SizedBox(height: 4),
            Text(
              'Modifier: ${roll.modifier > 0 ? '+' : ''}${roll.modifier}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ],
        ],
      ),
    );
  }

  LinearGradient _getResultGradient() {
    if (roll.isCriticalSuccess) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF2E8B57), // Sea green
          Color(0xFF228B22), // Forest green
        ],
      );
    } else if (roll.isCriticalFailure) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFDC143C), // Crimson
          Color(0xFFB22222), // Fire brick
        ],
      );
    } else {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF4A4A4A),
          Color(0xFF3A3A3A),
        ],
      );
    }
  }
}