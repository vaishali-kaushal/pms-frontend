import 'package:performance_management_system/pms.dart';

extension SizerExt on num {
  double get h => this * Get.height / 100;
  double get w => this * Get.width / 100;
  double get sp => this * (Get.width / 3) / 100;
}

Widget appSizedBox({double? width, double? height, Widget? child}) {
  return SizedBox(
    height: height,
    width: width,
    child: child,
  );
}

class AppPadding {
  static double horizontalPadding = 6.4.w;
  static double verticalPadding = 3.0.w;
  static double appHorizontalPadding = 4.w;
}