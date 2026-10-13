import 'units.dart';

/// `8.0 oz`. Always one decimal, the precision weights are listed with.
String formatOunces(double ounces) => '${ounces.toStringAsFixed(1)} oz';

/// [ounces] in grams, rounded: `227 g`.
String formatOuncesAsGrams(double ounces) =>
    '${(ounces * gramsPerOunce).round()} g';

/// `16 mm`, `14.5 mm`.
String formatMillimeters(double millimeters) =>
    '${formatDecimal(millimeters)} mm';

/// `16.5 in`, `15.875 in`.
String formatInches(double inches) => '${formatDecimal(inches)} in';

/// Up to three decimals, without trailing zeros: `116`, `6.4`, `15.875`.
String formatDecimal(double value) => value
    .toStringAsFixed(3)
    .replaceFirst(RegExp(r'0+$'), '')
    .replaceFirst(RegExp(r'\.$'), '');

/// `raw carbon` → `Raw carbon`.
String capitalize(String text) =>
    text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
