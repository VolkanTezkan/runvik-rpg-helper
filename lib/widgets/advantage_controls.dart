import 'package:flutter/material.dart';

class AdvantageControls extends StatefulWidget {
  final bool hasAdvantage;
  final bool hasDisadvantage;
  final VoidCallback onAdvantageToggle;
  final VoidCallback onDisadvantageToggle;

  const AdvantageControls({
    super.key,
    required this.hasAdvantage,
    required this.hasDisadvantage,
    required this.onAdvantageToggle,
    required this.onDisadvantageToggle,
  });

  @override
  State<AdvantageControls> createState() => _AdvantageControlsState();
}

class _AdvantageControlsState extends State<AdvantageControls> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'D20 Roll Modifiers',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Only applies to single D20 rolls',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade400,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildAdvantageButton(
                      context: context,
                      title: 'Advantage',
                      subtitle: 'Roll 2d20, take higher',
                      icon: Icons.trending_up,
                      isActive: widget.hasAdvantage,
                      color: Colors.green,
                      onPressed: widget.onAdvantageToggle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildAdvantageButton(
                      context: context,
                      title: 'Disadvantage',
                      subtitle: 'Roll 2d20, take lower',
                      icon: Icons.trending_down,
                      isActive: widget.hasDisadvantage,
                      color: Colors.red,
                      onPressed: widget.onDisadvantageToggle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAdvantageButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isActive,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isActive ? color : Colors.grey.shade600,
              width: isActive ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isActive ? color.withOpacity(0.1) : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isActive ? color : Colors.grey.shade400,
                size: 32,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isActive ? color : Colors.grey.shade300,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 11,
                  color: isActive ? color.withOpacity(0.8) : Colors.grey.shade500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}