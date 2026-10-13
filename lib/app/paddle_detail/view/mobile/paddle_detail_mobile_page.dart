import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/utils/form_factor.dart';
import '../../../../core/widgets/fading_back_button.dart';
import '../../../../core/widgets/state_message.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../compare/controller/compare_controller.dart';
import '../../../compare/controller/compare_limits.dart';
import '../../../router.dart';
import '../../controller/paddle_detail_controller.dart';
import '../widgets/full_specs_accordion.dart';
import '../widgets/key_specs_grid.dart';
import '../widgets/paddle_detail_header.dart';
import '../widgets/paddle_detail_image.dart';
import '../widgets/paddle_detail_skeleton.dart';
import '../widgets/performance_ratings.dart';
import 'widgets/compare_bar.dart';

class PaddleDetailMobilePage extends ConsumerWidget {
  const PaddleDetailMobilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(paddleDetailControllerProvider);
    final compareIds = ref.watch(compareIdsProvider);
    // This page stands in for the desktop variant too.
    final compareLimit = CompareLimits.of(FormFactor.of(context));

    CompareBar compareBarFor(Paddle paddle) {
      if (compareIds.contains(paddle.id)) {
        return const CompareBar(
          onCompare: null,
          label: 'Added to compare',
          icon: Icons.check,
        );
      }
      if (compareIds.length >= compareLimit) {
        return const CompareBar(onCompare: null, label: 'Compare is full');
      }
      return CompareBar(
        onCompare: () =>
            CatalogRoute.of(context)
                .addToCompare(context, paddle.id, limit: compareLimit),
      );
    }

    final (body, compareBar) = switch (detail) {
      AsyncValue(isLoading: true) => (
        const PaddleDetailSkeleton(),
        const CompareBar(onCompare: null),
      ),
      AsyncValue(hasError: true) => (
        _Message(
          StateMessage(
            icon: Icons.cloud_off_outlined,
            title: 'Something went wrong',
            message: 'Check your connection and try again.',
            action: FilledButton(
              onPressed: ref
                  .read(paddleDetailControllerProvider.notifier)
                  .retry,
              child: const Text('Try again'),
            ),
          ),
        ),
        null,
      ),
      AsyncValue(value: final paddle?) => (
        _Details(paddle: paddle),
        compareBarFor(paddle),
      ),
      _ => (
        _Message(
          StateMessage(
            icon: Icons.search_off,
            title: 'Paddle not found',
            message:
                'It may have been removed, or the link may be wrong. '
                'Browse the collection to find another one.',
            action: OutlinedButton(
              onPressed: () => const CatalogRoute().go(context),
              child: const Text('Browse paddles'),
            ),
          ),
        ),
        null,
      ),
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
          const Padding(padding: gutter, child: _SectionTitle('Key specs')),
          const SizedBox(height: 12),
          Padding(
            padding: gutter,
            child: KeySpecsGrid(paddle: paddle),
          ),
          const SizedBox(height: 32),
          const Padding(padding: gutter, child: _SectionTitle('Performance')),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      header: true,
      child: Text(
        title.toUpperCase(),
        semanticsLabel: title,
        style: Theme.of(context).textTheme.labelSmall,
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(this.message);

  final StateMessage message;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [SliverFillRemaining(hasScrollBody: false, child: message)],
    );
  }
}
