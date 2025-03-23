import 'package:flutter/material.dart';
import 'package:game_counter/models/team_model.dart';
import 'package:game_counter/models/round_model.dart';

class FinalScores extends StatelessWidget {
  final List<Round> rounds;
  final List<Team> teams;

  const FinalScores({required this.rounds, required this.teams, super.key});

  @override
  Widget build(BuildContext context) {
    if (rounds.isEmpty) {
      return const Center(child: Text("No rounds played yet"));
    }

    // Calculate total scores for each team
    List<int> finalScores = List.filled(teams.length, 0);

    for (var round in rounds) {
      for (var i = 0; i < round.teamScores.length; i++) {
        finalScores[i] += round.teamScores[i];
      }
    }

    // Create pairs of [Team, Score] and sort by score descending
    List<MapEntry<Team, int>> teamScores = [];
    for (var i = 0; i < teams.length; i++) {
      teamScores.add(MapEntry(teams[i], finalScores[i]));
    }
    teamScores.sort((a, b) => b.value.compareTo(a.value));

    final colorScheme = Theme.of(context).colorScheme;

    return ListView.builder(
      itemCount: teamScores.length,
      itemBuilder: (context, index) {
        final team = teamScores[index].key;
        final score = teamScores[index].value;
        final isLeader = index == 0 && teamScores.length > 1;
        final isRunnerUp = index == 1;
        final isThirdPlace = index == 2;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: isLeader ? 2 : 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: isLeader 
              ? colorScheme.primary 
              : colorScheme.surfaceVariant.withOpacity(0.3),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Position indicator
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isLeader 
                        ? Colors.amber
                        : isRunnerUp 
                            ? Colors.grey.shade300 
                            : isThirdPlace 
                                ? Colors.brown.shade300 
                                : Colors.transparent,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isLeader 
                            ? Colors.black 
                            : isRunnerUp || isThirdPlace 
                                ? Colors.black 
                                : colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                
                // Team name
                Expanded(
                  child: Text(
                    team.name,
                    style: TextStyle(
                      fontSize: isLeader ? 18 : 16,
                      fontWeight: FontWeight.bold,
                      color: isLeader ? colorScheme.onPrimary : colorScheme.onSurface,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                
                // Score
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isLeader 
                        ? colorScheme.inversePrimary
                        : colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    score.toString(),
                    style: TextStyle(
                      fontSize: isLeader ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: isLeader ? colorScheme.primary : colorScheme.primary,
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
