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

    return ListView.builder(
      itemCount: rounds.length,
      itemBuilder: (context, index) {
        final round = rounds[rounds.length - 1 - index]; // Reverse order

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Round ${round.roundNumber}",
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 8),
                ...List.generate(
                  teams.length,
                  (teamIndex) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(teams[teamIndex].name),
                        Text("${round.teamScores[teamIndex]} points"),
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
