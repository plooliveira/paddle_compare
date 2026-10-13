import '../../../../core/utils/spec_format.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../shared/paddle_labels.dart';

typedef CompareSpec = ({String label, String? Function(Paddle) value});

typedef CompareRating = ({String label, int? Function(Paddle) rating});

abstract final class CompareSpecs {
  static const maxRating = 10;

  /// Two or more known values that aren't all the same. Missing ones are
  /// skipped: a spec that isn't listed isn't a known difference.
  static bool differ(Iterable<Object?> values) =>
      values.nonNulls.toSet().length > 1;

  static final List<CompareSpec> key = [
    (label: 'Shape', value: (paddle) => paddle.shape?.label),
    (
      label: 'Weight',
      value: (paddle) => switch (paddle.weightOz) {
        final weight? =>
          '${formatOunces(weight)} · ${formatOuncesAsGrams(weight)}',
        null => null,
      },
    ),
    (
      label: 'Core',
      value: (paddle) => _format(paddle.coreThicknessMm, formatMillimeters),
    ),
    (
      label: 'Face',
      value: (paddle) => _format(paddle.faceMaterial, capitalize),
    ),
  ];

  static final List<CompareRating> performance = [
    (label: 'Power', rating: (paddle) => paddle.ratings.power),
    (label: 'Control', rating: (paddle) => paddle.ratings.control),
    (label: 'Spin', rating: (paddle) => paddle.ratings.spin),
    (label: 'Pop', rating: (paddle) => paddle.ratings.pop),
  ];

  static final List<CompareSpec> full = [
    (
      label: 'Length',
      value: (paddle) => _format(paddle.dimensions.lengthIn, formatInches),
    ),
    (
      label: 'Width',
      value: (paddle) => _format(paddle.dimensions.widthIn, formatInches),
    ),
    (
      label: 'Handle length',
      value: (paddle) =>
          _format(paddle.dimensions.handleLengthIn, formatInches),
    ),
    (
      label: 'Grip circumference',
      value: (paddle) => _format(paddle.gripCircumferenceIn, formatInches),
    ),
    (
      label: 'Swing weight',
      value: (paddle) => _format(paddle.swingWeight, formatDecimal),
    ),
    (
      label: 'Twist weight',
      value: (paddle) => _format(paddle.twistWeight, formatDecimal),
    ),
    (label: 'Release year', value: (paddle) => paddle.releaseYear?.toString()),
  ];
}

String? _format<T extends Object>(T? value, String Function(T) format) =>
    value != null ? format(value) : null;
