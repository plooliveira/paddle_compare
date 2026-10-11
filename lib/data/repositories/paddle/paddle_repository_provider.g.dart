// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paddle_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(paddleRepository)
final paddleRepositoryProvider = PaddleRepositoryProvider._();

final class PaddleRepositoryProvider
    extends
        $FunctionalProvider<
          PaddleRepository,
          PaddleRepository,
          PaddleRepository
        >
    with $Provider<PaddleRepository> {
  PaddleRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paddleRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paddleRepositoryHash();

  @$internal
  @override
  $ProviderElement<PaddleRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PaddleRepository create(Ref ref) {
    return paddleRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PaddleRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PaddleRepository>(value),
    );
  }
}

String _$paddleRepositoryHash() => r'89e4146daefa98794e74eadb1d9cb81c8ecf7eec';
