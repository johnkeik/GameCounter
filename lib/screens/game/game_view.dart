import 'package:flutter/material.dart';
import 'package:game_counter/controllers/game_controller.dart';
import 'package:game_counter/controllers/navigation_controller.dart';
import 'package:game_counter/models/team_model.dart';
import 'package:game_counter/screens/game/final_scores.dart';
import 'package:game_counter/screens/game/rounds_list.dart';
import 'package:game_counter/screens/game/team_score_input.dart';
import 'package:get/get.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final GameController controller = Get.find<GameController>();
  final List<TextEditingController> scoreControllers = [];
  final NavigationController navigationController =
      Get.put(NavigationController());

  @override
  void initState() {
    super.initState();

    ever(controller.game, (_) {
      _resetScoreControllers();
    });
  }

  void _resetScoreControllers() {
    // Clear existing controllers
    for (var controller in scoreControllers) {
      controller.dispose();
    }
    scoreControllers.clear();

    // Create new controllers for each team
    if (controller.game.value != null) {
      for (int i = 0; i < controller.game.value!.teams.length; i++) {
        scoreControllers.add(TextEditingController(text: ""));
      }
    }
  }

  @override
  void dispose() {
    // Dispose all text controllers
    for (var controller in scoreControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Color generateBackgroundColor(int index) {
    List<Color> backgroundColors = [
      const Color.fromARGB(255, 174, 209, 175),
      const Color.fromARGB(255, 190, 211, 191),
      const Color.fromARGB(255, 163, 192, 164),
      const Color.fromARGB(255, 148, 197, 149),
    ];
    return backgroundColors[index % backgroundColors.length];
  }

  void submitRound() {
    if (controller.game.value == null) return;

    List<int> teamScores = [];
    List<String> invalidTeams = [];

    for (int i = 0; i < scoreControllers.length; i++) {
      var scoreController = scoreControllers[i];
      int score;
      try {
        score = int.parse(scoreController.text);
        teamScores.add(score);
      } catch (e) {
        String teamName = controller.game.value!.teams[i].name;
        invalidTeams.add(teamName);
      }
    }

    if (invalidTeams.isNotEmpty) {
      String teamList = invalidTeams.join(', ');

      Get.snackbar(
        "Invalid Scores",
        "Please enter valid numbers for: $teamList",
        snackPosition: SnackPosition.BOTTOM,
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red[100],
        animationDuration: Duration(milliseconds: 300),
        colorText: Colors.red[900],
      );
      return;
    }

    controller.createDummyRounds(teamScores);

    Get.snackbar(
      "Round Submitted!",
      "Round ${controller.game.value!.currentRound - 1} completed",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green[100],
      animationDuration: Duration(milliseconds: 300),
      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
      duration: Duration(seconds: 2),
      colorText: Colors.green[900],
    );
  }

  void onIncrease(int index) {
    int currentScore = int.tryParse(scoreControllers[index].text) ?? 0;
    scoreControllers[index].text = (currentScore + 10).toString();
  }

  void onDecrease(int index) {
    int currentScore = int.tryParse(scoreControllers[index].text) ?? 0;
    scoreControllers[index].text = (currentScore - 10).toString();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.game.value?.name ?? '',
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary)),
                  SizedBox(width: 8),
                  IconButton.filled(
                      onPressed: () {
                        controller.deleteGame();
                        navigationController.changePage(0);
                      },
                      icon: Icon(Icons.delete))
                ],
              ),
              SizedBox(height: 4),
              Expanded(
                  child: DefaultTabController(
                      length: 3,
                      child: Scaffold(
                        appBar: TabBar(
                          tabs: [
                            Tab(text: 'Teams'),
                            Tab(text: 'Rounds'),
                            Tab(text: 'Final'),
                          ],
                        ),
                        body: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TabBarView(
                            children: [
                              GetBuilder<GameController>(
                                builder: (controller) {
                                  if (controller.game.value == null) {
                                    return Center(
                                        child: Text("No rounds played yet"));
                                  }
                                  return ListView.builder(
                                    itemCount:
                                        controller.game.value?.teams.length,
                                    itemBuilder: (context, index) {
                                      return TeamScoreInput(
                                        teamName: controller
                                            .game.value!.teams[index].name,
                                        controller: scoreControllers[index],
                                        onIncrease: () => onIncrease(index),
                                        onDecrease: () => onDecrease(index),
                                      );
                                    },
                                  );
                                },
                              ),
                              GetBuilder<GameController>(
                                builder: (controller) {
                                  final game = controller.game.value;

                                  if (game == null || game.rounds.isEmpty) {
                                    return Center(
                                        child: Text("No rounds played yet"));
                                  }

                                  return RoundsList(
                                      rounds: game.rounds, teams: game.teams);
                                },
                              ),
                              GetBuilder<GameController>(
                                builder: (controller) {
                                  final game = controller.game.value;

                                  if (game == null || game.rounds.isEmpty) {
                                    return Center(
                                        child: Text("No rounds played yet"));
                                  }

                                  return FinalScores(
                                      rounds: game.rounds, teams: game.teams);
                                },
                              ),
                            ],
                          ),
                        ),
                      ))),
              SizedBox(height: 16),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 30,vertical: 20),
                    foregroundColor: colorScheme.onPrimary,
                    backgroundColor: colorScheme.primary),
                onPressed: () => submitRound(),
                child: Text('Submit Round'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
