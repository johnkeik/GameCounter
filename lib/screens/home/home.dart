import 'package:flutter/material.dart';
import 'package:game_counter/shared/start_game_modal.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<StatefulWidget> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return SingleChildScrollView(
      padding:
          EdgeInsets.only(top: topPadding, left: 15, right: 15, bottom: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Hello, John!',
            style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide( width: 4)),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Popular',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
          )),
              )),
          SizedBox(height: 15),
          SizedBox(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(
                                      20), // Border radius for the top edges
                                ),
                              ),
                              child: StartGameModal());
                        });
                  },
                  child: Container(
                      width: 150,
                      margin: EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.grey[400]),
                      child: Center(child: Text('Item'))),
                );
              },
            ),
          ),
          SizedBox(height: 15),
          Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.white, width: 4)),
                  borderRadius: BorderRadius.circular(8.0)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Custom',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              )),
          SizedBox(height: 15),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)),
              gradient: LinearGradient(
                begin: Alignment(0, -8),
                end: Alignment.bottomCenter,
                colors: [Colors.white, Color(0xFF333848)],
              ),
            ),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    child: Text(
                      'Oops!!! Are you new here?',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
                Text(
                  'What are you doing, create your own game presets and start playing with your friends',
                  style: TextStyle(color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (BuildContext context) {
                          return StartGameModal();
                        },
                      );
                    },
                    child: Text('Start now',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.red)),
                  ),
                )
              ],
            ),
          ),
          ElevatedButton(onPressed: () {}, child: Text('Hello'))
        ],
      ),
    );
  }
}
