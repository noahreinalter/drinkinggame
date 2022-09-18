import 'dart:async' show Future;
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
//TODO Make a Database and don't use json

late int numberOfPlayers;
List<String> names = [];
late List<dynamic> cards;
late List<dynamic> npcards;
List<Map<String, dynamic>> notPlayedCards = [];
List<Map<String, dynamic>> notPlayedNpcards = [];
List<String> categories = [
  "Text",
  "How many turns",
  "Shots",
  "NSFW",
  "References and Inside Jokes"
];
List<bool> activeCategories = [true, true, true];

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
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  Future<String> loadJsonData() async {
    String jsonText1 = await rootBundle.loadString('assets/cards.json');
    String jsonText2 = await rootBundle.loadString('assets/npcards.json');
    setState(() {
      cards = json.decode(jsonText1);
      npcards = json.decode(jsonText2);
    });
    return 'success';
  }

  @override
  void initState() {
    super.initState();
    loadJsonData();
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: FirstPage(),
    );
  }
}

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  "Start new Game",
                  style: TextStyle(fontSize: 40, color: textColor),
                ),
                const Text(""),
                const Text(
                  "Number of Players",
                  style: TextStyle(fontSize: 20, color: textColor),
                ),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 200),
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (input) {
                      numberOfPlayers = int.tryParse(input ?? "0") ?? 0;
                      if (numberOfPlayers >= 2) {
                        return null;
                      } else {
                        return "Not enough Players";
                      }
                    },
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: textColor),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (numberOfPlayers >= 2) {
                      List<String> oldNames;
                      oldNames = [...names];

                      names = List.filled(numberOfPlayers, "");
                      for (int i = 0; i < numberOfPlayers; i++) {
                        if (i < oldNames.length) {
                          names[i] = oldNames[i];
                        }
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) {
                          return const SecondPage();
                        }),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: secondaryButtonColor,
                    backgroundColor: primaryButtonColor,
                  ),
                  child: const Text("Add Players"),
                ),
                FutureBuilder(
                  future: getVersionNumber(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) =>
                          Text(
                    snapshot.hasData ? snapshot.data! : "Loading ...",
                    style: const TextStyle(color: textColor),
                  ),
                ),
                TextButton(
                  onPressed: () async => {
                    if (!await launchUrl(uriSource,
                        mode: LaunchMode.externalApplication))
                      {throw 'Could not launch $uriSource'}
                  },
                  child: Text(
                    "Source",
                    style: TextStyle(
                        color: hyperlinkColor,
                        decoration: TextDecoration.underline),
                  ),
                ),
                FutureBuilder(
                    future: getVersionNumber(),
                    builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) =>
                        TextButton(
                            onPressed: () {
                              showAboutDialog(
                                context: context,
                                applicationName: "Drinkinggame",
                                applicationVersion: snapshot.hasData
                                    ? snapshot.data!
                                    : "Loading ...",
                                applicationLegalese: "GPL-3.0 License",
                              );
                            },
                            child: Text(
                              "Copyright",
                              style: TextStyle(
                                  color: hyperlinkColor,
                                  decoration: TextDecoration.underline),
                            ))),
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
  const SecondPage({super.key});

  @override
  SecondPageState createState() => SecondPageState();
}

class SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    List<Widget> formWidgets = [];
    for (int i = 0; i < numberOfPlayers; i++) {
      formWidgets.add(ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
          child: CustomTextForm(customTextFormIndex: i)));
    }
    formWidgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          for (int i = 0; i < numberOfPlayers; i++) {
            if (names[i] == "") {
              return;
            }
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const ThirdPage();
            }),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: secondaryButtonColor,
          backgroundColor: primaryButtonColor,
        ),
        child: const Text("Confirm Players"),
      ),
    ));
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 200),
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
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> thirdPageWidgets = [];
    thirdPageWidgets.add(const Padding(
      padding: EdgeInsets.all(15.0),
      child: Text(
        "Choose your decks",
        style: TextStyle(fontSize: 30, color: textColor),
      ),
    ));

    for (int i = 2; i < categories.length; i++) {
      thirdPageWidgets.add(CustomCheckbox(
        customCheckboxState: i - 2,
      ));
    }

    thirdPageWidgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          for (int i = 0; i < cards.length; i++) {
            bool add = true;
            for (int j = 2; j < categories.length; j++) {
              if (cards[i][categories[j]] == true &&
                  activeCategories[j - 2] == false) {
                add = false;
                break;
              }
            }
            if (add) {
              notPlayedCards.add(Map.from(cards[i]));
            }
          }
          for (int i = 0; i < npcards.length; i++) {
            bool add = true;
            for (int j = 2; j < categories.length; j++) {
              if (npcards[i][categories[j]] == true &&
                  activeCategories[j - 2] == false) {
                add = false;
                break;
              }
            }
            if (add) {
              notPlayedNpcards.add(Map.from(npcards[i]));
            }
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const CardPages();
            }),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: secondaryButtonColor,
          backgroundColor: primaryButtonColor,
        ),
        child: const Text("Start game"),
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
  const CardPages({super.key});

  @override
  CardPagesState createState() => CardPagesState();
}

class CardPagesState extends State<CardPages> {
  late MaterialColor _backgroundColor;
  static const maxTurnsTillNonPlayerCard = 5;
  int turnsTillNonPlayerCard = Random().nextInt(maxTurnsTillNonPlayerCard) + 1;
  List multiTurnsCardTracker = [];
  late Map _currentCard;
  late Card _card;
  int _turn = -1;
  int _round = 0;

  Map? findFirstElementZero() {
    for (int i = 0; i < multiTurnsCardTracker.length; i++) {
      if (multiTurnsCardTracker[i][categories[1]] == 0) {
        Map cache = multiTurnsCardTracker[i];
        multiTurnsCardTracker.removeAt(i);
        return cache;
      }
    }
    return null;
  }

  void decrement() {
    for (int i = 0; i < multiTurnsCardTracker.length; i++) {
      multiTurnsCardTracker[i][categories[1]] =
          multiTurnsCardTracker[i][categories[1]] - 1;
    }
  }

  Map insertCustomText(Map card) {
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

  String firstText() {
    if (_card == Card.card) {
      return "${names[_turn]}s turn";
    } else {
      return "";
    }
  }

  String secondText() {
    if (_card == Card.card) {
      return "Round $_round";
    } else if (_card == Card.npcard) {
      return "";
    } else {
      return "This card ends now";
    }
  }

  @override
  Widget build(BuildContext context) {
    Map? cache = findFirstElementZero();
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
        if (notPlayedNpcards.isNotEmpty) {
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

    return WillPopScope(
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
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  secondText(),
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 300),
                  child: Text(
                    _currentCard[categories[0]],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (notPlayedCards.isEmpty) {
                    notPlayedCards = [];
                    notPlayedNpcards = [];

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const FirstPage();
                      }),
                    );
                  } else {
                    setState(() {});
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: secondaryButtonColor,
                  backgroundColor: primaryButtonColor,
                ),
                child: const Text("Next Card"),
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
  const CustomTextForm({Key? key, required this.customTextFormIndex})
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
              "Player ${customTextFormIndex + 1}",
              style: const TextStyle(color: textColor),
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
              if (input != null) {
                names[customTextFormIndex] = input;
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
  const CustomCheckbox({Key? key, required this.customCheckboxState})
      : super(key: key);

  final int customCheckboxState;

  @override
  CustomCheckboxState createState() => CustomCheckboxState();
}

class CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    bool customCheckboxValue = activeCategories[widget.customCheckboxState];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: CheckboxListTile(
          title: Text(categories[widget.customCheckboxState + 2]),
          value: customCheckboxValue,
          onChanged: (value) {
            setState(() {
              customCheckboxValue = value!;
              activeCategories[widget.customCheckboxState] = value;
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
  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch as Map<int, Color>);
}

Future<String> getVersionNumber() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

enum Card { card, npcard, endcard }
