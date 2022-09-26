import 'package:drinkinggame/games/spin_the_wheel/spin_the_wheel.dart';
import 'package:drinkinggame/games/typsy/typsy.dart';
import 'package:drinkinggame/util/drinkinggame_theme.dart';
import 'package:drinkinggame/util/util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  Widget build(BuildContext context) {
    return ListenableProvider.value(
      value: DrinkinggameTheme(),
      child: const MaterialApp(
        home: _GameSelectorScreen(),
      ),
    );
  }
}

class _GameSelectorScreen extends StatelessWidget {
  const _GameSelectorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Choose game to play",
              style: TextStyle(
                  fontSize: 40,
                  color: DrinkinggameTheme.instance(context).textColor),
            ),
            const Text(""),
            ElevatedButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const Typsy())),
              style: ElevatedButton.styleFrom(
                foregroundColor: DrinkinggameTheme.instance(context).whiteColor,
                backgroundColor:
                    DrinkinggameTheme.instance(context).buttonColor,
              ),
              child: const Text(
                "Typsy",
                style: TextStyle(fontSize: 20),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const SpinTheWheel())),
              style: ElevatedButton.styleFrom(
                foregroundColor: DrinkinggameTheme.instance(context).whiteColor,
                backgroundColor:
                    DrinkinggameTheme.instance(context).buttonColor,
              ),
              child: const Text(
                "Spin the wheel",
                style: TextStyle(fontSize: 20),
              ),
            ),
            FutureBuilder(
              future: getVersionNumber(),
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
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
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                  TextButton(
                onPressed: () {
                  showAboutDialog(
                    context: context,
                    applicationName: "Drinkinggame",
                    applicationVersion:
                        snapshot.hasData ? snapshot.data! : "Loading ...",
                    applicationLegalese: "GPL-3.0 License",
                  );
                },
                child: Text(
                  "Copyright",
                  style: TextStyle(
                      color: DrinkinggameTheme.instance(context).hyperlinkColor,
                      decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor:
          DrinkinggameTheme.instance(context).standardBackgroundColor,
    );
  }
}
