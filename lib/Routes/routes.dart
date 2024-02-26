import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:note_hive/App_Page/home_Screen/binding/home_binding.dart';
import 'package:note_hive/App_Page/home_Screen/home_screen.dart';

class AppRoutes {
  static const String homeScreen = "/homeScreen";

  static List<GetPage> page = [
    GetPage(
        name: homeScreen, page: () => HomeScreen(), bindings: [HomeBinding()]),
  ];
}
