import 'package:cupertino_ui/cupertino_ui.dart'
    show CupertinoPageTransitionsBuilder;
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';

import 'app_colors.dart';

/// Editorial look: Playfair Display for display and title text, Inter for
/// everything else, ink on warm off-white, hairline borders, no shadows.
abstract final class AppTheme {
  static const serif = 'PlayfairDisplay';
  static const sans = 'Inter';

  static const _radius = BorderRadius.all(Radius.circular(4));

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.ink,
      onPrimary: AppColors.surface,
      primaryContainer: AppColors.surfaceMuted,
      onPrimaryContainer: AppColors.ink,
      secondary: AppColors.ink,
      onSecondary: AppColors.surface,
      secondaryContainer: AppColors.surfaceMuted,
      onSecondaryContainer: AppColors.ink,
      error: AppColors.error,
      onError: AppColors.surface,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      onSurfaceVariant: AppColors.inkMuted,
      surfaceContainerLowest: AppColors.surface,
      surfaceContainerLow: AppColors.surface,
      surfaceContainer: AppColors.canvas,
      surfaceContainerHigh: AppColors.surfaceMuted,
      surfaceContainerHighest: AppColors.surfaceMuted,
      outline: AppColors.ink,
      outlineVariant: AppColors.hairline,
      surfaceTint: Color(0x00000000),
    );
    final textTheme = _textTheme();

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: sans,
      textTheme: textTheme,
      scaffoldBackgroundColor: AppColors.canvas,
      splashFactory: InkRipple.splashFactory,
      pageTransitionsTheme: _pageTransitionsTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        surfaceTintColor: const Color(0x00000000),
        titleTextStyle: textTheme.titleMedium,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.hairline,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        hintStyle: textTheme.bodyLarge?.copyWith(color: AppColors.inkMuted),
        prefixIconColor: AppColors.ink,
        suffixIconColor: AppColors.inkMuted,
        border: const OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide(color: AppColors.hairline),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide(color: AppColors.hairline),
        ),
        disabledBorder: const OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide(color: AppColors.hairline),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide(color: AppColors.ink, width: 1.2),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.surface,
          disabledBackgroundColor: AppColors.hairline,
          disabledForegroundColor: AppColors.inkMuted,
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: const RoundedRectangleBorder(borderRadius: _radius),
          textStyle: textTheme.labelLarge,
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style:
            OutlinedButton.styleFrom(
              foregroundColor: AppColors.ink,
              disabledForegroundColor: AppColors.inkMuted,
              minimumSize: const Size(64, 44),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              shape: const RoundedRectangleBorder(borderRadius: _radius),
              textStyle: textTheme.labelLarge,
              tapTargetSize: MaterialTapTargetSize.padded,
            ).copyWith(
              side: WidgetStateBorderSide.resolveWith(
                (states) => BorderSide(
                  color: states.contains(WidgetState.disabled)
                      ? AppColors.hairline
                      : AppColors.ink,
                ),
              ),
            ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.ink,
          minimumSize: const Size(48, 48),
          shape: const RoundedRectangleBorder(borderRadius: _radius),
          textStyle: textTheme.labelLarge,
        ),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        tilePadding: EdgeInsets.symmetric(horizontal: 16),
        childrenPadding: EdgeInsets.fromLTRB(16, 0, 16, 12),
        iconColor: AppColors.ink,
        collapsedIconColor: AppColors.ink,
        textColor: AppColors.ink,
        collapsedTextColor: AppColors.ink,
        shape: Border(),
        collapsedShape: Border(),
      ),
      chipTheme: ChipThemeData(
        color: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.ink
              : AppColors.surface,
        ),
        side: WidgetStateBorderSide.resolveWith(
          (states) => BorderSide(
            color: states.contains(WidgetState.selected)
                ? AppColors.ink
                : AppColors.hairline,
          ),
        ),
        labelStyle: textTheme.labelLarge?.copyWith(
          color: WidgetStateColor.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.surface
                : AppColors.ink,
          ),
        ),
        iconTheme: const IconThemeData(color: AppColors.ink, size: 16),
        deleteIconColor: AppColors.inkMuted,
        checkmarkColor: AppColors.surface,
        showCheckmark: false,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surface,
        modalBackgroundColor: AppColors.surface,
        surfaceTintColor: Color(0x00000000),
        modalBarrierColor: Color(0x66141414),
        showDragHandle: true,
        dragHandleColor: AppColors.hairline,
        dragHandleSize: Size(36, 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
      ),
      sliderTheme: const SliderThemeData(
        activeTrackColor: AppColors.ink,
        inactiveTrackColor: AppColors.hairline,
        thumbColor: AppColors.ink,
        overlayColor: Color(0x14141414),
        valueIndicatorColor: AppColors.ink,
        activeTickMarkColor: Color(0x00000000),
        inactiveTickMarkColor: Color(0x00000000),
        trackHeight: 2,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.surface
              : AppColors.inkMuted,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.ink
              : AppColors.surfaceMuted,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.ink
              : AppColors.hairline,
        ),
      ),
      badgeTheme: BadgeThemeData(
        backgroundColor: AppColors.ink,
        textColor: AppColors.surface,
        textStyle: textTheme.labelSmall?.copyWith(letterSpacing: 0),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.ink,
        linearTrackColor: AppColors.hairline,
        circularTrackColor: Color(0x00000000),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.ink,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.surface,
        ),
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(borderRadius: _radius),
      ),
    );
  }

  /// Pages slide in from the right on phones, with the swipe-back gesture
  /// (the system back still works on Android, without the predictive-back
  /// preview). On the web the browser owns navigation and its own back
  /// gesture, so every platform fades. Windows and Linux keep the default.
  static final _pageTransitionsTheme = PageTransitionsTheme(
    builders: kIsWeb
        ? {
            for (final platform in TargetPlatform.values)
              platform: const _FadePageTransitionsBuilder(),
          }
        : const {
            TargetPlatform.android: CupertinoPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
            TargetPlatform.windows: ZoomPageTransitionsBuilder(),
            TargetPlatform.linux: ZoomPageTransitionsBuilder(),
          },
  );

  static TextTheme _textTheme() {
    const serifStyle = TextStyle(fontFamily: serif, color: AppColors.ink);
    const sansStyle = TextStyle(fontFamily: sans, color: AppColors.ink);
    return TextTheme(
      displaySmall: serifStyle.copyWith(
        fontSize: 36,
        height: 1.1,
        letterSpacing: -0.5,
      ),
      headlineMedium: serifStyle.copyWith(fontSize: 28, height: 1.15),
      headlineSmall: serifStyle.copyWith(fontSize: 24, height: 1.2),
      titleLarge: serifStyle.copyWith(fontSize: 20, height: 1.25),
      titleMedium: serifStyle.copyWith(fontSize: 16, height: 1.25),
      titleSmall: sansStyle.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
      bodyLarge: sansStyle.copyWith(fontSize: 16, height: 1.4),
      bodyMedium: sansStyle.copyWith(fontSize: 14, height: 1.45),
      bodySmall: sansStyle.copyWith(
        fontSize: 12,
        height: 1.4,
        color: AppColors.inkMuted,
      ),
      labelLarge: sansStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
      labelMedium: sansStyle.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.3,
      ),
      // Overlines: brand names, section labels.
      labelSmall: sansStyle.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.4,
        color: AppColors.inkMuted,
      ),
    );
  }
}

/// A short cross-fade, like a page load in the browser.
class _FadePageTransitionsBuilder extends PageTransitionsBuilder {
  const _FadePageTransitionsBuilder();

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => FadeTransition(
    opacity: CurveTween(curve: Curves.easeOut).animate(animation),
    child: child,
  );
}
