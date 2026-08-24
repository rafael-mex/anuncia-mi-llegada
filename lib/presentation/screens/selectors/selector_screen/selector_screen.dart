import 'package:anuncia_mi_llegada/data/models/mi_model.dart';
import 'package:anuncia_mi_llegada/data/repositories/mi_repository.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/selector_screen_layout.dart';
import 'package:anuncia_mi_llegada/presentation/widgets/shared/selector_widget.dart';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';

enum _SelectorStep { transports, lines, stations }

class _StaggeredFadeIn extends StatefulWidget {
  const _StaggeredFadeIn({required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  State<_StaggeredFadeIn> createState() => _StaggeredFadeInState();
}

class _StaggeredFadeInState extends State<_StaggeredFadeIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    final start = (widget.index * 0.08).clamp(0.0, 0.6);
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Interval(start, 1.0, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(opacity: _opacity, child: widget.child);
  }
}

class TransportsScreen extends StatefulWidget {
  const TransportsScreen({super.key});

  static const name = 'selector_screen';

  @override
  State<TransportsScreen> createState() => _TransportsScreenState();
}

//Estilo de texto: nunitoFamily
final _nunitoFamily = TextStyle(
  color: Colors.white,
  height: 1,
  fontFamily: 'Nunito',
  fontSize: 17,
  letterSpacing: 0,
  fontWeight: FontWeight.w700,
);

class _TransportsScreenState extends State<TransportsScreen> {
  late final Future<List<TransportsModel>> _transportsFuture;

  _SelectorStep _step = _SelectorStep.transports;
  TransportsModel? _transport;
  LinesModel? _line;

  @override
  void initState() {
    super.initState();
    _transportsFuture = MiRepository().loadTransports(
      showLineNamesInMessage: true,
      showInstitutionsName: true,
    );
  }

  void _selectTransport(TransportsModel transport) {
    setState(() {
      _transport = transport;
      _line = null;
      _step = _SelectorStep.lines;
    });
  }

  void _selectLine(LinesModel line) {
    setState(() {
      _line = line;
      _step = _SelectorStep.stations;
    });
  }

  void _goBack() {
    setState(() {
      switch (_step) {
        case _SelectorStep.stations:
          _step = _SelectorStep.lines;
        case _SelectorStep.lines || _SelectorStep.transports:
          _step = _SelectorStep.transports;
      }
    });
  }

  String get _title {
    switch (_step) {
      case _SelectorStep.transports:
        return 'Selecciona un \n medio de transporte:';
      case _SelectorStep.lines:
        return 'Selecciona \n la línea:';
      case _SelectorStep.stations:
        return 'Selecciona \n la estación:';
    }
  }

  List<Widget> _listItems(List<TransportsModel> transports) {
    switch (_step) {

      //(Lo siento 
      //ya me cansé de traducir mentalmente 
      //en inglés mis comentarios en el código :( )

      //Paso 1: Seleccionar transportes 
      case _SelectorStep.transports:
        return [
          for (final (index, transport) in transports.indexed)
            _StaggeredFadeIn(
              index: index,
              child: ListTile(
                title: Text(transport.name, style: _nunitoFamily),
                onTap: () => _selectTransport(transport),
              ),
            ),
        ];
      //Paso 2: Seleccionar líneas
      case _SelectorStep.lines:
        final lines = _transport?.lines ?? const <LinesModel>[];
        return [
          for (final (index, line) in lines.indexed)
            _StaggeredFadeIn(
              index: index,
              child: ListTile(
                title: Text(line.name, style: _nunitoFamily),
                onTap: () => _selectLine(line),
              ),
            ),
        ];
      //Paso 3: Seleccionar estaciones 
      case _SelectorStep.stations:
        final line = _line!;
        final hasLineNameInMessage = line.lineNameInMessage.isNotEmpty;
        final specialTileCount = hasLineNameInMessage ? 1 : 0;
        return [
          if (hasLineNameInMessage)
            _StaggeredFadeIn(
              index: 0,
              child: ListTile(
                title: Text(
                  style: _nunitoFamily,
                  'Únicamente mencionar el nombre de la línea',
                ),
                onTap: () {
                  debugPrint('Ya estoy en la ${line.lineNameInMessage}');
                },
              ),
            ),
          for (final (index, station) in line.stations.indexed)
            _StaggeredFadeIn(
              index: specialTileCount + index,
              child: ListTile(
                title: Text(station, style: _nunitoFamily),
                onTap: () {
                  debugPrint('Ya estoy en la estación $station');
                },
              ),
            ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ValueListenableBuilder<bool>(
        valueListenable: isTrueDarkMode,
        builder: (context, isDark, _) => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isDark ? null : AppTheme.backgroundColorLM,
            gradient: isDark ? AppTheme.backgroundColorDM : null,
          ),
          child: SelectorScreenLayout(
            showReturnButton: _step != _SelectorStep.transports,
            onReturnTap: _goBack,
            selector: FutureBuilder<List<TransportsModel>>(
              future: _transportsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    width: 340,
                    height: 336,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'No se supone que debería de haber esto ;( : ${snapshot.error}',
                    ),
                  );
                }
                final transports = snapshot.data ?? [];
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 350),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.03),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: SelectorWidget(
                    key: ValueKey<_SelectorStep>(_step),
                    selectorsTitle: _title,
                    listItems: _listItems(transports),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
