// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The filter in the catalog URL. CatalogView overrides it for its subtree.

@ProviderFor(catalogFilter)
final catalogFilterProvider = CatalogFilterProvider._();

/// The filter in the catalog URL. CatalogView overrides it for its subtree.

final class CatalogFilterProvider
    extends $FunctionalProvider<CatalogFilter, CatalogFilter, CatalogFilter>
    with $Provider<CatalogFilter> {
  /// The filter in the catalog URL. CatalogView overrides it for its subtree.
  CatalogFilterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'catalogFilterProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$catalogFilterHash();

  @$internal
  @override
  $ProviderElement<CatalogFilter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CatalogFilter create(Ref ref) {
    return catalogFilter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CatalogFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CatalogFilter>(value),
    );
  }
}

String _$catalogFilterHash() => r'6cb71a433b042cc7fc2c11070e933becf78956e8';

/// Loads, page by page, the paddles matching the filter in the URL. A new
/// filter reloads from the first page.

@ProviderFor(CatalogController)
final catalogControllerProvider = CatalogControllerProvider._();

/// Loads, page by page, the paddles matching the filter in the URL. A new
/// filter reloads from the first page.
final class CatalogControllerProvider
    extends $AsyncNotifierProvider<CatalogController, CatalogState> {
  /// Loads, page by page, the paddles matching the filter in the URL. A new
  /// filter reloads from the first page.
  CatalogControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'catalogControllerProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[catalogFilterProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          CatalogControllerProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = catalogFilterProvider;

  @override
  String debugGetCreateSourceHash() => _$catalogControllerHash();

  @$internal
  @override
  CatalogController create() => CatalogController();
}

String _$catalogControllerHash() => r'7cdec4d6392d2fdc25e9624ed1ae68b7db2c8912';

/// Loads, page by page, the paddles matching the filter in the URL. A new
/// filter reloads from the first page.

abstract class _$CatalogController extends $AsyncNotifier<CatalogState> {
  FutureOr<CatalogState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<CatalogState>, CatalogState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<CatalogState>, CatalogState>,
              AsyncValue<CatalogState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
