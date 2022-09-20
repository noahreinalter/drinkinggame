import 'package:drinkinggame/games/typsy/player_data.dart';
import 'package:drinkinggame/games/typsy/ui/deck_selection_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/util.dart';



final defaultColor = createMaterialColor(const Color(0xFFFFCE73));
final colorNpCard = createMaterialColor(const Color(0xFF73A4FF));
final colorEnds = createMaterialColor(const Color(0xFFFF8873));
const primaryButtonColor = Colors.green;
const secondaryButtonColor = Colors.white;
final hyperlinkColor = createMaterialColor(const Color(0xFF007BFF));
final inputFieldColor = createMaterialColor(const Color(0xFFF0F0F0));
const textColor = Colors.black;

//TODO Maybe Change to AnimatedList
class PlayerNamesPage extends StatefulWidget {
  const PlayerNamesPage({super.key});

  @override
  PlayerNamesPageState createState() => PlayerNamesPageState();
}

class PlayerNamesPageState extends State<PlayerNamesPage> {

  @override
  Widget build(BuildContext context) {
    int numberOfPlayers = Provider.of<PlayerData>(context, listen: false)
        .numberOfPlayers;
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
            if (Provider.of<PlayerData>(context, listen: false).names[i] == "") {
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
