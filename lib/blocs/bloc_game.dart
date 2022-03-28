import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/blocs/event_game.dart';
import 'package:tic_tac_toe/blocs/state_game.dart';

class BlocGame extends Bloc<EventGame, StateGame> {
  BlocGame._() : super(StateGameInitialize()) {}

  static BlocGame _blocInstance = BlocGame._();

  factory BlocGame() => _blocInstance;

}