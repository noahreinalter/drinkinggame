import 'package:drinkinggame/games/typsy/player_data.dart';
import 'package:drinkinggame/games/typsy/ui/deck_selection_page.dart';
import 'package:drinkinggame/util/drinkinggame_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//TODO Maybe Change to AnimatedList
class PlayerNamesPage extends StatefulWidget {
  const PlayerNamesPage({super.key});

  @override
  PlayerNamesPageState createState() => PlayerNamesPageState();
}

class PlayerNamesPageState extends State<PlayerNamesPage> {
  @override
  Widget build(BuildContext context) {
    int numberOfPlayers =
        Provider.of<PlayerData>(context, listen: false).numberOfPlayers;
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
            if (Provider.of<PlayerData>(context, listen: false).names[i] ==
                "") {
              return;
            }
          }
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const DeckSelectionPage();
            }),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: DrinkinggameTheme.instance(context).whiteColor,
          backgroundColor: DrinkinggameTheme.instance(context).buttonColor,
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
      backgroundColor:
          DrinkinggameTheme.instance(context).standardBackgroundColor,
    );
  }
}

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({Key? key, required this.customTextFormIndex})
      : super(key: key);

  final int customTextFormIndex;

  @override
  Widget build(BuildContext context) {
    List<String> names = Provider.of<PlayerData>(context, listen: false).names;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Player ${customTextFormIndex + 1}",
              style: TextStyle(
                  color: DrinkinggameTheme.instance(context).textColor),
            ),
          ),
          TextFormField(
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                filled: true,
                fillColor: DrinkinggameTheme.instance(context).almostWhiteColor,
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
