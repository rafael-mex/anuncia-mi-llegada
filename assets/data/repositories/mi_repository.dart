import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/mi_model.dart';

class MiRepository {
  String _stationsPreferences({
    required bool showLineNamesInMessage,
    required bool showInstitutionsName,
  }) {
    if (showLineNamesInMessage && showInstitutionsName) {
      return 'assets/data/movilidadIntegrada.JSON';
    }
    if (showLineNamesInMessage && !showInstitutionsName) {
      return 'assets/data/movilidadIntegrada_SIG.JSON';
    }
    if (!showLineNamesInMessage && showInstitutionsName) {
      return 'assets/data/movilidadIntegrada_SNL.JSON';
    }
    return 'assets/data/movilidadIntegrada_Ambos.JSON';
  }

  Future<List<TransportsModel>> loadTransports({
    required bool showLineNamesInMessage,
    required bool showInstitutionsName,
  }) async {
    final String preferences = _stationsPreferences(
      showLineNamesInMessage: showLineNamesInMessage,
      showInstitutionsName: showInstitutionsName,
    );

    final String jsonString = await rootBundle.loadString(preferences);
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);

    return _parse(jsonMap, showLineNames: showLineNamesInMessage);
  }

  List<TransportsModel> _parse(
    Map<String, dynamic> jsonMap, {
    required bool showLineNames,
  }) {
    final List<TransportsModel> transports = [];

    for (final transportEntry in jsonMap.entries) {
      final String transportName = transportEntry.key;
      final Map<String, dynamic> linesMap = transportEntry.value;
      final List<LinesModel> lines = [];

      for (final lineEntry in linesMap.entries) {
        final String lineName = lineEntry.key;
        final List<dynamic> fullArray = lineEntry.value;

        String lineNameInMessage = '';
        List<String> stations;

        if (showLineNames) {
          lineNameInMessage = fullArray[0] as String;
          stations = fullArray.skip(1).map((e) => e as String).toList();
        } else {
          stations = fullArray.map((e) => e as String).toList();
        }

        lines.add(
          LinesModel(
            name: lineName,
            lineNameInMessage: lineNameInMessage,
            stations: stations,
          ),
        );
      }

      transports.add(TransportsModel(name: transportName, lines: lines));
    }

    return transports;
  }
}
