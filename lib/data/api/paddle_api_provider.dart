import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'fake_paddle_api.dart';
import 'paddle_api.dart';

part 'paddle_api_provider.g.dart';

@Riverpod(keepAlive: true)
PaddleApi paddleApi(Ref ref) => FakePaddleApi();
