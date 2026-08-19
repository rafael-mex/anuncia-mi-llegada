import 'package:flutter/material.dart';

class MapIconLight extends StatelessWidget {
  const MapIconLight({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      right: 0,
      top: 115,
      child: Center(
        child: Image(
          image: AssetImage('assets/icons/Map_Icon_W.png'),
          width: 92,
          height: 109,
        ),
      ),
    );
  }
}