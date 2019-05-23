import 'package:flutter/material.dart';

import 'package:tictactoe/src/custom_dailog.dart';
import 'package:tictactoe/src/game_button.dart';
import 'package:tictactoe/src/game.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameButton> buttonsList;
  Game game;
  String gameMode;

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
    gameMode = "Jogador X IA";
  }

  List<GameButton> doInit() {
    game = new Game(
        useAutoPlay: game?.useAutoPlay ?? true, onTied: onTied, onWin: onWin);

    return game.buttonsList;
  }

  void showMessage({String title = '', String message = ''}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => new CustomDialog(title, message, resetGame));
  }

  void onTied() {
    String title = "O Jogo Empatou";
    String message = "Precione o botão de Reiniciar para jogar novamente.";
    if (game.useAutoPlay) {
      message = "Será que você não vai conseguir me ganhar?";
    }
    showMessage(title: title, message: message);
  }

  void onWin(int winner) {
    String title = "Jogador ${winner == 1 ? "1" : "2"} Venceu";
    String message = "Precione o botão de Reiniciar para jogar novamente.";

    if (game.useAutoPlay) {
      if (winner == 2) {
        title = "Venci, Venci! HAHAHAHAHA...";
        message = "E aí, vai encarar outra vez?";
      } else {
        title = "Parabéns!";
        message = "Topa uma revanche?";
      }
    }

    showMessage(title: title, message: message);
  }

  void resetGame() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
    setState(() {
      buttonsList = doInit();
    });
  }

  void playGame(int i) {
    setState(() {
      game.play(buttonsList[i]);
    });
  }

  void changeMode() {
    setState(() {
      bool mode = !game.useAutoPlay;

      resetGame();
      game.useAutoPlay = mode;

      gameMode = mode ? "Jogador X IA" : "Jogador X Jogador";
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Jogo da Véia"),
        ),
        body: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Center(
                child: new Text(
              gameMode,
              style: new TextStyle(
                  color: Colors.indigoAccent,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w700),
            )),
            new Expanded(
              child: new GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 9.0,
                    mainAxisSpacing: 9.0),
                itemCount: buttonsList.length,
                itemBuilder: (context, i) => new SizedBox(
                      width: 100.0,
                      height: 100.0,
                      child: new RaisedButton(
                        padding: const EdgeInsets.all(8.0),
                        onPressed:
                            buttonsList[i].enabled ? () => playGame(i) : null,
                        child: new Text(
                          buttonsList[i].text,
                          style: new TextStyle(
                              color: Colors.white, fontSize: 20.0),
                        ),
                        color: buttonsList[i].bg,
                        disabledColor: buttonsList[i].bg,
                      ),
                    ),
              ),
            )
          ],
        ),
        persistentFooterButtons: [
          new RaisedButton(
            child: new Text(
              "Mudar Modo",
              style: new TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            color: Colors.red,
            padding: const EdgeInsets.all(15.0),
            onPressed: changeMode,
          ),
          new RaisedButton(
            child: new Text(
              "Reiniciar",
              style: new TextStyle(color: Colors.white, fontSize: 20.0),
            ),
            color: Colors.indigo,
            padding: const EdgeInsets.all(15.0),
            onPressed: resetGame,
          )
        ]);
  }
}
