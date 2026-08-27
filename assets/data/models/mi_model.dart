class TransportsModel {

  final String name;
  final List<LinesModel> lines;

  TransportsModel({
    required this.name,
    required this.lines
  });

}

class LinesModel {

  final String name;
  final String lineNameInMessage;
  final List<String> stations;

  LinesModel({
    required this.name, 
    required this.lineNameInMessage, 
    required this.stations
  });


}