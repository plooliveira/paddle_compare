import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../api/paddle_api_provider.dart';
import 'paddle_repository.dart';
import 'paddle_repository_from_fake.dart';

part 'paddle_repository_provider.g.dart';

@Riverpod(keepAlive: true)
PaddleRepository paddleRepository(Ref ref) =>
    PaddleRepositoryFromFake(ref.watch(paddleApiProvider));
