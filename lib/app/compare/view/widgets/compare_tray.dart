import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../../core/widgets/paddle_image.dart';
import '../../../../core/widgets/skeleton_box.dart';
import '../../../../core/widgets/skeleton_pulse.dart';
import '../../../../data/repositories/paddle/paddle_repository.dart';
import '../../../router.dart';
import '../../controller/compare_controller.dart';

/// Shown at the bottom of the catalog and of the desktop detail page. It
/// reads the catalog route from its page's URL, so a removal updates that
/// page in place.
///
/// Watching each paddle here is what loads it. The catalog stays mounted
/// under a paddle's page, so a paddle added there starts loading while that
/// page leaves.
class CompareTray extends ConsumerWidget {
  const CompareTray({
    super.key,
    required this.slots,
    this.padding = const EdgeInsets.fromLTRB(16, 10, 8, 10),
  });

  final int slots;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final ids = ref.watch(compareIdsProvider).take(slots).toList();

    void remove(String id) {
      final route = CatalogRoute.of(context);
      route
          .withCompare([
            for (final other in route.compareIds)
              if (other != id) other,
          ])
          .replaceOnPage(context);
    }

    return Material(
      color: theme.scaffoldBackgroundColor,
      shape: Border(top: BorderSide(color: colors.outlineVariant)),
      child: Semantics(
        container: true,
        button: true,
        label: 'Open comparison',
        child: InkWell(
          onTap: () => CatalogRoute.of(context).goCompare(context),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: padding,
              child: Row(
                children: [
                  for (var i = 0; i < slots; i++) ...[
                    if (i > 0) const SizedBox(width: 12),
                    Expanded(
                      child: switch (ids.elementAtOrNull(i)) {
                        final id? => _PaddleSlot(
                          id: id,
                          onRemove: () => remove(id),
                        ),
                        null => const _EmptySlot(),
                      },
                    ),
                  ],
                  const SizedBox(width: 4),
                  Icon(Icons.expand_less, color: colors.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PaddleSlot extends ConsumerWidget {
  const _PaddleSlot({required this.id, required this.onRemove});

  final String id;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final slot = ref.watch(comparePaddleControllerProvider(id));
    // The retry lives in the comparison, which has room to explain.
    final (Widget content, String? name) = switch (slot) {
      AsyncValue(isLoading: true) => (
        const SkeletonPulse(child: _SlotSkeleton()),
        null,
      ),
      AsyncValue(hasError: true) => (
        const _SlotMessage(
          icon: Icons.cloud_off_outlined,
          text: "Couldn't load",
        ),
        null,
      ),
      AsyncValue(value: final paddle?) => (
        _SlotPaddle(paddle: paddle),
        paddle.name,
      ),
      _ => (
        const _SlotMessage(icon: Icons.search_off, text: 'Not found'),
        null,
      ),
    };

    return Row(
      children: [
        Expanded(child: content),
        IconButton(
          onPressed: onRemove,
          tooltip: name != null ? 'Remove $name' : 'Remove paddle',
          visualDensity: VisualDensity.compact,
          icon: const Icon(Icons.close, size: 18),
        ),
      ],
    );
  }
}

class _SlotLayout extends StatelessWidget {
  const _SlotLayout({required this.thumbnail, required this.body});

  static const _thumbnailAspectRatio = 3 / 4;
  static const _thumbnailWidth = 40.0;

  final Widget thumbnail;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: _thumbnailWidth,
          child: AspectRatio(
            aspectRatio: _thumbnailAspectRatio,
            child: ExcludeSemantics(child: thumbnail),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(child: body),
      ],
    );
  }
}

class _SlotPaddle extends StatelessWidget {
  const _SlotPaddle({required this.paddle});

  final Paddle paddle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return _SlotLayout(
      thumbnail: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        child: ColoredBox(
          color: theme.colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: PaddleImage(imagePath: paddle.imagePath),
          ),
        ),
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            paddle.brand.toUpperCase(),
            semanticsLabel: paddle.brand,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelSmall,
          ),
          const SizedBox(height: 2),
          Text(
            paddle.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}

class _SlotSkeleton extends StatelessWidget {
  const _SlotSkeleton();

  @override
  Widget build(BuildContext context) {
    return const _SlotLayout(
      thumbnail: SkeletonBox(),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 48, height: 8),
          SizedBox(height: 8),
          SkeletonBox(height: 10),
          SizedBox(height: 6),
          SkeletonBox(width: 40, height: 10),
        ],
      ),
    );
  }
}

class _SlotMessage extends StatelessWidget {
  const _SlotMessage({required this.icon, required this.text, this.iconColor});

  final IconData icon;
  final String text;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return _SlotLayout(
      thumbnail: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          border: Border.all(color: colors.outlineVariant),
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Center(
          child: Icon(
            icon,
            size: 18,
            color: iconColor ?? colors.onSurfaceVariant,
          ),
        ),
      ),
      body: Text(
        text,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.labelMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _EmptySlot extends StatelessWidget {
  const _EmptySlot();

  @override
  Widget build(BuildContext context) {
    return _SlotMessage(
      icon: Icons.add,
      text: 'Add a paddle',
      iconColor: Theme.of(context).colorScheme.onSurface,
    );
  }
}
