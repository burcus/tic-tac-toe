import 'package:tic_tac_toe/models/player.dart';

class SquareStatus {
  final Player player;
  final bool isEmpty;

  SquareStatus(this.player, this.isEmpty);
}