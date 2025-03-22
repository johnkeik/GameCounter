import 'package:flutter/material.dart';
import 'package:game_counter/controllers/game_controller.dart';
import 'package:get/get.dart';

class GameView extends StatefulWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  Color generateBackgroundColor(int index) {
    List<Color> backgroundColors = [
      const Color.fromARGB(255, 174, 209, 175),
      const Color.fromARGB(255, 190, 211, 191),
      const Color.fromARGB(255, 163, 192, 164),
      const Color.fromARGB(255, 148, 197, 149),
    ];
    return backgroundColors[index % backgroundColors.length];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Game Name',
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary)),
              SizedBox(height: 4),
              Expanded(
                  child: DefaultTabController(
                      length: 2,
                      child: Scaffold(
                        appBar: TabBar(
                          tabs: [
                            Tab(text: 'Teams'),
                            Tab(text: 'Rounds'),
                          ],
                        ),
                        body: Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: TabBarView(
                            children: [
                              GetBuilder<GameController>(
                                builder: (controller) {
                                  return ListView.builder(
                                    itemCount: 10,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        padding: const EdgeInsets.only(
                                            left: 16,
                                            right: 16,
                                            bottom: 8,
                                            top: 8),
                                        decoration: BoxDecoration(
                                          color: generateBackgroundColor(index),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Team ${index + 1}'),
                                            Row(
                                              children: [
                                                TextButton(
                                                    style: TextButton.styleFrom(
                                                        foregroundColor:
                                                            colorScheme
                                                                .onPrimary,
                                                        backgroundColor:
                                                            colorScheme
                                                                .primary),
                                                    onPressed: () {},
                                                    child: Text('-10')),
                                                SizedBox(width: 24),
                                                Expanded(
                                                    child: TextField(
                                                  textAlign: TextAlign.center,
                                                )),
                                                SizedBox(width: 24),
                                                TextButton(
                                                    style: TextButton.styleFrom(
                                                        foregroundColor:
                                                            colorScheme
                                                                .onPrimary,
                                                        backgroundColor:
                                                            colorScheme
                                                                .primary),
                                                    onPressed: () {},
                                                    child: Text('+10')),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                              Center(child: Text('Settings')),
                            ],
                          ),
                        ),
                      ))),
              SizedBox(height: 16),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: colorScheme.onPrimary,
                    backgroundColor: colorScheme.primary),
                onPressed: () => {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Round Submitted!'),
                      duration: Duration(seconds: 2), // Customize the duration
                    ),
                  )
                },
                child: Text('Submit Round'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
