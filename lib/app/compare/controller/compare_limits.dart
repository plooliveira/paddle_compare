import '../../../core/utils/form_factor.dart';

/// How many paddles are compared side by side. The compare URL holds up to
/// [max] ids, and each layout shows as many as it fits.
abstract final class CompareLimits {
  static const mobile = 2;
  static const desktop = 3;
  static const max = desktop;

  static int of(FormFactor formFactor) => switch (formFactor) {
    FormFactor.mobile => mobile,
    FormFactor.desktop => desktop,
  };
}
