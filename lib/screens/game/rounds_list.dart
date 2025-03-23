import 'package:flutter/material.dart';
import 'package:game_counter/models/team_model.dart';
import 'package:game_counter/models/round_model.dart';

class RoundsList extends StatelessWidget {
  final List<Round> rounds;
  final List<Team> teams;

  const RoundsList({required this.rounds, required this.teams, super.key});

  @override
  Widget build(BuildContext context) {
    if (rounds.isEmpty) {
      return const Center(child: Text("No rounds played yet"));
    }

    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      itemCount: rounds.length,
      itemBuilder: (context, index) {
        final round = rounds[rounds.length - 1 - index]; // Reverse order
        final isLatestRound = index == 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: isLatestRound ? 1 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: isLatestRound 
              ? colorScheme.primaryContainer.withOpacity(0.7)
              : colorScheme.surfaceVariant.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${round.roundNumber}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Round ${round.roundNumber}",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isLatestRound 
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    if (isLatestRound)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'Latest',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Team scores
                ...List.generate(
                  teams.length,
                  (teamIndex) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: colorScheme.primary.withOpacity(0.1),
                              radius: 12,
                              child: Text(
                                teams[teamIndex].name[0].toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              teams[teamIndex].name,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: isLatestRound 
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: (round.teamScores[teamIndex] > 0)
                                ? Colors.green.withOpacity(0.1)
                                : (round.teamScores[teamIndex] < 0)
                                    ? Colors.red.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "${round.teamScores[teamIndex]} points",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: (round.teamScores[teamIndex] > 0)
                                  ? Colors.green
                                  : (round.teamScores[teamIndex] < 0)
                                      ? Colors.red
                                      : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
