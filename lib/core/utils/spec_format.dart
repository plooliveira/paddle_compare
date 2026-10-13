import 'units.dart';

String formatOunces(double ounces) => '${ounces.toStringAsFixed(1)} oz';

String formatOuncesAsGrams(double ounces) =>
    '${(ounces * gramsPerOunce).round()} g';

String formatMillimeters(double millimeters) =>
    '${formatDecimal(millimeters)} mm';

String formatInches(double inches) => '${formatDecimal(inches)} in';

String formatDecimal(double value) => value
    .toStringAsFixed(3)
    .replaceFirst(RegExp(r'0+$'), '')
    .replaceFirst(RegExp(r'\.$'), '');

String capitalize(String text) =>
    text.isEmpty ? text : text[0].toUpperCase() + text.substring(1);
