import '../../../core/utils/form_factor.dart';

abstract final class CompareLimits {
  static const mobile = 2;
  static const desktop = 3;
  static const max = desktop;

  static int of(FormFactor formFactor) => switch (formFactor) {
    FormFactor.mobile => mobile,
    FormFactor.desktop => desktop,
  };
}
