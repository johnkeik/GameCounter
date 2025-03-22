import 'package:game_counter/models/game_model.dart';
import 'package:game_counter/models/round_model.dart';
import 'package:get/get.dart';

import '../models/team_model.dart';

class GameController extends GetxController {
  var game = Rx<Game?>(null);

  void createDummyGame(String name, List<Team> teams) {
    game.value = Game(
      name: name,
      teams: teams,
      rounds: [],
      currentRound: 1,
    );
    update();
  }

  void createDummyRounds(List<int> teamScores) {
    if (game.value == null) return;

    if (teamScores.length != game.value!.teams.length) {
      print('Invalid number of scores');
      return;
    }

    var newRound = Round(
      roundNumber: game.value!.currentRound,
      teamScores: teamScores,
    );

    // Update game with new round and points
    var updatedGame = game.value!.copyWith(
      rounds: [...game.value!.rounds, newRound],
      currentRound: game.value!.currentRound + 1,
    );

    // Update each team's points
    for (var i = 0; i < teamScores.length; i++) {
      updatedGame = updatedGame.updateTeamPoints(i, teamScores[i]);
    }

    game.value = updatedGame;
    update();
  }

  void saveGame() {
    if (game.value == null) {
      print('No game to save!');
      return;
    }
    // Here you would typically save to local storage or backend
    // For now just confirming the action
    print('Game "${game.value!.name}" saved successfully');
  }

  void deleteGame() {
    if (game.value == null) {
      print('No game to delete!');
      return;
    }
    // Store name for confirmation message
    final gameName = game.value!.name;
    
    // Clear the game
    game.value = null;
    
    print('Game "$gameName" deleted successfully');
  }
}
