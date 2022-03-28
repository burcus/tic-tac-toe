import 'package:tic_tac_toe/models/square_status.dart';

abstract class EventGame {}

class EventGameMark extends EventGame {
  final SquareStatus status;

  EventGameMark(this.status);
}

class EventGameStart extends EventGame {}