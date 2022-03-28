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

  Player player1 = Player("1", 0, 1);
  Player player2 = Player("2", 0, 2);

  List<SquareStatus?> status = [];

  late Player currentPlayer;

  Player get nextPlayer => currentPlayer == player1 ? player2 : player1;

  void checkStatusList() {
    List<Player?> players = status.take(3).map((e) => e?.player).toList();
  }

  void mark(EventGameMark event, emit) {
    status[event.status.index] = event.status;
    checkStatusList();

    currentPlayer = nextPlayer;
    emit(StateGameMarked(status));
  }

  void startParameters(event, state) {
    currentPlayer = player1;
    status = List.generate(9, (index) => null);
  }
}
