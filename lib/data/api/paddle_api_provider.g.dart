// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paddle_api_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paddleApi)
final paddleApiProvider = PaddleApiProvider._();

final class PaddleApiProvider
    extends $FunctionalProvider<PaddleApi, PaddleApi, PaddleApi>
    with $Provider<PaddleApi> {
  PaddleApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paddleApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paddleApiHash();

  @$internal
  @override
  $ProviderElement<PaddleApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaddleApi create(Ref ref) {
    return paddleApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaddleApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaddleApi>(value),
    );
  }
}

String _$paddleApiHash() => r'eb9811590caa9dc404e48f4b696de8c593f8497b';
