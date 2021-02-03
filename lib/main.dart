import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:flutter/services.dart';
//TODO Make a Database and don't use json

int numberOfPlayers;
List names;
List cards;
List npcards;
List notPlayedCards = List();
List notPlayedNpcards = List();
List<String> categories = [
  "Text",
  "How many turns",
  "Shots",
  "NSFW",
  "References and Inside Jokes"
];
List aktiveCategories = [true, true, true];

final defaultColor = createMaterialColor(Color(0xFFFFCE73));
final colorNpCard = createMaterialColor(Color(0xFF73A4FF));
final colorEnds = createMaterialColor(Color(0xFFFF8873));
final primaryButtonColor = Colors.green;
final secondaryButtonColor = Colors.white;
final hyperlinkColor = createMaterialColor(Color(0xFF007BFF));
final inputFieldColor = createMaterialColor(Color(0xFFF0F0F0));
final textColor = Colors.black;

const source =
    "https://github.com/noahreinalter/drinkinggame"; //TODO Change Source

void main() {
  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  Future<String> loadJsonData() async {
    var jsonText1 = await rootBundle.loadString('assets/cards.json');
    var jsonText2 = await rootBundle.loadString('assets/npcards.json');
    setState(() {
      cards = json.decode(jsonText1);
      npcards = json.decode(jsonText2);
    });
    return 'success';
  }

  @override
  void initState() {
    super.initState();
    this.loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Start new Game",
                  style: TextStyle(fontSize: 40, color: textColor),
                ),
                Text(""),
                Text(
                  "Number of Players",
                  style: TextStyle(fontSize: 20, color: textColor),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 200),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (input) {
                      numberOfPlayers = int.tryParse(input);
                      if (numberOfPlayers != null && numberOfPlayers >= 2) {
                        return null;
                      } else {
                        return "Not enough Players";
                      }
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: textColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (numberOfPlayers != null && numberOfPlayers >= 2) {
                      var oldnames;
                      if (names != null) {
                        oldnames = [...names];
                      }
                      names = new List(numberOfPlayers);
                      for (var i = 0; i < names.length; i++) {
                        if (oldnames != null) {
                          if (i < oldnames.length) {
                            names[i] = oldnames[i];
                          }
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return SecondPage();
                        }),
                      );
                    }
                  },
                  child: Text("Add Players"),
                  style: ElevatedButton.styleFrom(
                    primary: primaryButtonColor,
                    onPrimary: secondaryButtonColor,
                  ),
                ),
                Text(
                  "Version 1.0.0",
                  style: TextStyle(color: textColor),
                ),
                FlatButton(
                  onPressed: () async => {
                    if (await canLaunch(source)) {await launch(source)}
                  },
                  child: Text(
                    "Source",
                    style: TextStyle(
                        color: hyperlinkColor,
                        decoration: TextDecoration.underline),
                  ),
                ),
                FlatButton(
                    onPressed: () {showAboutDialog(context: context);},
                    child: Text(
                      "Copyright",
                      style: TextStyle(
                        color: hyperlinkColor,
                        decoration: TextDecoration.underline
                      ),
                    ))
              ],
            ),
          ),
          backgroundColor: defaultColor,
        ),
      ),
    );
  }
}

//TODO Maybe Change to AnimatedList
class SecondPage extends StatefulWidget {
  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    var formWidgets = List<Widget>();
    for (var i = 0; i < numberOfPlayers; i++) {
      formWidgets.add(ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: CustomTextForm(customTextFormIndex: i)));
    }
    formWidgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          for (var i = 0; i < numberOfPlayers; i++) {
            if (names[i] == null || names[i] == "") {
              return;
            }
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return ThirdPage();
            }),
          );
        },
        child: Text("Confirm Players"),
        style: ElevatedButton.styleFrom(
          primary: primaryButtonColor,
          onPrimary: secondaryButtonColor,
        ),
      ),
    ));
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 200),
          child: ListView(
            shrinkWrap: true,
            children: formWidgets,
          ),
        ),
      ),
      backgroundColor: defaultColor,
    );
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var thirdPageWidgets = List<Widget>();
    thirdPageWidgets.add(Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        "Choose your decks",
        style: TextStyle(fontSize: 30, color: textColor),
      ),
    ));

    for (var i = 2; i < categories.length; i++) {
      thirdPageWidgets.add(CustomCheckbox(
        customCheckboxState: i - 2,
      ));
    }

    thirdPageWidgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          for (var i = 0; i < cards.length; i++) {
            bool add = true;
            for (var j = 2; j < categories.length; j++) {
              if (cards[i][categories[j]] == true &&
                  aktiveCategories[j - 2] == false) {
                add = false;
                break;
              }
            }
            if (add) {
              notPlayedCards.add(cards[i]);
            }
          }
          for (var i = 0; i < npcards.length; i++) {
            bool add = true;
            for (var j = 2; j < categories.length; j++) {
              if (npcards[i][categories[j]] == true &&
                  aktiveCategories[j - 2] == false) {
                add = false;
                break;
              }
            }
            if (add) {
              notPlayedNpcards.add(npcards[i]);
            }
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return CardPages();
            }),
          );
        },
        child: Text("Start game"),
        style: ElevatedButton.styleFrom(
          primary: primaryButtonColor,
          onPrimary: secondaryButtonColor,
        ),
      ),
    ));

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: thirdPageWidgets,
        ),
      ),
      backgroundColor: defaultColor,
    );
  }
}

