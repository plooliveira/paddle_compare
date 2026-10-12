/// Formats [usd] as `$1,249.99`. Always two decimals, so prices line up.
String formatUsd(double usd) {
  final fixed = usd.abs().toStringAsFixed(2);
  final dot = fixed.indexOf('.');
  final whole = fixed.substring(0, dot);
  final grouped = whole.replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '${usd < 0 ? '-' : ''}\$$grouped${fixed.substring(dot)}';
}
