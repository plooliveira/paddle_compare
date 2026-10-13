// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paddle_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// The paddle id in the detail URL. PaddleDetailView overrides it for its
/// subtree.

@ProviderFor(paddleDetailId)
final paddleDetailIdProvider = PaddleDetailIdProvider._();

/// The paddle id in the detail URL. PaddleDetailView overrides it for its
/// subtree.

final class PaddleDetailIdProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// The paddle id in the detail URL. PaddleDetailView overrides it for its
  /// subtree.
  PaddleDetailIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paddleDetailIdProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[],
        $allTransitiveDependencies: <ProviderOrFamily>[],
      );

  @override
  String debugGetCreateSourceHash() => _$paddleDetailIdHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return paddleDetailId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$paddleDetailIdHash() => r'60aded5b73dbd01e5b3362baece47da2dd38968a';

/// The paddle whose id is in the URL, or null when there is no such paddle.

@ProviderFor(PaddleDetailController)
final paddleDetailControllerProvider = PaddleDetailControllerProvider._();

/// The paddle whose id is in the URL, or null when there is no such paddle.
final class PaddleDetailControllerProvider
    extends $AsyncNotifierProvider<PaddleDetailController, Paddle?> {
  /// The paddle whose id is in the URL, or null when there is no such paddle.
  PaddleDetailControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'paddleDetailControllerProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[paddleDetailIdProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          PaddleDetailControllerProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = paddleDetailIdProvider;

  @override
  String debugGetCreateSourceHash() => _$paddleDetailControllerHash();

  @$internal
  @override
  PaddleDetailController create() => PaddleDetailController();
}

String _$paddleDetailControllerHash() =>
    r'5cab054cb4a0f3a1854cad7fa7a18602f6544420';

/// The paddle whose id is in the URL, or null when there is no such paddle.

abstract class _$PaddleDetailController extends $AsyncNotifier<Paddle?> {
  FutureOr<Paddle?> build();
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
    return element.handleCreate(ref, build);
  }
}
