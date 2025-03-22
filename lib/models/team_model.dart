class Team {
  final String name;
  final int points;

  Team({
    required this.name,
    this.points = 0,
  });

  Team copyWith({
    String? name,
    int? points,
  }) {
    return Team(
      name: name ?? this.name,
      points: points ?? this.points,
    );
  }

  Team addPoints(int newPoints) {
    return copyWith(points: points + newPoints);
  }
}