import 'package:performance_management_system/pms.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final SplashController controller = Get.put(SplashController());

  @override
  void initState() {
    controller.navigatePage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Top section with background image
          Expanded(
            flex: 3, // Takes 3/4th of the screen
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    AssetRes.splashImage,
                    fit: BoxFit.cover,
                  ),
                ),
                Center(
                  child: Image.asset(
                    AssetRes.logoWhite, // Haryana Government Logo
                    height: 210,
                  ),
                ),
              ],
            ),
          ),

          // Bottom white section
          Expanded(
            flex: 1, // Takes 1/4th of the screen
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20), // Adds padding on both sides
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      "Welcome",
                      style: styleW500S28
                    ),
                    SizedBox(height: 3), // Space between text and line
                    Container(
                      width: 60, // Length of underline
                      height: 2, // Thickness of underline
                      color: ColorRes.appBlueColor, // Match the theme color
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Performance Monitoring System",
                      style: styleW400S14.copyWith(color: ColorRes.greyColor)
                    ),
                  ],
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
