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

final defaultColor = createMaterialColor(Color(0xFFFFCE73));
final colorNpCard = createMaterialColor(Color(0xFF73A4FF));
final colorEnds = createMaterialColor(Color(0xFFFF8873));
final primaryButtonColor = Colors.green;
final secondaryButtonColor = Colors.white;
final hyperlinkColor = createMaterialColor(Color(0xFF007BFF));
final inputFieldColor = createMaterialColor(Color(0xFFF0F0F0));
final textColor = Colors.black;


const source =
    "https://github.com/ConnerSherman/drinkinggame"; //TODO Change Source

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
      npcards = json.decode(jsonText2);});
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
    return MaterialApp(
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
              Text("Version 1.0.0", style: TextStyle(color: textColor),),
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
              )
            ],
          ),
        ),
        backgroundColor: defaultColor,
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
          child: CustomTextForm(customTextFormState: i)));
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
    return Container();
  }
}


class CardPages extends StatefulWidget {
  @override
  _CardPagesState createState() => _CardPagesState();
}

class _CardPagesState extends State<CardPages> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class CustomTextForm extends StatelessWidget {
  CustomTextForm({Key key, @required this.customTextFormState})
      : super(key: key);

  final int customTextFormState;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Player " + (customTextFormState + 1).toString(), style: TextStyle(color: textColor),),
          ),
          TextFormField(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: inputFieldColor,
                contentPadding: const EdgeInsets.all(0)),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (input) {
              names[customTextFormState] = input;
              if (input != null) {
                return null;
              } else {
                return "";
              }
            },
            initialValue: names[customTextFormState],
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
