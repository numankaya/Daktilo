import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String userName = "";
  int typedCharLength = 0;
  String text =
      "                    ali veli numa kaya kale araba kalem silgi bilgisayar ekran klavye ali veli numa kaya kale araba kalem silgi bilgisayar ekran klavye ali veli numa kaya kale araba kalem silgi bilgisayar ekran klavye       "
          .toLowerCase()
          .replaceAll('.', '')
          .replaceAll(',', '');

  int step = 0;
  int lastTypedAt;

  void updateLastTypedAt() {
    this.lastTypedAt = DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypedAt();
    String trimmedValue = text.trimLeft();
    setState(() {
      if (trimmedValue.indexOf(value) != 0) {
        step = 2;
      } else {
        typedCharLength = value.length;
      }
    });
  }

  onUserNameType(String value) {
    setState(() {
      this.userName = value.substring(0, 3);
    });
  }

  void resetGame() {
    setState(() {
      typedCharLength = 0;
      step = 0;
    });
  }

  void OnStartClick() {
    setState(() {
      updateLastTypedAt();
      step++;
    });

    var timer = Timer.periodic(new Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;

      //GAME OVER

      setState(() {
        if (step == 1 && now - lastTypedAt > 4000) {
          timer.cancel();
          step++;
        }
        if (step != 1) {
          timer.cancel();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;

    if (step == 0)
      shownWidget = <Widget>[
        Text('Oyuna Hosgeldiniz'),
        Container(
          padding: EdgeInsets.all(20),
          child: TextField(
            onChanged: onUserNameType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Ismin nedir, Daktilo yazari?',
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text('BASLA'),
            onPressed: userName.length == 0 ? null : OnStartClick,
          ),
        ),
      ];
    else if (step == 1)
      shownWidget = <Widget>[
        Text('$typedCharLength'),
        Container(
          margin: EdgeInsets.only(left: 0),
          height: 40,
          child: Marquee(
            text: text,
            style: TextStyle(
                fontSize: 24, letterSpacing: 2, fontFamily: 'monospace'),
            scrollAxis: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            blankSpace: 20.0,
            velocity: 75.0,
            pauseAfterRound: Duration(seconds: 1),
            startPadding: 100.0,
            accelerationDuration: Duration(seconds: 1),
            accelerationCurve: Curves.linear,
            decelerationDuration: Duration(milliseconds: 500),
            decelerationCurve: Curves.easeOut,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, top: 32),
          child: TextField(
            autofocus: true,
            onChanged: onType,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Yaz bakalım',
            ),
          ),
        ),
      ];
    else
      shownWidget = <Widget>[
        Text('Oyun Bittiii: $typedCharLength'),
        RaisedButton(
          child: Text('Yeniden dene!'),
          onPressed: resetGame,
        )
      ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Daktilo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: shownWidget,
        ),
      ),
    );
  }
}
