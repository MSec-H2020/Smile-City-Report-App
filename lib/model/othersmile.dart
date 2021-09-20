class Othersmile {
  final int id;
  final int smileId;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final double firstDegree;
  final double maxDegree;

  Othersmile({
    this.id,
    this.smileId,
    this.userId,
    this.createdAt,
    this.updatedAt,
    this.firstDegree,
    this.maxDegree,
  });

  factory Othersmile.createFrom(Map<String, dynamic> json) {
    return Othersmile(
      id: json["id"] as int ?? 0,
      smileId: json["smile_id"] as int ?? 0,
      userId: json["user_id"] as int ?? 0,
      firstDegree: json['first_degree'] as double ?? 0,
      maxDegree: json['max_degree'] as double ?? 0,
    );
  }

  bool isSmiled() {
    return this.maxDegree - this.firstDegree > 0;
  }
}