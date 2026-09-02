import 'dart:convert';

class RecordItems {
  
  final String id;
  final String stationName;
  final String transportAndLineName;
  final String category;
  final DateTime messageTime;
  
  RecordItems({
    required this.id, 
    required this.stationName, 
    required this.transportAndLineName, 
    required this.category, 
    required this.messageTime
  });

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'stationName': stationName,
      'transportAndLineName' : transportAndLineName,
      'category': category,
      'messageTime': messageTime.toIso8601String(),
    };
  }

  factory RecordItems.fromMap(Map<String, dynamic> map) {
    return RecordItems(
      id: map['id'] ?? '', 
      stationName: map['stationName'] ?? '', 
      transportAndLineName: map['transportAndLineName'] ?? '', 
      category: map['category'] ?? 'TODOS', 
      messageTime: DateTime.parse(map['messageTime']),
    );
  }
  String toJson() => json.encode(toMap());
  factory RecordItems.fromJson(String source) => RecordItems.fromMap(json.decode(source));
}