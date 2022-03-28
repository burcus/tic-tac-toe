import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/blocs/event_game.dart';
import 'package:tic_tac_toe/blocs/state_game.dart';
import 'package:tic_tac_toe/models/player.dart';
import 'package:tic_tac_toe/models/square_status.dart';

class BlocGame extends Bloc<EventGame, StateGame> {
  BlocGame._() : super(StateGameInitialize()) {
    on<EventGameStart>(startParameters);
    on<EventGameMark>(mark);
  }

  static BlocGame _blocInstance = BlocGame._();

  factory BlocGame() => _blocInstance;

  Player player1 = Player("1", 0);
  Player player2 = Player("2", 0);

  List<String> x_list = []; //TODO make late
  List<String> o_list = [];
  List<SquareStatus> status = [];

  late Player currentPlayer;

  void mark(EventGameMark event, emit) {
    emit(StateGameMarked(status));
  }

  void startParameters(event, state) {
    print("test");
    currentPlayer = player1;
  }
}
