import 'package:performance_management_system/pms.dart';


class AppButton extends StatelessWidget {
  final String buttonName;
  final double buttonHeight;
  final double? buttonWidth;
  final double? borderRadius;
  final double? fontSize;
  final bool isSelected;
  final bool isEnabled;
  final Color textColor;
  final Color backgroundColor;
  final FontWeight? fontWeight;
  final VoidCallback? onButtonTap;

  AppButton({
    Key? key,
    required this.buttonName,
    this.buttonHeight = 45,
    this.buttonWidth,
    this.borderRadius,
    this.onButtonTap,
    this.fontSize = 16,
    this.fontWeight = FontWeight.w500,
    this.isSelected = true,
    this.isEnabled = true,
    this.textColor = Colors.white,
    this.backgroundColor = ColorRes.buttonColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: isEnabled ? onButtonTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: buttonHeight,
          width: buttonWidth ?? MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius ?? 10),
            color: backgroundColor
          ),
          child: Text(
            buttonName,
            style: TextStyle(
              fontSize: fontSize,
              fontFamily: AssetRes.roboto,
              color: textColor,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}

class CommonAppbar extends StatelessWidget {
  final String? title;
  final Widget? rightWidget;
  final Widget? leftWidget;
  final bool? useSafeArea;
  final VoidCallback? onBackTap;
  final Color? backgroundColor;

  const CommonAppbar({
    Key? key,
    this.title,
    this.leftWidget,
    this.rightWidget,
    this.useSafeArea,
    this.onBackTap,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.white,
      shadowColor: Colors.white,
      child: Container(
        color: backgroundColor ?? ColorRes.appBlueColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: (MediaQuery.of(context).padding.top + 1.72.h)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                      child: inkWell(
                      onTap: Get.back,
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          AssetRes.backIcon,
                          height: 20,
                          width: 20,
                          color: ColorRes.white,
                        ),
                      ),
                    )
                  ),
                  Expanded(
                    flex: 8,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        appSizedBox(width: 1.w),
                        Flexible(
                          child: Text(
                            title ?? "",
                            style: styleW600S15.copyWith(fontSize: 19, color: ColorRes.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: rightWidget ?? appSizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            appSizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CommonMenuAppbar extends StatelessWidget {
  final String? title;
  final Widget? rightWidget;
  final Widget? leftWidget;
  final bool? useSafeArea;
  final VoidCallback? onBackTap;
  final Color? backgroundColor;

  const CommonMenuAppbar({
    Key? key,
    this.title,
    this.leftWidget,
    this.rightWidget,
    this.useSafeArea,
    this.onBackTap,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      color: Colors.white,
      shadowColor: Colors.white,
      child: Container(
        color: backgroundColor ?? ColorRes.appBlueColor,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: (MediaQuery.of(context).padding.top + 1.72.h), left: AppPadding.appHorizontalPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          AssetRes.logo,
                          height: 50,
                        ),
                        appSizedBox(width: 3.w),
                        Flexible(
                          child: Text(
                            title ?? "",
                            style: styleW600S15.copyWith(fontSize: 19, color: ColorRes.white),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: rightWidget ?? appSizedBox(),
                    ),
                  ),
                ],
              ),
            ),
            appSizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

class CommonBackButton extends StatelessWidget {
  final String? iconName;
  final VoidCallback? onTap;
  Color? iconColor;

  CommonBackButton({Key? key, this.iconName, this.onTap,this.iconColor = ColorRes.white}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return inkWell(
      onTap: onTap ?? () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.only(top: 20, left: 8),
        height: 40,
        width: 40,
        alignment: Alignment.center,
        child: Image.asset(
          iconName ?? AssetRes.backIcon,
          height: 20,
          width: 20,
          color: iconColor,
        ),
      ),
    );
  }
}

class ViewActionButton extends StatelessWidget {
  final dynamic data;
  final dynamic controller;
  final VoidCallback onPressed;

  const ViewActionButton({
    super.key,
    required this.data,
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ColorRes.appBlueColor,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      child: Text(
        "View",
        style: styleW400S14.copyWith(color: Colors.white),
      ),
    );
  }
}

Future<void> showCommonSideDialog<T>({
  required BuildContext context,
  required T dataModel,
  required String title,
  required List<Widget> Function(T model) buildInfoWidgets,
  List<Widget> extraWidgets = const [],
  List<Widget> actionButtons = const [],
}) async {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: title,
    pageBuilder: (_, __, ___) {
      return Align(
        alignment: Alignment.centerRight,
        child: Material(
          color: Colors.white,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: double.infinity,
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ],
                          ),

                          const SizedBox(height: 10),

                          ...buildInfoWidgets(dataModel),
                          const SizedBox(height: 10),

                          ...extraWidgets,
                          const Spacer(),

                          if (actionButtons.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Row(
                              children: actionButtons
                                  .map((btn) => Expanded(child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                child: btn,
                              )))
                                  .toList(),
                            ),
                          ],
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: const Offset(1, 0), end: Offset.zero).animate(anim),
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 300),
  );
}
