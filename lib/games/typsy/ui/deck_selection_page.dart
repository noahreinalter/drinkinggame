import 'package:drinkinggame/games/typsy/deck_data.dart';
import 'package:drinkinggame/games/typsy/ui/card_page.dart';
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

class DeckSelectionPage extends StatelessWidget {
  const DeckSelectionPage({super.key});

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

    for (int i = 2;
        i < Provider.of<DeckData>(context, listen: false).categories.length;
        i++) {
      thirdPageWidgets.add(CustomCheckbox(
        customCheckboxState: i - 2,
      ));
    }

    thirdPageWidgets.add(Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Provider.of<DeckData>(context, listen: false).startNewGame();
          Provider.of<DeckData>(context, listen: false).loadNextCard();

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const CardPage();
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
    bool customCheckboxValue = Provider.of<DeckData>(context, listen: false)
        .activeCategories[widget.customCheckboxState];

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 300),
      child: CheckboxListTile(
          title: Text(Provider.of<DeckData>(context, listen: false)
              .categories[widget.customCheckboxState + 2]),
          value: customCheckboxValue,
          onChanged: (value) {
            setState(() {
              customCheckboxValue = value!;
              Provider.of<DeckData>(context, listen: false)
                  .setActiveCategory(widget.customCheckboxState, value);
            });
          }),
    );
  }
}
