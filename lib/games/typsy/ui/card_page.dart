import 'dart:math';

import 'package:drinkinggame/games/typsy/player_data.dart';
import 'package:drinkinggame/games/typsy/ui/player_number_page.dart';
import 'package:drinkinggame/util/drinkinggame_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../deck_data.dart';
import '../enums/card_typ.dart';

class CardPage extends StatefulWidget {
  const CardPage({super.key});

  @override
  CardPageState createState() => CardPageState();
}

class CardPageState extends State<CardPage> {
  int _turn = -1;
  int _round = 0;

  Map insertCustomText(Map card) {
    List<String> categories =
        Provider.of<DeckData>(context, listen: false).categories;
    List<String> names = Provider.of<PlayerData>(context, listen: false).names;

    String text = card[categories[0]];
    List possibleNames = [...names];
    possibleNames.removeAt(_turn);

    while (text.contains("RANDOMNUMBER")) {
      text = text.replaceFirst(
          "RANDOMNUMBER", (Random().nextInt(10) + 1).toString());
    }
    while (text.contains("RANDOMPLAYER")) {
      if (possibleNames.isNotEmpty) {
        int i = Random().nextInt(possibleNames.length);
        text = text.replaceFirst("RANDOMPLAYER", possibleNames[i]);
        possibleNames.removeAt(i);
      } else {
        text = text.replaceAll(
            "RANDOMPLAYER", "(You need more players for this card)");
      }
    }

    text = text.replaceAll("PLAYER", names[_turn]);

    card[categories[0]] = text;
    return card;
  }

  String firstText(CardTyp cardTyp, List<String> names) {
    if (cardTyp == CardTyp.card) {
      return "${names[_turn]}s turn";
    } else {
      return "";
    }
  }

  String secondText(CardTyp cardTyp) {
    if (cardTyp == CardTyp.card) {
      return "Round $_round";
    } else if (cardTyp == CardTyp.npcard) {
      return "";
    } else {
      return "This card ends now";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DeckData>(builder: (context, deckdata, child) {
      if (deckdata.cardTyp == CardTyp.card) {
        _turn = (_turn + 1) %
            Provider.of<PlayerData>(context, listen: false).names.length;
        if (_turn == 0) {
          _round++;
        }
      }
      Map currentCard = insertCustomText(deckdata.currentCard);
      deckdata.maybeAddCardToTracker(currentCard);
      return PopScope(
        canPop: false,
        child: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    firstText(deckdata.cardTyp,
                        Provider.of<PlayerData>(context, listen: false).names),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    secondText(deckdata.cardTyp),
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 300),
                    child: Text(
                      currentCard[deckdata.categories[0]],
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (deckdata.notPlayedCards.isEmpty) {
                      deckdata.startNewGame();

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const PlayerNumberPage();
                        }),
                      );
                    } else {
                      deckdata.loadNextCard(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor:
                        DrinkinggameTheme.instance(context).whiteColor,
                    backgroundColor:
                        DrinkinggameTheme.instance(context).buttonColor,
                  ),
                  child: const Text("Next Card"),
                )
              ],
            ),
          ),
          backgroundColor: deckdata.backgroundColor,
        ),
      );
    });
  }
}
