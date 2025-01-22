import 'package:budget_tracker_app/screen/home/home_screen.dart';
import 'package:budget_tracker_app/screen/splash/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String splash = '/';
  static const String home = '/home';

  static List<GetPage> routes() {
    return [
      GetPage(name: splash, page: () => const SplashScreen()),
      GetPage(name: home, page: () => HomeScreen()),
    ];
  }
}
