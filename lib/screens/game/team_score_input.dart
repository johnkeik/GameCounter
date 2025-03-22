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

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(teamName),
          Row(
            children: [
              TextButton(
                onPressed: onDecrease,
                child: const Text('-10'),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: "Score"),
                ),
              ),
              TextButton(
                onPressed: onIncrease,
                child: const Text('+10'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
