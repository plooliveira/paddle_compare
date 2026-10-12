import 'package:flutter/widgets.dart';

enum FormFactor {
  mobile,
  desktop;

  static const desktopMinWidth = 840.0;

  static FormFactor of(BuildContext context) =>
      MediaQuery.sizeOf(context).width >= desktopMinWidth ? desktop : mobile;
}
