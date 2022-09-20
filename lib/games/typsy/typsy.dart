import 'package:drinkinggame/games/typsy/deck_data.dart';
import 'package:drinkinggame/games/typsy/player_data.dart';
import 'package:drinkinggame/games/typsy/ui/player_number_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Typsy extends StatefulWidget {
  const Typsy({super.key});

  @override
  TypsyState createState() => TypsyState();
}

class TypsyState extends State<Typsy> {
  final DeckData _deckData = DeckData();

  @override
  void initState() {
    super.initState();
    _deckData.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _deckData),
        ChangeNotifierProvider(create: (context) => PlayerData()),
      ],
      child: const MaterialApp(
        home: PlayerNumberPage(),
      ),
    );
  }
}
