import 'package:drinkinggame/games/typsy/typsy.dart';
import 'package:drinkinggame/util/util.dart';
import 'package:flutter/material.dart';

final defaultColor = createMaterialColor(const Color(0xFFFFCE73));
final colorNpCard = createMaterialColor(const Color(0xFF73A4FF));
final colorEnds = createMaterialColor(const Color(0xFFFF8873));
const primaryButtonColor = Colors.green;
const secondaryButtonColor = Colors.white;
final hyperlinkColor = createMaterialColor(const Color(0xFF007BFF));
final inputFieldColor = createMaterialColor(const Color(0xFFF0F0F0));
const textColor = Colors.black;

const hostSource = "github.com";
const pathSource = "noahreinalter/drinkinggame";
final uriSource = Uri(scheme: "https", host: hostSource, path: pathSource);

void main() {
  runApp(const Typsy());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Typsy(),
    );
  }
}
