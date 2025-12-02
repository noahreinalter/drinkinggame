import 'package:drinkinggame/games/typsy/typsy.dart';
import 'package:flutter/material.dart';

import '../util/drinkinggame_theme.dart';

class WarningPage extends StatelessWidget {
  const WarningPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = DrinkinggameTheme.instance(context);

    return Scaffold(
      backgroundColor: theme.standardBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Heads Up: Let's Get Ready to Play!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: theme.textColor,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              "The goal is fun, not overdoing it.",
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                color: theme.textColor,
              ),
            ),
            const SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: "Keep it positive! ",
                style: TextStyle(color: theme.textColor),
                children: const <TextSpan>[
                  TextSpan(
                    text: "Respect everyone's 'pass' or 'tap out'.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            RichText(
              text: TextSpan(
                text: "No driving after drinking—",
                style: TextStyle(color: theme.textColor),
                children: const <TextSpan>[
                  TextSpan(
                    text: "plan a safe ride home.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(height: 15),
            RichText(
              text: TextSpan(
                text: "Have water nearby and ",
                style: TextStyle(color: theme.textColor),
                children: const <TextSpan>[
                  TextSpan(
                    text: "look after your friends.",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return const Typsy();
                  }),
                );
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: theme.whiteColor,
                backgroundColor: theme.buttonColor,
              ),
              child: const Text("Cheers!"),
            ),
          ],
        ),
      ),
    );
  }
}
