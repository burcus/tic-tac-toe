import 'package:flutter/material.dart';
import 'package:tic_tac_toe/constants/custom_theme.dart';

class PageMain extends StatefulWidget {
  const PageMain({Key? key}) : super(key: key);

  @override
  State<PageMain> createState() => _PageMainState();
}

class _PageMainState extends State<PageMain> {
  void markContainer() {}

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
              child: GridView.builder(
                itemCount: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: markContainer,
                    child: Container(
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.white10)),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
