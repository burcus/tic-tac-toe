import 'package:tic_tac_toe/models/player.dart';

class SquareStatus {
  final Player player;
  final bool isEmpty;
  final int index;

  SquareStatus(this.player, this.isEmpty, this.index);
}