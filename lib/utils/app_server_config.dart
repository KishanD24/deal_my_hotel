
import 'package:flutter/foundation.dart';

class AppServerConfig {
  static String get baseUrl {
    if (kReleaseMode) {
      return 'https://dealmyhotel.com';
    } else if (kProfileMode) {
      return 'https://dealmyhotel.com';
    } else {
      return 'https://dealmyhotel.com';
    }
  }
}