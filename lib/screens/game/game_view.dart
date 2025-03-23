import 'package:flutter/material.dart';
import 'package:game_counter/controllers/game_controller.dart';
import 'package:game_counter/controllers/navigation_controller.dart';
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
  final NavigationController navigationController = Get.put(NavigationController());

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
      
      // Show error in a simple snackbar
      Get.snackbar(
        "Invalid Scores",
        "Please enter valid numbers for: $teamList",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.only(bottom: 70, left: 16, right: 16),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
        animationDuration: Duration(milliseconds: 300),
        borderRadius: 16,
        icon: const Icon(Icons.error_outline, color: Colors.red),
      );
      return;
    }

    // Add the round
    controller.createDummyRounds(teamScores);
    final roundNumber = controller.game.value!.currentRound - 1;
    
    // Clear score controllers for next round
    for (var controller in scoreControllers) {
      controller.clear();
    }
    
    // Show success notification
    _showSuccessSnackbar(roundNumber, teamScores);
  }
  
  // Non-interruptive success notification
  void _showSuccessSnackbar(int roundNumber, List<int> scores) {
    final colorScheme = Theme.of(context).colorScheme;
    
    // Compact summary text
    String summaryText = "";
    for (int i = 0; i < scores.length && i < 3; i++) {
      if (i > 0) summaryText += " • ";
      summaryText += "${controller.game.value!.teams[i].name}: ${scores[i]}";
    }
    
    if (scores.length > 3) {
      summaryText += " • ...";
    }
    
    Get.snackbar(
      "Round $roundNumber Completed!",
      summaryText,
      snackPosition: SnackPosition.TOP,
      backgroundColor: colorScheme.primaryContainer,
      colorText: colorScheme.onPrimaryContainer,
      margin: const EdgeInsets.only(top: 70, left: 16, right: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 16,
      duration: const Duration(seconds: 3),
      animationDuration: Duration(milliseconds: 300),
      icon: Container(
        decoration: BoxDecoration(
          color: colorScheme.primary.withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(8),
        child: Icon(
          Icons.check_circle_outline,
          color: colorScheme.primary,
        ),
      ),
      onTap: (snack) {
        // If user taps, switch to rounds tab
        Get.closeAllSnackbars();
        DefaultTabController.of(context).animateTo(1);
      },
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutCubic,
      dismissDirection: DismissDirection.horizontal,
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
    final topPadding = MediaQuery.of(context).padding.top;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Game header with name and actions
            Container(
              padding: EdgeInsets.fromLTRB(20, topPadding > 0 ? 8 : 16, 20, 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.sports_esports,
                              size: 24,
                              color: colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Active Game',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.game.value?.name ?? 'Game',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          // Future: add edit game functionality
                        },
                        icon: Icon(Icons.edit_outlined),
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Get.defaultDialog(
                              title: 'End Game',
                              content: Text('Are you sure you want to end this game?'),
                              textConfirm: 'End Game',
                              textCancel: 'Cancel',
                              confirmTextColor: Colors.white,
                              cancelTextColor: colorScheme.onSurface,
                              buttonColor: Colors.red,
                              onConfirm: () {
                                controller.deleteGame();
                                navigationController.changePage(0);
                                Get.back();
                              },
                            );
                          },
                          icon: Icon(Icons.close),
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Game content
            Expanded(
              child: DefaultTabController(
                length: 3,
                child: Column(
                  children: [
                    // Modern tab bar with wider highlight
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: TabBar(
                        labelColor: colorScheme.onPrimary,
                        unselectedLabelColor: colorScheme.onSurfaceVariant,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 4),
                        indicator: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(4),
                        tabs: [
                          Tab(
                            height: 44,
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.people_outline, size: 18),
                                  const SizedBox(width: 6),
                                  const Text('Teams'),
                                ],
                              ),
                            ),
                          ),
                          Tab(
                            height: 44,
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.view_list_outlined, size: 18),
                                  const SizedBox(width: 6),
                                  const Text('Rounds'),
                                ],
                              ),
                            ),
                          ),
                          Tab(
                            height: 44,
                            child: Container(
                              width: double.infinity,
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.emoji_events_outlined, size: 18),
                                  const SizedBox(width: 6),
                                  const Text('Final'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Tab content
                    Expanded(
                      child: TabBarView(
                        children: [
                          // Teams Tab
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GetBuilder<GameController>(
                              builder: (controller) {
                                if (controller.game.value == null) {
                                  return _buildEmptyState(
                                    'No Game in Progress',
                                    'Start a new game to add scores',
                                    Icons.sports_esports_outlined,
                                    context,
                                  );
                                }
                                
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Round ${controller.game.value!.currentRound}',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: colorScheme.onSurface,
                                          ),
                                        ),
                                        Text(
                                          'Enter Scores',
                                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: controller.game.value?.teams.length ?? 0,
                                        itemBuilder: (context, index) {
                                          return TeamScoreInput(
                                            teamName: controller.game.value!.teams[index].name,
                                            controller: scoreControllers[index],
                                            onIncrease: () => onIncrease(index),
                                            onDecrease: () => onDecrease(index),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          
                          // Rounds Tab
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GetBuilder<GameController>(
                              builder: (controller) {
                                final game = controller.game.value;

                                if (game == null || game.rounds.isEmpty) {
                                  return _buildEmptyState(
                                    'No Rounds Yet',
                                    'Complete a round to see it here',
                                    Icons.view_list_outlined,
                                    context,
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${game.rounds.length} Rounds',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: colorScheme.primary,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Text(
                                            'Current: Round ${game.currentRound}',
                                            style: TextStyle(
                                              color: colorScheme.onPrimary,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: RoundsList(rounds: game.rounds, teams: game.teams),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          
                          // Final Tab
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: GetBuilder<GameController>(
                              builder: (controller) {
                                final game = controller.game.value;

                                if (game == null || game.rounds.isEmpty) {
                                  return _buildEmptyState(
                                    'No Scores Yet',
                                    'Complete rounds to see final scores',
                                    Icons.emoji_events_outlined,
                                    context,
                                  );
                                }

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.leaderboard_outlined,
                                          color: colorScheme.primary,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Current Standings',
                                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Expanded(
                                      child: FinalScores(rounds: game.rounds, teams: game.teams),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Submit Round button
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: submitRound,
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle_outline),
                    const SizedBox(width: 8),
                    Text(
                      'Submit Round',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
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
  }
  
  // Helper method for empty states
  Widget _buildEmptyState(
    String title,
    String message,
    IconData icon,
    BuildContext context,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 48,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
