import 'package:flutter/widgets.dart';

import '../utils/form_factor.dart';

class AdaptiveView extends StatelessWidget {
  const AdaptiveView({super.key, required this.mobile, required this.desktop});

  final WidgetBuilder mobile;
  final WidgetBuilder desktop;

  @override
  Widget build(BuildContext context) => switch (FormFactor.of(context)) {
    FormFactor.mobile => mobile(context),
    FormFactor.desktop => desktop(context),
  };
}
