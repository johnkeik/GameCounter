import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:game_counter/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  
  // Flag to determine if we should use local storage
  final bool useLocalStorage;
  
  // Constructor with optional parameter
  ThemeController({this.useLocalStorage = true});
  
  // Theme settings
  final _themeMode = ThemeMode.system.obs;
  final _themeIndex = 0.obs;
  
  // Get current theme mode
  ThemeMode get themeMode => _themeMode.value;
  
  // Get current theme index
  int get themeIndex => _themeIndex.value;
  
  // Theme data
  List<ThemeData> get themes => [
    // Default Green theme
    ThemeData.from(colorScheme: lightColorScheme).copyWith(useMaterial3: true),
    // Blue theme
    ThemeData.from(colorScheme: blueColorScheme).copyWith(useMaterial3: true),
    // Purple theme
    ThemeData.from(colorScheme: purpleColorScheme).copyWith(useMaterial3: true),
    // Orange theme
    ThemeData.from(colorScheme: orangeColorScheme).copyWith(useMaterial3: true),
  ];
  
  List<ThemeData> get darkThemes => [
    // Default Green dark theme
    ThemeData.from(colorScheme: darkColorScheme).copyWith(useMaterial3: true),
    // Blue dark theme
    ThemeData.from(colorScheme: blueDarkColorScheme).copyWith(useMaterial3: true),
    // Purple dark theme
    ThemeData.from(colorScheme: purpleDarkColorScheme).copyWith(useMaterial3: true),
    // Orange dark theme
    ThemeData.from(colorScheme: orangeDarkColorScheme).copyWith(useMaterial3: true),
  ];
  
  // Theme names for display
  List<String> get themeNames => [
    'Green (Default)', 
    'Blue Ocean', 
    'Royal Purple', 
    'Sunset Orange'
  ];
  
  @override
  void onInit() {
    super.onInit();
    if (useLocalStorage) {
      loadThemeSettings();
    }
  }
  
  // Load saved theme settings with error handling
  Future<void> loadThemeSettings() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _themeIndex.value = prefs.getInt('themeIndex') ?? 0;
      
      final savedMode = prefs.getString('themeMode');
      switch (savedMode) {
        case 'dark':
          _themeMode.value = ThemeMode.dark;
          break;
        case 'light':
          _themeMode.value = ThemeMode.light;
          break;
        default:
          _themeMode.value = ThemeMode.system;
      }
      
      update();
    } catch (e) {
      if (kDebugMode) {
        print("Error loading theme settings: $e");
      }
      // Keep default values on error
    }
  }
  
  // Change theme mode (light, dark, system) with error handling
  void setThemeMode(ThemeMode mode) async {
    _themeMode.value = mode;
    Get.changeThemeMode(mode);
    
    if (useLocalStorage) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        switch (mode) {
          case ThemeMode.dark:
            prefs.setString('themeMode', 'dark');
            break;
          case ThemeMode.light:
            prefs.setString('themeMode', 'light');
            break;
          case ThemeMode.system:
            prefs.setString('themeMode', 'system');
            break;
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error saving theme mode: $e");
        }
        // Continue even if storage fails
      }
    }
    update();
  }
  
  // Change theme color with error handling
  void setThemeColor(int index) async {
    _themeIndex.value = index;
    
    if (useLocalStorage) {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setInt('themeIndex', index);
      } catch (e) {
        if (kDebugMode) {
          print("Error saving theme index: $e");
        }
        // Continue even if storage fails
      }
    }
    update();
  }
  
  // Get current theme
  ThemeData get currentLightTheme => themes[_themeIndex.value];
  ThemeData get currentDarkTheme => darkThemes[_themeIndex.value];
}
