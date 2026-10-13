// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compare_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The paddles being compared, in order: the `compare` parameter of the
/// catalog's query. CatalogView, PaddleDetailView and CompareView override it
/// for their subtrees, each with the ids in its own URL.

@ProviderFor(compareIds)
final compareIdsProvider = CompareIdsProvider._();

/// The paddles being compared, in order: the `compare` parameter of the
/// catalog's query. CatalogView, PaddleDetailView and CompareView override it
/// for their subtrees, each with the ids in its own URL.

final class CompareIdsProvider
    extends $FunctionalProvider<List<String>, List<String>, List<String>>
    with $Provider<List<String>> {
  /// The paddles being compared, in order: the `compare` parameter of the
  /// catalog's query. CatalogView, PaddleDetailView and CompareView override it
  /// for their subtrees, each with the ids in its own URL.
  CompareIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'compareIdsProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$compareIdsHash();

  @$internal
  @override
  $ProviderElement<List<String>> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<String> create(Ref ref) {
    return compareIds(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$compareIdsHash() => r'cbcdb10dc0dfd8d826f51c022d0830b34a237ecd';

/// One paddle of the comparison, or null when there is no such paddle.
///
/// One per id, so each column loads, fails and retries on its own, and a new
/// id in the URL only loads that paddle. It takes no scoped dependencies, so
/// the catalog's tray and the comparison sheet share it, and each id is
/// requested once.

@ProviderFor(ComparePaddleController)
final comparePaddleControllerProvider = ComparePaddleControllerFamily._();

/// One paddle of the comparison, or null when there is no such paddle.
///
/// One per id, so each column loads, fails and retries on its own, and a new
/// id in the URL only loads that paddle. It takes no scoped dependencies, so
/// the catalog's tray and the comparison sheet share it, and each id is
/// requested once.
final class ComparePaddleControllerProvider
    extends $AsyncNotifierProvider<ComparePaddleController, Paddle?> {
  /// One paddle of the comparison, or null when there is no such paddle.
  ///
  /// One per id, so each column loads, fails and retries on its own, and a new
  /// id in the URL only loads that paddle. It takes no scoped dependencies, so
  /// the catalog's tray and the comparison sheet share it, and each id is
  /// requested once.
  ComparePaddleControllerProvider._({
    required ComparePaddleControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: _noRetry,
         name: r'comparePaddleControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$comparePaddleControllerHash();

  @override
  String toString() {
    return r'comparePaddleControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ComparePaddleController create() => ComparePaddleController();

  @override
  bool operator ==(Object other) {
    return other is ComparePaddleControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$comparePaddleControllerHash() =>
    r'd079592b5c6ee2248e5c3bee1a30c3f5dc2c5394';

/// One paddle of the comparison, or null when there is no such paddle.
///
/// One per id, so each column loads, fails and retries on its own, and a new
/// id in the URL only loads that paddle. It takes no scoped dependencies, so
/// the catalog's tray and the comparison sheet share it, and each id is
/// requested once.

final class ComparePaddleControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ComparePaddleController,
          AsyncValue<Paddle?>,
          Paddle?,
          FutureOr<Paddle?>,
          String
        > {
  ComparePaddleControllerFamily._()
    : super(
        retry: _noRetry,
        name: r'comparePaddleControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// One paddle of the comparison, or null when there is no such paddle.
  ///
  /// One per id, so each column loads, fails and retries on its own, and a new
  /// id in the URL only loads that paddle. It takes no scoped dependencies, so
  /// the catalog's tray and the comparison sheet share it, and each id is
  /// requested once.

  ComparePaddleControllerProvider call(String id) =>
      ComparePaddleControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'comparePaddleControllerProvider';
}

/// One paddle of the comparison, or null when there is no such paddle.
///
/// One per id, so each column loads, fails and retries on its own, and a new
/// id in the URL only loads that paddle. It takes no scoped dependencies, so
/// the catalog's tray and the comparison sheet share it, and each id is
/// requested once.

abstract class _$ComparePaddleController extends $AsyncNotifier<Paddle?> {
  late final _$args = ref.$arg as String;
  String get id => _$args;

  FutureOr<Paddle?> build(String id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Paddle?>, Paddle?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Paddle?>, Paddle?>,
              AsyncValue<Paddle?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}
