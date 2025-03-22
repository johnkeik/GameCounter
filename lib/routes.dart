import 'package:game_counter/core/navigation.dart';
import 'package:game_counter/screens/game/game_view.dart';
import 'package:game_counter/screens/home/home.dart';
import 'package:game_counter/screens/profile/profile.dart';
import 'package:get/get.dart';

class Routes {
  static String navbar = '/';
  static String home = '/home';
  static String game = '/game';
  static String profile = '/profile';

  static getNavbar() => navbar;
  static getHome() => home;
  static getGame() => game;
  static getProfile() => profile;

  static List<GetPage> routes = [
    GetPage(name: navbar, page: () => NavigationComponent()),
    GetPage(name: home, page: () => Home()),
    GetPage(name: game, page: () => GameView()),
    GetPage(name: profile, page: () => Profile())

  ];

}