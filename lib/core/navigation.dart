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
    final colorScheme = Theme.of(context).colorScheme;
    
    return GetBuilder<NavigationController>(builder: (controller) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: IndexedStack(
          index: controller.selectedIndex.value,
          children: [Home(), GameView(), Profile()],
        ),
        resizeToAvoidBottomInset: true,
        
        // Compact Modern Navigation Bar
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: Offset(0, -1),
              ),
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(16))
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildCompactNavItem(
                    context: context,
                    icon: Icons.home_rounded,
                    label: 'Home',
                    isSelected: controller.selectedIndex.value == 0,
                    onTap: () => controller.changePage(0),
                    colorScheme: colorScheme,
                  ),
                  _buildCompactNavItem(
                    context: context,
                    icon: Icons.sports_esports_rounded,
                    label: 'Game',
                    isSelected: controller.selectedIndex.value == 1,
                    onTap: () {
                      if (gameController.game.value == null) {
                        Get.bottomSheet(StartGameModal(), isScrollControlled: true, enableDrag: true);
                      } else {
                        controller.changePage(1);
                      }
                    },
                    colorScheme: colorScheme,
                  ),
                  _buildCompactNavItem(
                    context: context,
                    icon: Icons.person_rounded,
                    label: 'Profile',
                    isSelected: controller.selectedIndex.value == 2,
                    onTap: () => controller.changePage(2),
                    colorScheme: colorScheme,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
  
  // More compact navigation item
  Widget _buildCompactNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required ColorScheme colorScheme,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary.withOpacity(0.15) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
              ),
              if (isSelected) ...[
                const SizedBox(width: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
