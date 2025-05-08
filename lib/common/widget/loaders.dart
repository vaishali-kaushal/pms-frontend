import 'package:loading_indicator/loading_indicator.dart';
import 'package:performance_management_system/pms.dart';

class AppLoader extends StatelessWidget {
  const AppLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return appSizedBox(
      height: 30,
      child: const LoadingIndicator(
          indicatorType: Indicator.ballPulse, /// Required, The loading type of the widget
          colors: [ColorRes.appBlueColor],       /// Optional, The color collections
          strokeWidth: 3,                     /// Optional, The stroke of the line, only applicable to widget which contains line
          pathBackgroundColor: ColorRes.appBlueColor   /// Optional, the stroke backgroundColor
      ),
    );
  }
}

class SmallLoader extends StatelessWidget {
  const SmallLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: AppLoader(),
    );
  }
}

class StackedLoader extends StatelessWidget {
  final Widget? child;
  final bool? loading;
  final double? height;
  final double? width;

  const StackedLoader({Key? key, this.child, this.loading,this.width,this.height}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child ?? const SizedBox(),
        if (loading == true)
          Container(
            color: ColorRes.black.withOpacity(0),
            height: height ?? Get.height,
            width: width ?? Get.width,
            child: const Center(
              child: AppLoader(),
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}

class TextStackedLoader extends StatelessWidget {
  final Widget? child;
  final bool? loading;
  final String? text;
  final double? progress;

  const TextStackedLoader(
      {Key? key, this.child, this.loading, this.text, this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child ?? const SizedBox(),
        if (loading == true)
          Container(
            color: ColorRes.black.withOpacity(0.1),
            height: Get.height,
            width: Get.width,
            child: Center(
              child: Container(
                height: 90,
                width: 90,
                decoration: BoxDecoration(
                  color: ColorRes.appBlueColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: CircularProgressIndicator(value: progress),
                      ),
                      const SizedBox(height: 10),
                      Text(text ?? '', style: styleW400S16),
                    ],
                  ),
                ),
              ),
            ),
          )
        else
          const SizedBox(),
      ],
    );
  }
}
