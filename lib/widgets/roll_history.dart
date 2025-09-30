import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/dice_bloc.dart';
import '../models/dice.dart';

class RollHistory extends StatelessWidget {
  final ScrollController scrollController;

  const RollHistory({
    super.key,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiceBloc, DiceState>(
      builder: (context, state) {
        return Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade600,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Roll History',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  if (state.rollHistory.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        context.read<DiceBloc>().add(ClearHistoryEvent());
                      },
                      child: const Text('Clear All'),
                    ),
                ],
              ),
            ),
            
            const Divider(),
            
            // History list
            Expanded(
              child: state.rollHistory.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.rollHistory.length,
                      itemBuilder: (context, index) {
                        final roll = state.rollHistory[index];
                        return _buildHistoryItem(context, roll, index == 0);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 64,
            color: Colors.grey.shade600,
          ),
          const SizedBox(height: 16),
          Text(
            'No rolls yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your roll history will appear here',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(BuildContext context, DiceRoll roll, bool isLatest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Card(
        elevation: isLatest ? 4 : 2,
        color: isLatest 
          ? Theme.of(context).primaryColor.withOpacity(0.1)
          : null,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Result circle
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _getResultColor(roll),
                ),
                child: Center(
                  child: Text(
                    '${roll.total}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Roll details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          roll.rollDescription,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        if (roll.isCriticalSuccess || roll.isCriticalFailure) ...[
                          const SizedBox(width: 4),
                          Icon(
                            roll.isCriticalSuccess ? Icons.star : Icons.warning,
                            color: roll.isCriticalSuccess ? Colors.yellow : Colors.red,
                            size: 16,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 2),
                    if (roll.individualRolls.isNotEmpty)
                      Text(
                        'Rolls: ${roll.individualRolls.join(', ')}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    Text(
                      _formatTimestamp(roll.timestamp),
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getResultColor(DiceRoll roll) {
    if (roll.isCriticalSuccess) {
      return Colors.green;
    } else if (roll.isCriticalFailure) {
      return Colors.red;
    } else {
      return Colors.grey.shade700;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}