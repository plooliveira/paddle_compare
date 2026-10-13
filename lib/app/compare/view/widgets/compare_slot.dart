import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/skeleton_pulse.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../controller/compare_controller.dart';
import 'compare_slot_header.dart';
import 'compare_slot_message.dart';
import 'compare_slot_skeleton.dart';
import 'empty_compare_slot.dart';

/// The top of a column: the paddle, or what stands in for it while it loads,
/// fails or isn't found. An empty column offers to pick a paddle.
class CompareSlot extends ConsumerWidget {
  const CompareSlot({
    super.key,
    required this.id,
    required this.slot,
    this.imageMaxHeight = double.infinity,
  });

  /// Null for an empty column.
  final String? id;

  /// Null for an empty column.
  final AsyncValue<Paddle?>? slot;

  final double imageMaxHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) => switch (slot) {
    // Closes the comparison, so the paddle is picked from the catalog.
    null => EmptyCompareSlot(
      onSelect: () => context.pop(),
      imageMaxHeight: imageMaxHeight,
    ),
    AsyncValue(isLoading: true) => SkeletonPulse(
      child: CompareSlotSkeleton(imageMaxHeight: imageMaxHeight),
    ),
    AsyncValue(hasError: true) => CompareSlotMessage(
      icon: Icons.cloud_off_outlined,
      title: "Couldn't load this paddle",
      imageMaxHeight: imageMaxHeight,
      action: TextButton(
        onPressed: ref
            .read(comparePaddleControllerProvider(id!).notifier)
            .retry,
        child: const Text('Try again'),
      ),
    ),
    AsyncValue(value: final paddle?) => CompareSlotHeader(
      paddle: paddle,
      imageMaxHeight: imageMaxHeight,
    ),
    _ => CompareSlotMessage(
      icon: Icons.search_off,
      title: 'Paddle not found',
      imageMaxHeight: imageMaxHeight,
    ),
  };
}
