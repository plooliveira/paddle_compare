import 'dart:math' as math;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/fading_back_button.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../core/widgets/skeleton_pulse.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../compare/controller/compare_controller.dart';
import '../../../compare/controller/compare_limits.dart';
import '../../../compare/view/widgets/compare_tray.dart';
import '../../controller/paddle_detail_controller.dart';
import '../widgets/detail_section_title.dart';
import '../widgets/full_specs_list.dart';
import '../widgets/key_specs_grid.dart';
import '../widgets/paddle_detail_error.dart';
import '../widgets/paddle_detail_header.dart';
import '../widgets/paddle_detail_image.dart';
import '../widgets/paddle_detail_not_found.dart';
import '../widgets/performance_ratings.dart';
import 'widgets/compare_action.dart';
import 'widgets/paddle_detail_desktop_skeleton.dart';

/// The image stays put beside a content column that scrolls on its own, and
/// the compare tray sits at the bottom, as in the catalog.
class PaddleDetailDesktopPage extends ConsumerWidget {
  const PaddleDetailDesktopPage({super.key});

  // The catalog's, so the two pages line up.
  static const _gutter = 24.0;
  static const _maxContentWidth = 1200.0;
  static const _compactWidth = 1024.0;

  /// The illustrations are 600×800.
  static const _imageAspectRatio = 3 / 4;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(paddleDetailControllerProvider);
    final isComparing = ref.watch(
      compareIdsProvider.select((ids) => ids.isNotEmpty),
    );

    final width = MediaQuery.sizeOf(context).width;
    final isCompact = width < _compactWidth;
    final margin = math.max(_gutter, (width - _maxContentWidth) / 2);
    final keySpecColumns = isCompact ? 2 : 4;

    _Columns columns({required Widget image, required Widget content}) =>
        _Columns(
          margin: margin,
          isCompact: isCompact,
          image: image,
          content: content,
        );

    final body = switch (detail) {
      AsyncValue(isLoading: true) => columns(
        image: const ExcludeSemantics(
          child: SkeletonPulse(
            child: AspectRatio(
              aspectRatio: _imageAspectRatio,
              child: SkeletonBox(),
            ),
          ),
        ),
        content: PaddleDetailDesktopSkeleton(keySpecColumns: keySpecColumns),
      ),
      AsyncValue(hasError: true) => const PaddleDetailError(),
      AsyncValue(value: final paddle?) => columns(
        image: PaddleDetailImage(
          imagePath: paddle.imagePath,
          aspectRatio: _imageAspectRatio,
          maxHeight: double.infinity,
        ),
        content: _Details(paddle: paddle, keySpecColumns: keySpecColumns),
      ),
      _ => const PaddleDetailNotFound(),
    };

    return Scaffold(
      // In every state, so the comparison is always in sight.
      bottomNavigationBar: isComparing
          ? CompareTray(
              slots: CompareLimits.desktop,
              padding: EdgeInsets.fromLTRB(margin, 12, margin, 12),
            )
          : null,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _TopBar(margin: margin),
            Expanded(child: body),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.margin});

  /// Lines the arrow up with the margin rather than the button's edge.
  static const _backButtonInset = 8.0;

  final double margin;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(
            margin - _backButtonInset,
            12,
            margin,
            12,
          ),
          child: Row(
            children: [
              const FadingBackButton(),
              const SizedBox(width: 4),
              Text('Paddles', style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}

/// Only [content] scrolls. Its scroll view reaches the window's edge, so the
/// scrollbar sits there, as in the catalog's grid. [image] is fitted into
/// the fixed column, and shrinks in a short window.
class _Columns extends StatelessWidget {
  const _Columns({
    required this.margin,
    required this.isCompact,
    required this.image,
    required this.content,
  });

  final double margin;
  final bool isCompact;
  final Widget image;
  final Widget content;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(
            start: margin,
            top: 32,
            bottom: 24,
          ),
          child: SizedBox(
            width: isCompact ? 320 : 440,
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: image,
            ),
          ),
        ),
        SizedBox(width: isCompact ? 32 : 64),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsetsDirectional.fromSTEB(0, 32, margin, 48),
            child: content,
          ),
        ),
      ],
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.paddle, required this.keySpecColumns});

  final Paddle paddle;
  final int keySpecColumns;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PaddleDetailHeader(paddle: paddle),
        const SizedBox(height: 24),
        CompareAction(paddleId: paddle.id),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 32),
        const DetailSectionTitle('Key specs'),
        const SizedBox(height: 12),
        KeySpecsGrid(paddle: paddle, columns: keySpecColumns),
        const SizedBox(height: 32),
        const DetailSectionTitle('Performance'),
        const SizedBox(height: 8),
        PerformanceRatings(ratings: paddle.ratings),
        const SizedBox(height: 32),
        // Open: there's room, and a click would only hide data.
        const DetailSectionTitle('Full specifications'),
        const SizedBox(height: 4),
        FullSpecsList(paddle: paddle),
      ],
    );
  }
}
