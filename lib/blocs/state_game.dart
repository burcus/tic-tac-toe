import 'package:tic_tac_toe/models/player.dart';
import 'package:tic_tac_toe/models/square_status.dart';

abstract class StateGame {}

class StateGameInitialize extends StateGame {}

class StateGameMarked extends StateGame {
  final List<SquareStatus?> status;

  StateGameMarked(this.status);
}

class StateGameRoundEnded extends StateGame {
  final List<Player> players;
  final Player winner;

  StateGameRoundEnded(this.players, this.winner);
}

class StateGameEnded extends StateGame {}
