import 'package:performance_management_system/pms.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isWeb = constraints.maxWidth > 800;

          return isWeb
              ? Row(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 450),
                      child: loginForm(context),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 3,
                child: Image.asset(
                  AssetRes.loginImage,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                ),
              ),
            ],
          )
              : SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: loginForm(context),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget loginForm(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 40),
          Image.asset(AssetRes.logo, height: 100),
          SizedBox(height: 20),
          Text(
            "Performance Monitoring System",
            textAlign: TextAlign.center,
            style: styleW500S22.copyWith(color: ColorRes.greyColor),
          ),
          SizedBox(height: 10),
          Text("LOGIN", style: styleW500S16.copyWith(color: ColorRes.black)),
          SizedBox(height: 30),

          CommonTextField(
            heading: "email".tr,
            controller: controller.emailController,
            hintText: "enter_email".tr,
            textInputType: TextInputType.emailAddress,
            errorText: controller.emailErrorText,
          ),
          SizedBox(height: 20),

          CommonTextField(
            heading: "password".tr,
            controller: controller.passwordController,
            hintText: "********",
            secureText: true,
            errorText: controller.passwordErrorText,
          ),
          SizedBox(height: 10),

          /*Row(
            children: [
              Expanded(child: Row(
                children: [
                  Checkbox(
                    value: controller.rememberMe,
                    onChanged: (value) {
                      setState(() {
                        controller.rememberMe = value!;
                      });
                    },
                  ),
                  Flexible(
                    child: Text(
                      'Remember me',
                      overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              )),
              // Use Flexible for the "Forgot password?" button to avoid overflow
              TextButton(
                onPressed: () {
                  // Add Forgot password logic here
                },
                child: Text(
                  'Forgot password?',
                  style: TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis, // Ensure text doesn't overflow
                ),
              ),
            ],
          ),*/

          SizedBox(height: 40),

          AppButton(
            onButtonTap: controller.login,
            buttonName: 'Sign In',
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
