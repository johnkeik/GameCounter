class Round {
  final int roundNumber;  // The round number (e.g., 1, 2, 3)
  final List<int> teamScores;  // Scores for each team in this round

  Round({
    required this.roundNumber,
    required this.teamScores,
  });

  // Method to get the score for a specific team in this round
  int getTeamScore(int teamIndex) {
    if (teamIndex >= 0 && teamIndex < teamScores.length) {
      return teamScores[teamIndex];
    }
    return 0;
  }
}