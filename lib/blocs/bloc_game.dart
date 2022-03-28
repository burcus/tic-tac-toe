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

  static const int ROUND_LIMIT = 5;

  Player player1 = Player("1", 0, 1); //TODO get name from user
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

  bool checkRows() {
    bool isThereWinner = false;

    for (List<int> row in gameBoard) {
      if (row.every((column) => column == 1) ||
          row.every((column) => column == 2)) {
        isThereWinner = true;
      }
    }
    return isThereWinner;
  }

  bool checkColumns() {
    late bool isThereWinner;
    for (int i = 0; i < 3; i++) {
      List<int> currentColumn = [];
      for (int y = 0; y < 3; y++) {
        currentColumn.add(gameBoard[y][i]);
      }
      isThereWinner = currentColumn.every((e) => e == 1) ||
          currentColumn.every((e) => e == 2);
      if (isThereWinner) break;
    }
    return isThereWinner;
  }

  bool checkDiagonal() {
    List<int> diagonal = [];
    for (int i = 0; i < 3; i++) {
      diagonal.add(gameBoard[i][i]);
    }
    bool isThereWinner =
        diagonal.every((e) => e == 1) || diagonal.every((e) => e == 2);

    if (!isThereWinner) {
      int columnIndex = gameBoard[0].length - 1;
      diagonal.clear();
      for (int i = 0; i < 3; i++) {
        diagonal.add(gameBoard[i][columnIndex]);
        columnIndex = columnIndex - 1;
      }
      isThereWinner =
          diagonal.every((e) => e == 1) || diagonal.every((e) => e == 2);
    }
    return isThereWinner;
  }

  bool checkStatusList() {
    return checkRows() || checkColumns() || checkDiagonal();
  }

  void mark(EventGameMark event, emit) {
    status[event.status.index] = event.status;
    markGameBoard(event.status);
    if (!checkStatusList()) {
      currentPlayer = nextPlayer;
      emit(StateGameMarked(status));
    } else {
      currentPlayer.playerScore += 1;
      if (currentPlayer.playerScore == ROUND_LIMIT)
        emit(StateGameEnded());
      else
        emit(StateGameRoundEnded([player1, player2], currentPlayer));
    }
  }

  void startParameters(event, state) {
    player1.playerScore = 0;
    player2.playerScore = 0;
    currentPlayer = player1;
    status = List.generate(9, (index) => null);
    gameBoard = List.generate(3, (i) => List.filled(3, -1, growable: false),
        growable: false);
  }
}
