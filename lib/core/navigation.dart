import 'package:flutter/material.dart';
import 'package:game_counter/controllers/game_controller.dart';
import 'package:game_counter/controllers/navigation_controller.dart';
import 'package:game_counter/screens/game/game_view.dart';
import 'package:game_counter/screens/home/home.dart';
import 'package:game_counter/screens/profile/profile.dart';
import 'package:game_counter/shared/start_game_modal.dart';
import 'package:get/get.dart';

class NavigationComponent extends StatelessWidget {
  final NavigationController navigationController =
      Get.put(NavigationController());
  final GameController gameController = Get.put(GameController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder<NavigationController>(builder: (controller) {
      return Scaffold(

        backgroundColor: Theme.of(context).primaryColor,
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: [Home(), GameView(), Profile()],
        ),
        resizeToAvoidBottomInset: true,
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 35),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.sports_esports, size: 35),
              label: 'Game',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 35),
              label: 'Profile',
            ),
          ],
          currentIndex: controller.selectedIndex.value,

          onTap: (index) {
            // if (index == 1 && gameController.game.value == null) {
            //   Get.bottomSheet(StartGameModal());
            // } else {
              controller.changePage(index);
            // }
          },
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: UiColor.primary,
        //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        //   onPressed: () {
        //     if (gameController.game.value != null) {
        //       navigationController.changePage(1);
        //     } else {
        //       Get.bottomSheet(StartGameModal());
        //     }
        //   },
        //   tooltip: 'Game',
        //   child: const Icon(
        //     Icons.sports_esports,
        //     size: 35.0,
        //   ),
        // ),
      );
    });
  }
}
