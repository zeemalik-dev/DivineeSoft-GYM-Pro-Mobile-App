


import 'package:divineesoft_gym_pro_app/core/constants/app_config.dart';

enum UrlAction {
  internal,
  external,
  block,
}

class UrlPolicy {
  UrlPolicy._();

  static UrlAction classify(Uri uri) {
    final host = uri.host.toLowerCase();

    if (uri.scheme == 'https' &&
        AppConfig.trustedWebViewHosts.contains(host)) {
      return UrlAction.internal;
    }

    if (uri.scheme == 'http') {
      return UrlAction.block;
    }

    if (uri.scheme == 'https' ||
        uri.scheme == 'mailto' ||
        uri.scheme == 'tel' ||
        uri.scheme == 'sms' ||
        uri.scheme == 'whatsapp') {
      return UrlAction.external;
    }

    return UrlAction.block;
  }
}
