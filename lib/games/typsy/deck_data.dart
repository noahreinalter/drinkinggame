import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:drinkinggame/games/typsy/enums/card_typ.dart';
import 'package:drinkinggame/util/drinkinggame_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//TODO Make a Database and don't use json
class DeckData extends ChangeNotifier {
  late List<dynamic> _cards;
  late List<dynamic> _npcards;
  List<Map<String, dynamic>> _notPlayedCards = [];
  List<Map<String, dynamic>> _notPlayedNpcards = [];
  final List<String> _categories = [
    "Text",
    "How many turns",
    "Shots",
    "NSFW",
    "References and Inside Jokes"
  ];
  final List<bool> _activeCategories = [true, true, true];

  late MaterialColor _backgroundColor;
  static const _maxTurnsTillNonPlayerCard = 5;
  int _turnsTillNonPlayerCard =
      Random().nextInt(_maxTurnsTillNonPlayerCard) + 1;
  List _multiTurnsCardTracker = [];
  late Map _currentCard;
  late CardTyp _cardTyp;

  List<dynamic> get cards => UnmodifiableListView(_cards);

  List<dynamic> get npcards => UnmodifiableListView(_npcards);

  List<Map<String, dynamic>> get notPlayedCards =>
      UnmodifiableListView(_notPlayedCards);

  List<Map<String, dynamic>> get notPlayedNpcards =>
      UnmodifiableListView(_notPlayedNpcards);

  List<String> get categories => UnmodifiableListView(_categories);

  List<bool> get activeCategories => UnmodifiableListView(_activeCategories);

  MaterialColor get backgroundColor => _backgroundColor;

  int get turnsTillNonPlayerCard => _turnsTillNonPlayerCard;

  Map get currentCard => _currentCard;

  CardTyp get cardTyp => _cardTyp;

  Future<void> init() async {
    String jsonText1 = await rootBundle.loadString('assets/typsy/cards.json');
    String jsonText2 = await rootBundle.loadString('assets/typsy/npcards.json');
    _cards = json.decode(jsonText1);
    _npcards = json.decode(jsonText2);
  }

  void setActiveCategory(int index, bool value) {
    _activeCategories[index] = value;
    notifyListeners();
  }

  void _initialiseNotPlayedCards() {
    _notPlayedCards = [];
    for (int i = 0; i < _cards.length; i++) {
      bool add = true;
      for (int j = 2; j < _categories.length; j++) {
        if (_cards[i][_categories[j]] == true &&
            _activeCategories[j - 2] == false) {
          add = false;
          break;
        }
      }
      if (add) {
        _notPlayedCards.add(Map.from(_cards[i]));
      }
    }
  }

  void _initialiseNotPlayedNpcards() {
    _notPlayedNpcards = [];
    for (int i = 0; i < _npcards.length; i++) {
      bool add = true;
      for (int j = 2; j < _categories.length; j++) {
        if (_npcards[i][_categories[j]] == true &&
            _activeCategories[j - 2] == false) {
          add = false;
          break;
        }
      }
      if (add) {
        _notPlayedNpcards.add(Map.from(_npcards[i]));
      }
    }
  }

  void startNewGame() {
    _initialiseNotPlayedCards();
    _initialiseNotPlayedNpcards();
    _multiTurnsCardTracker = [];
    notifyListeners();
  }

  void loadNextCard(BuildContext context) {
    Map? cache = _findFirstEndingCard();
    if (cache != null) {
      _currentCard = cache;
      _cardTyp = CardTyp.endcard;
      _backgroundColor =
          DrinkinggameTheme.instance(context).tertiaryBackgroundColor;
    } else {
      if (_turnsTillNonPlayerCard != 0) {
        int i = Random().nextInt(_notPlayedCards.length);
        _currentCard = _notPlayedCards[i];
        _notPlayedCards.removeAt(i);
        _cardTyp = CardTyp.card;
        _backgroundColor =
            DrinkinggameTheme.instance(context).standardBackgroundColor;
        _turnsTillNonPlayerCard--;
        _decrementMultiTurnsCards();
      } else {
        int i = Random().nextInt(_notPlayedNpcards.length);
        _currentCard = _notPlayedNpcards[i];
        _notPlayedNpcards.removeAt(i);
        _cardTyp = CardTyp.npcard;
        _backgroundColor =
            DrinkinggameTheme.instance(context).secondaryBackgroundColor;
        if (_notPlayedNpcards.isNotEmpty) {
          _turnsTillNonPlayerCard =
              Random().nextInt(_maxTurnsTillNonPlayerCard) + 1;
        } else {
          _turnsTillNonPlayerCard--;
        }
      }
    }
    notifyListeners();
  }

  Map? _findFirstEndingCard() {
    for (int i = 0; i < _multiTurnsCardTracker.length; i++) {
      if (_multiTurnsCardTracker[i][_categories[1]] == 0) {
        Map cache = _multiTurnsCardTracker[i];
        _multiTurnsCardTracker.removeAt(i);
        return cache;
      }
    }
    return null;
  }

  void _decrementMultiTurnsCards() {
    for (int i = 0; i < _multiTurnsCardTracker.length; i++) {
      _multiTurnsCardTracker[i][_categories[1]] =
          _multiTurnsCardTracker[i][_categories[1]] - 1;
    }
  }

  void maybeAddCardToTracker(Map card) {
    if (_currentCard[_categories[1]] > 0) {
      _multiTurnsCardTracker.add(card);
    }
  }
}
