import 'package:flutter/material.dart';
import 'package:game_counter/controllers/theme_controller.dart';
import 'package:game_counter/core/navigation.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize theme controller with error handling
  await initializeThemeController();
  
  runApp(MyApp());
}

Future<void> initializeThemeController() async {
  try {
    // Initialize shared preferences
    await SharedPreferences.getInstance();
    
    // Put the theme controller in memory before the app starts
    Get.put(ThemeController());
  } catch (e) {
    // Handle initialization errors
    if (kDebugMode) {
      print("Failed to initialize SharedPreferences: $e");
    }
    // Still create the controller, but with default values only
    Get.put(ThemeController(useLocalStorage: false));
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(
      builder: (controller) => GetMaterialApp(
        title: 'Game Counter',
        theme: controller.currentLightTheme,
        darkTheme: controller.currentDarkTheme,
        themeMode: controller.themeMode,
        debugShowCheckedModeBanner: false,
        home: NavigationComponent(),
      ),
    );
  }
}
