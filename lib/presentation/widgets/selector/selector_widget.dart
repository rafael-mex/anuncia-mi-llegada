import 'dart:math' as math;
import 'dart:ui';
import 'package:anuncia_mi_llegada/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inner_shadow/flutter_inner_shadow.dart';

class SelectorWidget extends StatelessWidget {
  final double glassContainerWidth;
  final String selectorsTitle;
  final List<Widget> listItems;
  final double orangePadding;
  final double listContentPadding;
  final double dividerWidthModifier;
  final double titleTopOffset;

  const SelectorWidget({
    super.key,
    required this.selectorsTitle,
    required this.listItems,
    this.glassContainerWidth = 320,
    this.orangePadding = 20,
    this.listContentPadding = 5,
    this.dividerWidthModifier = 9,
    this.titleTopOffset = 25,
  });

  //Tamaño de diseño del selector (contenedor naranja). Si el espacio
  //disponible es menor, el selector se adapta a él en lugar de desbordarse.
  static const double _designHeight = 386;
  //Distancia entre el borde superior del contenedor naranja y el contenedor
  //de vidrio
  static const double _glassTopOffset = 66;
  //Margen inferior del contenedor de vidrio dentro del contenedor naranja
  static const double _glassBottomOffset = 15;

  static const TextStyle _nunitoFamily = TextStyle(
    color: Colors.white,
    fontFamily: 'Nunito',
    fontSize: 17,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
  );
  static const TextStyle _titlesNunitoFamily = TextStyle(
    color: Colors.white,
    fontFamily: 'Nunito',
    height: 1,
    fontSize: 17,
    letterSpacing: 0,
    fontWeight: FontWeight.w700,
  );


  double get _orangeContainerWidth => glassContainerWidth + (orangePadding * 2);

  Widget _buildShadowContainer({
    required double width,
    required double height,
    required double borderRadius,
    required Decoration decoration,
  }) {
    return InnerShadow(
      shadows: const [
        Shadow(
          color: Color.fromRGBO(255, 255, 255, 40),
          blurRadius: 10,
          offset: Offset(1, 1),
        ),
      ],
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            width: width,
            height: height,
            decoration: decoration,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder<bool>(
        valueListenable: isTrueDarkMode,
        builder: (context, isDark, _) => LayoutBuilder(
          builder: (context, constraints) {
            //El selector nunca excede el espacio que le da el layout: si el
            //disponible es menor que su tamaño de diseño (pantallas cortas),
            //el contenedor de vidrio se reduce en lugar de desbordar la
            //pantalla.
            final double containerWidth = constraints.maxWidth.isFinite
                ? math.min(_orangeContainerWidth, constraints.maxWidth)
                : _orangeContainerWidth;
            final double containerHeight = constraints.maxHeight.isFinite
                ? math.min(_designHeight, constraints.maxHeight)
                : _designHeight;
            final double glassWidth = math.min(
              glassContainerWidth,
              containerWidth - (orangePadding * 2),
            );
            final double glassHeight = math.max(
              containerHeight - _glassTopOffset - _glassBottomOffset,
              0,
            );

            return SizedBox(
              // Contenedor naranja (Orange Container)
              width: containerWidth,
              height: containerHeight,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: isDark
                          ? 0.23
                          : 0.87,
                      child: _buildShadowContainer(
                        width: containerWidth,
                        height: containerHeight,
                        borderRadius: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          gradient: isDark
                              ? AppTheme.colorsOfOrangeContainerDM
                              : AppTheme.colorsOfOrangeContianerLM,
                        ),
                      ),
                    ),
                  ),
                  //Contenedor de vidrio (Glass Container)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: _glassTopOffset,
                    child: Center(
                      child: Opacity(
                        opacity: isDark
                            ? 0.30
                            : 0.38,
                        child: _buildShadowContainer(
                          width: glassWidth,
                          height: glassHeight,
                          borderRadius: 24,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: isDark
                                ? AppTheme.colorOfGlassContainerDM
                                : null,
                            gradient: isDark
                                ? null
                                : AppTheme.colorOfGlassContainerLM,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Lista de elementos (Element's List)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: _glassTopOffset,
                    child: Center(
                      child: SizedBox(
                        width: glassWidth,
                        height: glassHeight,
                        child: Material(
                          type: MaterialType.transparency,
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                            ),
                            child: DefaultTextStyle(
                              style: _nunitoFamily,
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(
                                  horizontal: listContentPadding,
                                  vertical: listContentPadding,
                                ),
                                physics: const BouncingScrollPhysics(
                                  parent: AlwaysScrollableScrollPhysics(),
                                ),
                                itemCount: listItems.length,
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.white,
                                  thickness: 1.5,
                                  height: 0.7,
                                  indent: dividerWidthModifier / 2,
                                  endIndent: dividerWidthModifier / 2,
                                ),
                                itemBuilder: (context, index) =>
                                    listItems[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  //Título del selector (Selector's Title)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: titleTopOffset,
                    child: Center(
                      child: Text(
                        selectorsTitle,
                        textAlign: TextAlign.center,
                        style: _titlesNunitoFamily
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
