import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/skeleton_pulse.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../controller/compare_controller.dart';
import '../../controller/compare_limits.dart';
import '../widgets/compare_specs.dart';
import 'widgets/compare_slot_header.dart';
import 'widgets/compare_slot_message.dart';
import 'widgets/compare_slot_skeleton.dart';
import 'widgets/compare_spec_row.dart';
import 'widgets/empty_compare_slot.dart';

class CompareMobilePage extends ConsumerWidget {
  const CompareMobilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ids = ref
        .watch(compareIdsProvider)
        .take(CompareLimits.mobile)
        .toList();
    final slots = <AsyncValue<Paddle?>?>[
      for (final id in ids) ref.watch(comparePaddleControllerProvider(id)),
      for (var i = ids.length; i < CompareLimits.mobile; i++) null,
    ];

    Widget header(String? id, AsyncValue<Paddle?>? slot) => switch (slot) {
      // Closes the sheet, so the paddle is picked from the catalog.
      null => EmptyCompareSlot(onSelect: () => context.pop()),
      AsyncValue(isLoading: true) => const SkeletonPulse(
        child: CompareSlotSkeleton(),
      ),
      AsyncValue(hasError: true) => CompareSlotMessage(
        icon: Icons.cloud_off_outlined,
        title: "Couldn't load this paddle",
        action: TextButton(
          onPressed: ref
              .read(comparePaddleControllerProvider(id!).notifier)
              .retry,
          child: const Text('Try again'),
        ),
      ),
      AsyncValue(value: final paddle?) => CompareSlotHeader(paddle: paddle),
      _ => const CompareSlotMessage(
        icon: Icons.search_off,
        title: 'Paddle not found',
      ),
    };

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Semantics(
                    header: true,
                    child: Text(
                      'Compare',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => context.pop(),
                  tooltip: 'Close',
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final (index, slot) in slots.indexed) ...[
                        if (index > 0)
                          const SizedBox(width: CompareSpecRow.columnGap),
                        Expanded(
                          child: header(ids.elementAtOrNull(index), slot),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),
                  _Section(
                    title: 'Key specs',
                    rows: [
                      for (final spec in CompareSpecs.key)
                        CompareSpecRow.text(spec: spec, slots: slots),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _Section(
                    title: 'Performance',
                    rows: [
                      for (final spec in CompareSpecs.performance)
                        CompareSpecRow.rating(spec: spec, slots: slots),
                    ],
                  ),
                  const SizedBox(height: 28),
                  _Section(
                    title: 'Full specifications',
                    rows: [
                      for (final spec in CompareSpecs.full)
                        CompareSpecRow.text(spec: spec, slots: slots),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.rows});

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Semantics(
          header: true,
          child: Text(title, style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(height: 4),
        for (final (index, row) in rows.indexed) ...[
          if (index > 0) const Divider(),
          row,
        ],
      ],
    );
  }
}
