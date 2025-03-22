import 'package:get/get.dart';

class NavigationController extends GetxController {
  // Reactive selected index
  var selectedIndex = 0.obs;

  // Update index
  void changePage(int index) {
    selectedIndex.value = index;
    update();
  }
}