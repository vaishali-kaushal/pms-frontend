import 'package:performance_management_system/pms.dart';

class AuthController extends GetxController {
  bool loader = false;
  String emailErrorText = "";
  String passwordErrorText= "";
  bool rememberMe = false;
  final formKey = GlobalKey<FormState>();
  DateTime? currentBackPressTime;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      toastMsg('Press back again to exit the app', gravity: ToastGravity.BOTTOM);
      return Future.value(false);
    }
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    return Future.value(true);
  }

  void toggleRememberMe(bool value) {
    rememberMe = value;
    update(['login']); // ✅ Updates UI where `GetBuilder` is used
  }

  loginValidation() {
    if (emailController.text.isEmpty) {
      emailErrorText = "please_enter_email".tr;
    } else {
      emailErrorText = "";
    }

    if (passwordController.text.isEmpty) {
      passwordErrorText = "please_enter_password".tr;
    } else if (passwordController.text.length < 6) {
      passwordErrorText = "password_too_short".tr;
    } else {
      passwordErrorText = "";
    }

    update(['login']);
    return emailErrorText.isEmpty && passwordErrorText.isEmpty;
  }

   login() async {
     Get.to(()=> DashboardScreen());
    if(loginValidation()){
      FocusManager.instance.primaryFocus?.unfocus();
      loader = true;
      update(['login']);
      Map<String,String> verifyBody = {
        "email": emailController.text.toString().trim(),
        "password": passwordController.text.toString().trim(),
      };
      try {
        LoginModel? model = await AuthApi.userLogin(verifyBody);

        if (model != null) {
          if (model.status == "success") {
            if (model.data?.token != null) {
              await PrefService.set(PrefKeys.isLogin, true);
              await PrefService.set(PrefKeys.accessToken, model.data?.token.toString());
              await PrefService.set(PrefKeys.userName, model.data?.user?.name.toString());
              await PrefService.set(PrefKeys.userId, model.data?.user?.id.toString());
              await PrefService.set(PrefKeys.department, model.data?.user?.department.toString());
              await PrefService.set(PrefKeys.designation, model.data?.user?.designation.toString());
              await PrefService.set(PrefKeys.designationId, model.data?.user?.designationId.toString());
              await PrefService.set(PrefKeys.role, model.data?.user?.role.toString());
              await PrefService.set(PrefKeys.secureId, model.data?.user?.secureId.toString());

              Get.offAll(()=> DashboardScreen());
            }
          } else {
            toastMsg(model.message.toString());
          }
        }else {
          toastMsg('something_went_wrong'.tr);
        }
      } catch (e) {
        debugPrint("Unexpected response format: ${e.toString()}");
      }
      loader = false;
      update(['login']);
    }

  }

}


