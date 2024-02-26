import 'package:get/get.dart';
import 'package:note_hive/App_Page/home_Screen/controller/home_controller.dart';

class HomeBinding extends Bindings{
  @override
  void dependencies() {
    // TODO: implement dependencies
    Get.lazyPut(() => HomeController());
  }

}