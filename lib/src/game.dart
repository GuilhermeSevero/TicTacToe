import 'dart:math';

import 'package:flutter/material.dart';

import 'package:tictactoe/src/game_button.dart';

class Game {
  int activePlayer;
  bool useAutoPlay;

  List<GameButton> buttonsList;

  final Function onTied;
  final Function onWin;

  Game({this.onWin, this.onTied, this.useAutoPlay = true}) {
    activePlayer = 1;

    buttonsList = <GameButton>[
      new GameButton(id: 1),
      new GameButton(id: 2),
      new GameButton(id: 3),
      new GameButton(id: 4),
      new GameButton(id: 5),
      new GameButton(id: 6),
      new GameButton(id: 7),
      new GameButton(id: 8),
      new GameButton(id: 9),
    ];
  }

  void play(GameButton gameButton) {
    if (activePlayer == 1) {
      gameButton.text = "X";
      gameButton.bg = Colors.indigo;
      gameButton.value = 1;
      activePlayer = 2;
    } else {
      gameButton.text = "0";
      gameButton.bg = Colors.red;
      gameButton.value = -1;
      activePlayer = 1;
    }
    gameButton.enabled = false;

    int winner = checkWinner();

    if (winner == -1) {
      if (buttonsList.every((p) => p.text != "")) {
        onTied();
      } else if ((activePlayer == 2) && useAutoPlay) {
        _autoPlay();
      }
    }
  }

  int checkWinner() {
    Set<int> winners = {};

    winners.add(_checkLayer(0, 1, 2));
    winners.add(_checkLayer(3, 4, 5));
    winners.add(_checkLayer(6, 7, 8));
    winners.add(_checkLayer(0, 3, 6));
    winners.add(_checkLayer(1, 4, 7));
    winners.add(_checkLayer(2, 5, 8));
    winners.add(_checkLayer(0, 4, 8));
    winners.add(_checkLayer(2, 4, 6));

    int winner = -1;
    if (winners.contains(1)) {
      winner = 1;
    } else if (winners.contains(2)) {
      winner = 2;
    }

    if (winner != -1) {
      onWin(winner);
    }
    return winner;
  }

  void _autoPlay() {
    int index = _attack();

    if (index == -1) {
      index = _defend();
    }

    if ((index == -1) && (buttonsList[4].value == 0)) {
      index = 4;
    }

    if (index == -1) {
      List emptyCells = new List();
      for (GameButton button in buttonsList) {
        if (button.value == 0) {
          emptyCells.add(buttonsList.indexOf(button));
        }
      }
      Random r = new Random();
      int randIndex = r.nextInt(emptyCells.length - 1);
      index = emptyCells[randIndex];
    }

    play(buttonsList[index]);
  }

  bool _check(int x, y, int valueCheck) {
    return buttonsList[x].value + buttonsList[y].value == valueCheck;
  }

  int _canCheck(int x, y, z, valueCheck) {
    if (buttonsList[x].value + buttonsList[y].value + buttonsList[z].value == valueCheck) {
      if (_check(x, y, valueCheck)) {
        return z;
      }
      if (_check(x, z, valueCheck)) {
        return y;
      }
      if (_check(y, z, valueCheck)) {
        return x;
      }
    }
    return -1;
  }

  int _canAttack(int x, y, z) {
    return _canCheck(x, y, z, -2);
  }

  int _canDefend(int x, y, z) {
    return _canCheck(x, y, z, 2);
  }

  int _doAction(Function doMove) {
    int index = doMove(0, 1, 2);

    if (index == -1) {
      index = doMove(3, 4, 5);
    }
    if (index == -1) {
      index = doMove(6, 7, 8);
    }
    if (index == -1) {
      index = doMove(0, 3, 6);
    }
    if (index == -1) {
      index = doMove(1, 4, 7);
    }
    if (index == -1) {
      index = doMove(2, 5, 8);
    }
    if (index == -1) {
      index = doMove(0, 1, 2);
    }
    if (index == -1) {
      index = doMove(0, 4, 8);
    }
    if (index == -1) {
      index = doMove(2, 4, 6);
    }
    return index;
  }

  int _defend() {
    return _doAction(_canDefend);
  }

  int _attack() {
    return _doAction(_canAttack);
  }

  int _checkLayer(int x, y, z) {
    int value = buttonsList[x].value + buttonsList[y].value + buttonsList[z].value;

    if ([3, -3].contains(value)) {
      return value > 0 ? 1 : 2;
    } 
    return -1;
  }
}
