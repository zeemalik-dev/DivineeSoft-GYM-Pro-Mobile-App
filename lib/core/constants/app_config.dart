
class AppConfig {
  AppConfig._();

  static const String appName =
      'DivineeSoft GYM Pro';

  static const String companyName =
      'DivineeSoft Technologies Pvt. Ltd.';

  static const String startUrl =
      'https://gym.divineesoft.com/';

  static const String trustedHost =
      'gym.divineesoft.com';

  static const Set<String> trustedWebViewHosts = {
    trustedHost,
  };

  static const Duration connectivityTimeout =
      Duration(seconds: 7);

  static const Duration pageLoadTimeout =
      Duration(seconds: 35);
}
