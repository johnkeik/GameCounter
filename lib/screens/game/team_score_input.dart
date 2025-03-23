import 'package:flutter/material.dart';

class TeamScoreInput extends StatelessWidget {
  final String teamName;
  final TextEditingController controller;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const TeamScoreInput({
    required this.teamName,
    required this.controller,
    required this.onIncrease,
    required this.onDecrease,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: colorScheme.surfaceVariant.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            // Team Identity
            CircleAvatar(
              backgroundColor: colorScheme.primary.withOpacity(0.15),
              radius: 16,
              child: Text(
                teamName.isNotEmpty ? teamName[0].toUpperCase() : '?',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 10),
            
            // Team Name & Score Controls
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teamName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 6),
                  
                  // Score input and controls row
                  Row(
                    children: [
                      // Quick decrement buttons
                      _buildQuickButton(
                        context, 
                        '-10', 
                        () {
                          int currentScore = int.tryParse(controller.text) ?? 0;
                          controller.text = (currentScore - 10).toString();
                        },
                        isNegative: true,
                      ),
                      
                      _buildQuickButton(
                        context, 
                        '-5', 
                        () {
                          int currentScore = int.tryParse(controller.text) ?? 0;
                          controller.text = (currentScore - 5).toString();
                        },
                        isNegative: true,
                      ),
                      
                      // Score input box
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 44,
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: controller,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: "0",
                                    hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.4)),
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      // Quick increment buttons
                      _buildQuickButton(
                        context, 
                        '+5', 
                        () {
                          int currentScore = int.tryParse(controller.text) ?? 0;
                          controller.text = (currentScore + 5).toString();
                        },
                      ),
                      
                      _buildQuickButton(
                        context, 
                        '+10', 
                        () {
                          int currentScore = int.tryParse(controller.text) ?? 0;
                          controller.text = (currentScore + 10).toString();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Accessibility-improved quick button
  Widget _buildQuickButton(
    BuildContext context, 
    String text, 
    VoidCallback onPressed, 
    {bool isNegative = false}
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(
              minWidth: 44, // Minimum touch target width
              minHeight: 44, // Minimum touch target height
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isNegative 
                ? colorScheme.errorContainer.withOpacity(0.3) 
                : colorScheme.primaryContainer.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 14, // Increased from 10 to 14 for better readability
                  fontWeight: FontWeight.bold,
                  color: isNegative ? colorScheme.error : colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
