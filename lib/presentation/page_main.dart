import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:confetti/confetti.dart';
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
  late ConfettiController _controllerCenter;
  bool showWinner = false;
  late String winnerName;

  @override
  void initState() {
    super.initState();
    BlocGame().add(EventGameStart());
    _controllerCenter =
        ConfettiController(duration: const Duration(seconds: 10));
  }

  void markContainer(int index) {
    SquareStatus status = SquareStatus(BlocGame().currentPlayer, false, index);
    BlocGame().add(EventGameMark(status));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: BlocListener<BlocGame, StateGame>(
        listener: (context, state) async {
          if (state is StateGameRoundEnded) {
            _controllerCenter.play();
            setState(() {
              showWinner = true;
            });
            winnerName = state.winner.playerName;
            await Future.delayed(Duration(seconds: 3));
            BlocGame().add(EventGameStart());
            _controllerCenter.stop();
            setState(() {
              showWinner = false;
            });
          }
        },
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 72),
                  child: Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        scoreSection("Player 1", 1),
                        Spacer(),
                        scoreSection("Player 2", 2),
                      ],
                    ),
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
                                onTap: status == null || status.isEmpty
                                    ? () {
                                  markContainer(index);
                                }
                                    : () {},
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white10),
                                  ),
                                  child: status == null
                                      ? SizedBox.shrink()
                                      : Center(
                                    child: Text(
                                      status.player.playerName == "1"
                                          ? "X"
                                          : "O",
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
                                      border: Border.all(
                                          color: Colors.white10)),
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
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _controllerCenter,
                blastDirectionality: BlastDirectionality
                    .explosive,
                shouldLoop:
                true,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ],
                createParticlePath: drawStar, // define a custom shape/path.
              ),
            ),
            showWinner ? Center(
              child: DefaultTextStyle(
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 50.0,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    ScaleAnimatedText("The winner $winnerName"),
                  ],
                ),
              ),
            ) : SizedBox.shrink()
          ],
        ),
      ),
    );
  }

  Widget scoreSection(String title, int playerOrder) {
    return Column(
      children: [
        Text(
          title,
          style: CustomTheme.heading,
        ),
        SizedBox(
          height: 10,
        ),/* TODO show scores
        BlocBuilder(
          builder: (context, state) {
            if (state is StateGameRoundEnded) {
              return SizedBox.shrink();
            } else {
              return Text(BlocGame().player1.playerScore.toString(),
                  style: CustomTheme.heading);
            }
          },
        ),
        */
      ],
    );
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
