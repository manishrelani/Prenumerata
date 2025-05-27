import 'dart:developer' as dev;

import 'package:flutter/foundation.dart';

extension DevLog on Object? {
  void get showLog {
    if (kDebugMode) dev.log(toString());
  }
}
