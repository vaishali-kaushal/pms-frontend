import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:performance_management_system/pms.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  try {
    await PrefService.init();
    HttpOverrides.global = MyHttpOverrides();
  } catch (e) {
    debugPrint("Error during initialization: $e");
  }

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PMS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
          primary: ColorRes.appBlueColor,
          secondary: ColorRes.appBlueColor,
        ),
        fontFamily: AssetRes.roboto,
        useMaterial3: true,
      ),
      navigatorKey: navigationKey,
      locale: const Locale('en', 'US'),
      translations: AppLocalization(),
      fallbackLocale: const Locale('en', 'US'),

      // 👇 Directly assign the screen to show first
      home: kIsWeb ?  LoginScreen() : const SplashScreen(),

      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
    );
  }
}

final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();
