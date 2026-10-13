import '../../../../core/utils/spec_format.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../shared/paddle_labels.dart';

/// A row of the comparison: its label and how a paddle shows it, or null
/// when the paddle doesn't list it.
typedef CompareSpec = ({String label, String? Function(Paddle) value});

/// A rating row: its label and the paddle's rating, out of
/// [CompareSpecs.maxRating].
typedef CompareRating = ({String label, int? Function(Paddle) rating});

/// The comparison's sections, in the same order as the detail page.
abstract final class CompareSpecs {
  static const maxRating = 10;

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
