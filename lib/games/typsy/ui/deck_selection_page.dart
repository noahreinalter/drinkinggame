import 'package:drinkinggame/games/typsy/deck_data.dart';
import 'package:drinkinggame/games/typsy/ui/card_page.dart';
import 'package:drinkinggame/util/drinkinggame_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeckSelectionPage extends StatelessWidget {
  const DeckSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> thirdPageWidgets = [];
    thirdPageWidgets.add(Padding(
      padding: const EdgeInsets.all(15.0),
      child: Text(
        "Choose your decks",
        style: TextStyle(
            fontSize: 30, color: DrinkinggameTheme.instance(context).textColor),
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
          Provider.of<DeckData>(context, listen: false).loadNextCard(context);

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) {
              return const CardPage();
            }),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: DrinkinggameTheme.instance(context).whiteColor,
          backgroundColor: DrinkinggameTheme.instance(context).buttonColor,
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
      backgroundColor:
          DrinkinggameTheme.instance(context).standardBackgroundColor,
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
