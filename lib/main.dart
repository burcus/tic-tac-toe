import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/blocs/bloc_game.dart';
import 'package:tic_tac_toe/blocs/event_game.dart';
import 'package:tic_tac_toe/blocs/observer.dart';
import 'package:tic_tac_toe/presentation/page_main.dart';

void main() {
  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: CustomBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
          create: (context) => BlocGame()..add(EventGameStart()),
          child: const PageMain()),
    );
  }
}