class CardPages extends StatefulWidget {
  @override
  _CardPagesState createState() => _CardPagesState();
}

class _CardPagesState extends State<CardPages> {
  MaterialColor _backgroundColor;
  static const maxTurnsTillNonPlayerCard = 5;
  int turnsTillNonPlayerCard = Random().nextInt(maxTurnsTillNonPlayerCard) + 1;
  List multiTurnsCardTracker = List();
  Map _currentCard;
  Card _card;
  int _turn = -1;
  int _round = 0;

  Map findFirstElementZero() {
    for (var i = 0; i < multiTurnsCardTracker.length; i++) {
      if (multiTurnsCardTracker[i][categories[1]] == 0) {
        Map cache = multiTurnsCardTracker[i];
        multiTurnsCardTracker.removeAt(i);
        return cache;
      }
    }
    return null;
  }

  void decrement() {
    for (var i = 0; i < multiTurnsCardTracker.length; i++) {
      multiTurnsCardTracker[i][categories[1]] =
          multiTurnsCardTracker[i][categories[1]] - 1;
    }
  }

  Map insertCustomText(Map card) {
    String text = card[categories[0]];
    List possibleNames = [...names];
    possibleNames.removeAt(_turn);

    while (text.contains("RANDOMNUMBER")) {
      text = text.replaceFirst("RANDOMNUMBER", Random().nextInt(10).toString());
    }
    while (text.contains("RANDOMPLAYER")) {
      if (possibleNames.length != 0) {
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

  String firstText() {
    if (_card == Card.card) {
      return names[_turn] + "s turn";
    } else {
      return "";
    }
  }

  String secondText() {
    if (_card == Card.card) {
      return "Round" + (_round).toString();
    } else if (_card == Card.npcard) {
      return "";
    } else {
      return "This card ends now";
    }
  }

  @override
  Widget build(BuildContext context) {
    Map cache = findFirstElementZero();
    if (cache != null) {
      _currentCard = cache;
      _card = Card.endcard;
      _backgroundColor = colorEnds;
    } else {
      if (turnsTillNonPlayerCard != 0) {
        int i = Random().nextInt(notPlayedCards.length);
        _currentCard = notPlayedCards[i];
        notPlayedCards.removeAt(i);
        _turn = (_turn + 1) % names.length;
        if (_turn == 0) {
          _round++;
        }
        _card = Card.card;
        _backgroundColor = defaultColor;
        turnsTillNonPlayerCard--;
        decrement();
      } else {
        int i = Random().nextInt(notPlayedNpcards.length);
        _currentCard = notPlayedNpcards[i];
        notPlayedNpcards.removeAt(i);
        _card = Card.npcard;
        _backgroundColor = colorNpCard;
        if (notPlayedNpcards.length != 0) {
          turnsTillNonPlayerCard =
              Random().nextInt(maxTurnsTillNonPlayerCard) + 1;
        } else {
          turnsTillNonPlayerCard--;
        }
      }
      _currentCard = insertCustomText(_currentCard);

      if (_currentCard[categories[1]] != -1) {
        multiTurnsCardTracker.add(_currentCard);
      }
    }

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  firstText(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  secondText(),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 300),
                  child: Text(
                    _currentCard[categories[0]],
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (notPlayedCards.length == 0) {
                    notPlayedCards = List();
                    notPlayedNpcards = List();

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return FirstPage();
                      }),
                    );
                  } else {
                    setState(() {});
                  }
                },
                child: Text("Next Card"),
                style: ElevatedButton.styleFrom(
                  primary: primaryButtonColor,
                  onPrimary: secondaryButtonColor,
                ),
              )
            ],
          ),
        ),
        backgroundColor: _backgroundColor,
      ),
    );
  }
}

class CustomTextForm extends StatelessWidget {
  CustomTextForm({Key key, @required this.customTextFormIndex})
      : super(key: key);

  final int customTextFormIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Player " + (customTextFormIndex + 1).toString(),
              style: TextStyle(color: textColor),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: inputFieldColor,
                contentPadding: const EdgeInsets.all(0)),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (input) {
              names[customTextFormIndex] = input;
              if (input != null) {
                return null;
              } else {
                return "";
              }
            },
            initialValue: names[customTextFormIndex],
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class CustomCheckbox extends StatefulWidget {
  const CustomCheckbox({Key key, this.customCheckboxState}) : super(key: key);

  final int customCheckboxState;

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    var _value = aktiveCategories[widget.customCheckboxState] != null
        ? aktiveCategories[widget.customCheckboxState]
        : false;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 300),
      child: CheckboxListTile(
          title: Text(categories[widget.customCheckboxState + 2]),
          value: _value,
          onChanged: (value) {
            setState(() {
              _value = value;
              aktiveCategories[widget.customCheckboxState] = value;
            });
          }),
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}

enum Card { card, npcard, endcard }
