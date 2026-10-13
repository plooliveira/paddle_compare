import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/fading_back_button.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../compare/controller/compare_controller.dart';
import '../../../compare/controller/compare_limits.dart';
import '../../../router.dart';
import '../../controller/paddle_detail_controller.dart';
import '../widgets/detail_section_title.dart';
import '../widgets/full_specs_accordion.dart';
import '../widgets/key_specs_grid.dart';
import '../widgets/paddle_detail_error.dart';
import '../widgets/paddle_detail_header.dart';
import '../widgets/paddle_detail_image.dart';
import '../widgets/paddle_detail_not_found.dart';
import '../widgets/performance_ratings.dart';
import 'widgets/compare_bar.dart';
import 'widgets/paddle_detail_skeleton.dart';

class PaddleDetailMobilePage extends ConsumerWidget {
  const PaddleDetailMobilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(paddleDetailControllerProvider);
    final compareIds = ref.watch(compareIdsProvider);

    CompareBar compareBarFor(Paddle paddle) {
      if (compareIds.contains(paddle.id)) {
        return const CompareBar(
          onCompare: null,
          label: 'Added to compare',
          icon: Icons.check,
        );
      }
      if (compareIds.length >= CompareLimits.mobile) {
        return const CompareBar(onCompare: null, label: 'Compare is full');
      }
      return CompareBar(
        onCompare: () =>
            CatalogRoute.of(context)
                .addToCompare(context, paddle.id, limit: CompareLimits.mobile),
      );
    }

    final (body, compareBar) = switch (detail) {
      AsyncValue(isLoading: true) => (
        const PaddleDetailSkeleton(),
        const CompareBar(onCompare: null),
      ),
      AsyncValue(hasError: true) => (const PaddleDetailError(), null),
      AsyncValue(value: final paddle?) => (
        _Details(paddle: paddle),
        compareBarFor(paddle),
      ),
      _ => (const PaddleDetailNotFound(), null),
    };

    return Scaffold(
      appBar: AppBar(leading: const FadingBackButton()),
      body: body,
      bottomNavigationBar: compareBar,
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.paddle});

  final Paddle paddle;

  @override
  Widget build(BuildContext context) {
    const gutter = EdgeInsets.symmetric(horizontal: 16);
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 8, bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: gutter,
            child: PaddleDetailImage(imagePath: paddle.imagePath),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: gutter,
            child: PaddleDetailHeader(paddle: paddle),
          ),
          const SizedBox(height: 24),
          const Divider(indent: 16, endIndent: 16),
          const SizedBox(height: 24),
          const Padding(
            padding: gutter,
            child: DetailSectionTitle('Key specs'),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: gutter,
            child: KeySpecsGrid(paddle: paddle),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: gutter,
            child: DetailSectionTitle('Performance'),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: gutter,
            child: PerformanceRatings(ratings: paddle.ratings),
          ),
          const SizedBox(height: 28),
          FullSpecsAccordion(paddle: paddle),
        ],
      ),
    );
  }
}
