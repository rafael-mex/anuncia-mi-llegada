import 'dart:convert';

class HistoryItems {
  final String id;
  final String stationName;
  final String transportAndLineName;
  final String category;
  final DateTime messageTime;

  HistoryItems({
    required this.id,
    required this.stationName,
    required this.transportAndLineName,
    required this.category,
    required this.messageTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'stationName': stationName,
      'transportAndLineName': transportAndLineName,
      'category': category,
      'messageTime': messageTime.toIso8601String(),
    };
  }

  factory HistoryItems.fromMap(Map<String, dynamic> map) {
    return HistoryItems(
      id: map['id'] ?? '',
      stationName: map['stationName'] ?? '',
      transportAndLineName: map['transportAndLineName'] ?? '',
      category: map['category'] ?? 'TODOS',
      messageTime: DateTime.parse(map['messageTime']),
    );
  }
  String toJson() => json.encode(toMap());
  factory HistoryItems.fromJson(String source) =>
      HistoryItems.fromMap(json.decode(source));
}
