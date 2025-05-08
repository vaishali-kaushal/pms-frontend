import 'package:performance_management_system/pms.dart';

bool isSplashNavigate = false;

class SplashController extends GetxController {

  Future<void> navigatePage() async {
    String accessToken = PrefService.getString(PrefKeys.accessToken);
    print("Access Token: ${PrefService.getString(PrefKeys.accessToken)}");


    Future.delayed(const Duration(seconds: 1), () async {
      if (accessToken.isNotEmpty) {
        Get.offAll(()=> DashboardScreen());
      }else{
        Get.offAll(()=> LoginScreen());
      }
    });
  }

}
