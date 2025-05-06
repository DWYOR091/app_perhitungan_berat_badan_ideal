class WeightRecord {
  final int? id;
  final int userId;
  final double weight;
  final String recordedAt;

  WeightRecord({
    this.id,
    required this.userId,
    required this.weight,
    required this.recordedAt,
  });

  factory WeightRecord.fromMap(Map<String, dynamic> json) => WeightRecord(
        id: json['id'],
        userId: json['user_id'],
        weight: json['weight'],
        recordedAt: json['recorded_at'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'weight': weight,
      'recorded_at': recordedAt,
    };
  }
}
