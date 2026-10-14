import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/config/screen_config.dart';
import 'package:paddle_compare/core/widgets/top_bar.dart';

import '../../../../core/widgets/fading_back_button.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../controller/compare_controller.dart';
import '../../controller/compare_limits.dart';
import '../widgets/compare_section.dart';
import '../widgets/compare_slot.dart';
import '../widgets/compare_spec_row.dart';
import '../widgets/compare_specs.dart';

/// A page of its own, laid out as a table: the labels in a column on the
/// left, then one column per paddle. Only the table scrolls, under a fixed
/// top bar, as on the detail page.
class CompareDesktopPage extends ConsumerWidget {
  const CompareDesktopPage({super.key});

  static const _gap = 24.0;

  /// The images take at most this share of the window's height, so the
  /// first specs are in sight under them, even in a short window.
  static const _imageMaxHeightFraction = 0.3;
  static const _imageMaxHeight = 260.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref
        .watch(compareIdsProvider)
        .take(CompareLimits.desktop)
        .toList();
    final slots = <AsyncValue<Paddle?>?>[
      for (final id in ids) ref.watch(comparePaddleControllerProvider(id)),
      for (var i = ids.length; i < CompareLimits.desktop; i++) null,
    ];

    final Size(:width, :height) = MediaQuery.sizeOf(context);
    final margin = math.max(
      ScreenConfig.gutter,
      (width - ScreenConfig.maxContentWidth) / 2,
    );
    final labelWidth = width < ScreenConfig.compactWidth ? 160.0 : 200.0;
    final imageMaxHeight = math.min(
      _imageMaxHeight,
      height * _imageMaxHeightFraction,
    );

    CompareSpecRow text(CompareSpec spec) => CompareSpecRow.text(
      spec: spec,
      slots: slots,
      labelWidth: labelWidth,
      gap: _gap,
    );

    CompareSpecRow rating(CompareRating spec) => CompareSpecRow.rating(
      spec: spec,
      slots: slots,
      labelWidth: labelWidth,
      gap: _gap,
    );

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TopBar(margin: margin),
            Expanded(
              // Reaches the window's edge, so the scrollbar sits there, as in
              // the catalog's grid.
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(margin, 32, margin, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: labelWidth,
                          child: Semantics(
                            header: true,
                            child: Text(
                              'Compare',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                          ),
                        ),
                        for (final (index, slot) in slots.indexed) ...[
                          if (index > 0) const SizedBox(width: _gap),
                          Expanded(
                            child: CompareSlot(
                              id: ids.elementAtOrNull(index),
                              slot: slot,
                              imageMaxHeight: imageMaxHeight,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 40),
                    CompareSection(
                      title: 'Key specs',
                      rows: [for (final spec in CompareSpecs.key) text(spec)],
                    ),
                    const SizedBox(height: 32),
                    CompareSection(
                      title: 'Performance',
                      rows: [
                        for (final spec in CompareSpecs.performance)
                          rating(spec),
                      ],
                    ),
                    const SizedBox(height: 32),
                    CompareSection(
                      title: 'Full specifications',
                      rows: [for (final spec in CompareSpecs.full) text(spec)],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
