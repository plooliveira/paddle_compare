import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../controller/compare_controller.dart';
import '../../controller/compare_limits.dart';
import '../widgets/compare_section.dart';
import '../widgets/compare_slot.dart';
import '../widgets/compare_spec_row.dart';
import '../widgets/compare_specs.dart';

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
                          const SizedBox(width: CompareSpecRow.defaultGap),
                        Expanded(
                          child: CompareSlot(
                            id: ids.elementAtOrNull(index),
                            slot: slot,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 32),
                  CompareSection(
                    title: 'Key specs',
                    rows: [
                      for (final spec in CompareSpecs.key)
                        CompareSpecRow.text(spec: spec, slots: slots),
                    ],
                  ),
                  const SizedBox(height: 28),
                  CompareSection(
                    title: 'Performance',
                    rows: [
                      for (final spec in CompareSpecs.performance)
                        CompareSpecRow.rating(spec: spec, slots: slots),
                    ],
                  ),
                  const SizedBox(height: 28),
                  CompareSection(
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
