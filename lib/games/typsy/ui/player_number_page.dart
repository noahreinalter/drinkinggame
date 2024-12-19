import 'package:drinkinggame/games/typsy/player_data.dart';
import 'package:drinkinggame/games/typsy/ui/player_names_page.dart';
import 'package:drinkinggame/util/drinkinggame_theme.dart';
import 'package:drinkinggame/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

const hostSource = "github.com";
const pathSource = "noahreinalter/drinkinggame";
final uriSource = Uri(scheme: "https", host: hostSource, path: pathSource);

class PlayerNumberPage extends StatelessWidget {
  const PlayerNumberPage({super.key});

  @override
  Widget build(BuildContext context) {
    late int numberOfPlayers;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Start new Game",
                style: TextStyle(
                    fontSize: 40,
                    color: DrinkinggameTheme.instance(context).textColor),
              ),
              const Text(""),
              Text(
                "Number of Players",
                style: TextStyle(
                    fontSize: 20,
                    color: DrinkinggameTheme.instance(context).textColor),
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
                  style: TextStyle(
                      color: DrinkinggameTheme.instance(context).textColor),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (numberOfPlayers >= 2) {
                    Provider.of<PlayerData>(context, listen: false)
                        .numberOfPlayers = numberOfPlayers;
                    List<String> names =
                        Provider.of<PlayerData>(context, listen: false).names;
                    List<String> oldNames;
                    oldNames = [...names];

                    names = List.filled(numberOfPlayers, "");
                    for (int i = 0; i < numberOfPlayers; i++) {
                      if (i < oldNames.length) {
                        names[i] = oldNames[i];
                      }
                    }
                    Provider.of<PlayerData>(context, listen: false).names =
                        names;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return const PlayerNamesPage();
                      }),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor:
                      DrinkinggameTheme.instance(context).whiteColor,
                  backgroundColor:
                      DrinkinggameTheme.instance(context).buttonColor,
                ),
                child: const Text("Add Players"),
              ),
              FutureBuilder(
                future: getVersionNumber(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) =>
                        Text(
                  snapshot.hasData ? snapshot.data! : "Loading ...",
                  style: TextStyle(
                      color: DrinkinggameTheme.instance(context).textColor),
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
                      color: DrinkinggameTheme.instance(context).hyperlinkColor,
                      decoration: TextDecoration.underline),
                ),
              ),
              FutureBuilder(
                  future: getVersionNumber(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) =>
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
                                    color: DrinkinggameTheme.instance(context)
                                        .hyperlinkColor,
                                    decoration: TextDecoration.underline),
                              ))),
            ],
          ),
        ),
        backgroundColor:
            DrinkinggameTheme.instance(context).standardBackgroundColor,
      ),
    );
  }
}
