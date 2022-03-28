import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tic_tac_toe/blocs/bloc_game.dart';
import 'package:tic_tac_toe/blocs/event_game.dart';
import 'package:tic_tac_toe/blocs/state_game.dart';
import 'package:tic_tac_toe/constants/custom_theme.dart';
import 'package:tic_tac_toe/models/square_status.dart';

class PageMain extends StatefulWidget {
  const PageMain({Key? key}) : super(key: key);

  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  @override
  void initState() {
    super.initState();
    BlocGame().add(EventGameStart());
  }

  void markContainer(int index) {
    SquareStatus status = SquareStatus(BlocGame().currentPlayer, false, index);
    BlocGame().add(EventGameMark(status));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 72),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Player 1", style: CustomTheme.heading),
                Spacer(),
                Text(
                  "Player 2",
                  style: CustomTheme.heading,
                )
              ],
            ),
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32),
              child: BlocBuilder<BlocGame, StateGame>(
                builder: (context, state) {
                  if (state is StateGameMarked) {
                    return GridView.builder(
                      itemCount: 9,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        SquareStatus? status = state.status[index];
                        return GestureDetector(
                          onTap: () {
                            markContainer(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white10),
                            ),
                            child: status == null
                                ? SizedBox.shrink()
                                : Center(
                                  child: Text(
                                      status.player.playerName == "1" ? "X" : "O",
                                      style: CustomTheme.mark,
                                    ),
                                ),
                          ),
                        );
                      },
                    );
                  } else {
                    return GridView.builder(
                      itemCount: 9,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            markContainer(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white10)),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
