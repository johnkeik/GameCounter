import 'package:game_counter/models/round_model.dart';
import 'package:game_counter/models/team_model.dart';

class Game {
  final String name;
  final List<Team> teams;
  final List<Round> rounds;
  final int currentRound;

  Game({
    required this.name,
    required this.teams,
    this.rounds = const [],
    this.currentRound = 1,
  });

  Game copyWith({
    String? name,
    List<Team>? teams,
    List<Round>? rounds,
    int? currentRound,
  }) {
    return Game(
      name: name ?? this.name,
      teams: teams ?? this.teams,
      rounds: rounds ?? this.rounds,
      currentRound: currentRound ?? this.currentRound,
    );
  }

  Game updateTeamPoints(int teamIndex, int points) {
    List<Team> updatedTeams = [...teams];
    updatedTeams[teamIndex] = teams[teamIndex].addPoints(points);
    return copyWith(teams: updatedTeams);
  }
}
