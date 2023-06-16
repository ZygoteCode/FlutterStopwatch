import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icon.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stopwatch',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Stopwatch'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String currentTime = '00:00:00';
  int totalSeconds = 0;
  bool canContinue = true;
  Timer? timer;
  bool started = false;
  bool italian = true;

  void start() {
    started = true;
    canContinue = true;
    currentTime = '00:00:00';
    totalSeconds = 0;

    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      if (canContinue) {
        setState(() {
          totalSeconds++;
          currentTime = convertSecondsToTime();
        });
      }
    });
  }

  String convertSecondsToTime() {
    String hours = '', minutes = '', seconds = '';
    int numHours = 0, numMinutes = 0, numSeconds = 0;
    int tempTotalSeconds = totalSeconds;

    while (tempTotalSeconds >= 3600) {
      numHours++;
      tempTotalSeconds -= 3600;
    }

    while (tempTotalSeconds >= 60) {
      numMinutes++;
      tempTotalSeconds -= 60;
    }

    while (tempTotalSeconds > 0) {
      numSeconds++;
      tempTotalSeconds--;
    }

    hours = numHours.toString();
    minutes = numMinutes.toString();
    seconds = numSeconds.toString();

    if (hours.length == 1) {
      hours = "0$hours";
    }

    if (minutes.length == 1) {
      minutes = "0$minutes";
    }

    if (seconds.length == 1) {
      seconds = "0$seconds";
    }

    return "$hours:$minutes:$seconds";
  }

  void pause() {
    canContinue = !canContinue;
  }

  void stop() {
    started = false;
    canContinue = true;
    timer?.cancel();
    currentTime = '00:00:00';
    totalSeconds = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        titleTextStyle: GoogleFonts.robotoMono(
          textStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: LineIcon.language(),
            onPressed: () {
              setState(() {
                italian = !italian;
              });
            },
            color: Colors.white,
          ),
          IconButton(
            icon: LineIcon.github(),
            onPressed: () {
              launchUrl(Uri.parse('https://github.com/GabryB03/'));
            },
            color: Colors.white,
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              FlutterExitApp.exitApp(iosForceExit: true);
            },
            color: Colors.white,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              currentTime,
              style: GoogleFonts.robotoMono(
                textStyle: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w300,
                )
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: started ? null : () {
                        if (!started) {
                          setState(() {
                            start();
                          });
                        }
                      },
                      style: !started ? ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.robotoMono()),
                      ) : ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.robotoMono()),
                      ),
                      child: Text(italian ? 'Avvia' : 'Start'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: !started ? null : () {
                        if (started) {
                          setState(() {
                            pause();
                          });
                        }
                      },
                      style: started ? ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.robotoMono()),
                      ) : ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.robotoMono()),
                      ),
                      child: Text(canContinue ? (italian ? 'Pausa' : 'Pause') : (italian ? 'Riprendi' : 'Resume')),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: started ? () {
                        setState(() {
                          stop();
                        });
                      } : null,
                      style: started ? ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.robotoMono()),
                      ) : ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        textStyle: MaterialStateProperty.all<TextStyle>(GoogleFonts.robotoMono()),
                      ),
                      child: Text(italian ? 'Ferma' : 'Stop'),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                italian ? 'Realizzato da Gabriele Bologna, la sua prima applicazione Android per dispositivi mobili in assoluto.' : 'Realized by Gabriele Bologna, his first Android application for mobile devices in his life.',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  )
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
