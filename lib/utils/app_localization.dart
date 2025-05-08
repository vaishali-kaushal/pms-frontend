import 'package:get/get_navigation/src/root/internacionalization.dart';

class AppLocalization extends Translations {
  @override
  Map<String, Map<String, String>> get keys {
    return {
      'en_US': enUs,
    };
  }

  Map<String, String> enUs = {
    "email": "Email",
    "enter_email": "Enter your email",
    "password": "Password",
    "please_enter_email": "Please enter Email",
    "please_enter_password": "Please enter your password",
    "password_too_short": "Password must be at least 6 characters"



  };
}
