import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/core/utils/spec_format.dart';

void main() {
  test('formatOunces always shows one decimal', () {
    expect(formatOunces(8), '8.0 oz');
    expect(formatOunces(7.83), '7.8 oz');
  });

  test('formatOuncesAsGrams rounds to whole grams', () {
    expect(formatOuncesAsGrams(8), '227 g');
    expect(formatOuncesAsGrams(222 / 28.349523125), '222 g');
  });

  test('formatDecimal drops trailing zeros, up to three decimals', () {
    expect(formatDecimal(116), '116');
    expect(formatDecimal(100), '100');
    expect(formatDecimal(6.4), '6.4');
    expect(formatDecimal(4.25), '4.25');
    expect(formatDecimal(15.875), '15.875');
  });

  test('formatMillimeters and formatInches add the unit', () {
    expect(formatMillimeters(16), '16 mm');
    expect(formatMillimeters(14.5), '14.5 mm');
    expect(formatInches(16.5), '16.5 in');
  });

  test('capitalize uppercases only the first letter', () {
    expect(capitalize('raw carbon'), 'Raw carbon');
    expect(capitalize(''), '');
  });
}
