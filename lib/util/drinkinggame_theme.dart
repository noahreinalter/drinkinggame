import 'package:drinkinggame/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DrinkinggameTheme extends ChangeNotifier{
  final _standardBackgroundColor = createMaterialColor(const Color(0xFFFFCE73));
  final _secondaryBackgroundColor = createMaterialColor(const Color(0xFF73A4FF));
  final _tertiaryBackgroundColor = createMaterialColor(const Color(0xFFFF8873));
  final _buttonColor = createMaterialColor(Colors.green);
  final _whiteColor = createMaterialColor(Colors.white);
  final _hyperlinkColor = createMaterialColor(const Color(0xFF007BFF));
  final _almostWhiteColor = createMaterialColor(const Color(0xFFF0F0F0));
  final _textColor = createMaterialColor(Colors.black);

  MaterialColor get standardBackgroundColor => _standardBackgroundColor; //defaultColor
  MaterialColor get secondaryBackgroundColor => _secondaryBackgroundColor; //colorNpCard
  MaterialColor get tertiaryBackgroundColor => _tertiaryBackgroundColor; //colorEnds
  MaterialColor get buttonColor => _buttonColor; //primaryButtonColor
  MaterialColor get whiteColor => _whiteColor; //secondaryButtonColor
  MaterialColor get hyperlinkColor => _hyperlinkColor; //hyperlinkColor
  MaterialColor get almostWhiteColor => _almostWhiteColor; //inputFieldColor
  MaterialColor get textColor => _textColor; //textColor

  static DrinkinggameTheme instance(BuildContext context) {
    return Provider.of<DrinkinggameTheme>(context, listen: false);
  }
}