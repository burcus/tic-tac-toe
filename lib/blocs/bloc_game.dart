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
  late var gameBoard;

  Player get nextPlayer => currentPlayer == player1 ? player2 : player1;

  void markGameBoard(SquareStatus status) {
    int boardIndex = status.index + 1;
    int rowIndex = boardIndex <= 3
        ? 0
        : boardIndex > 3 && boardIndex <= 6
            ? 1
            : 2;
    int columnIndex = status.index % 3;
    gameBoard[rowIndex][columnIndex] = currentPlayer.playerOrder == 1 ? 1 : 2;
    print("current gameBoard = ${gameBoard}");
  }

  void checkStatusList() {
    bool isThereWinner = false;
    for (List<int> row in gameBoard) {
      if (row.every((column) => column == 1) ||
          row.every((column) => column == 2)) {
        isThereWinner = true;
      }
    }

    for (int i = 0; i < gameBoard[0].lenght; i++) {
      bool same = true;
      for (int y = 0; i < gameBoard[0].length; y++) {
        if (gameBoard[i][y] == 1)
          break;
        else {
          same = false;
        }
      }
    }
    print(isThereWinner);
  }

  void mark(EventGameMark event, emit) {
    status[event.status.index] = event.status;
    markGameBoard(event.status);
    checkStatusList();
    currentPlayer = nextPlayer;
    emit(StateGameMarked(status));
  }

  void startParameters(event, state) {
    currentPlayer = player1;
    status = List.generate(9, (index) => null);
    gameBoard = List.generate(3, (i) => List.filled(3, -1, growable: false),
        growable: false);
  }
}
