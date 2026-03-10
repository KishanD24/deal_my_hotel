import 'package:flutter/material.dart';
import 'package:mighty_properties/main.dart';
import '../extensions/common.dart';

DateTime? _currentBackPressTime;

/// DoublePressBackWidget
class DoublePressBackWidget extends StatelessWidget {
  final Widget child;
  final String? message;
  final WillPopCallback? onWillPop;

  DoublePressBackWidget({
    Key? key,
    required this.child,
    this.message,
    this.onWillPop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: child,
      onWillPop: () {
        DateTime now = DateTime.now();

        onWillPop?.call();
        if (_currentBackPressTime == null || now.difference(_currentBackPressTime!) > Duration(seconds: 2)) {
          _currentBackPressTime = now;
          toast(message ?? language.pressBackAgainToExit);

          return Future.value(false);
        }
        return Future.value(true);
      },
    );
  }
}
