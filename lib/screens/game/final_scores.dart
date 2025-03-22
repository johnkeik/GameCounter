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

    return ListView.builder(
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        final score = finalScores[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            title: Text(team.name, style: const TextStyle(fontWeight: FontWeight.bold)),
            trailing: Text(score.toString(), style: const TextStyle(fontSize: 18)),
          ),
        );
      },
    );
  }
}
