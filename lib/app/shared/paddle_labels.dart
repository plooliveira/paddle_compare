import '../../data/repositories/paddle/paddle_repository.dart';

extension PaddleShapeLabel on PaddleShape {
  String get label => switch (this) {
    PaddleShape.standard => 'Standard',
    PaddleShape.hybrid => 'Hybrid',
    PaddleShape.elongated => 'Elongated',
    PaddleShape.widebody => 'Widebody',
  };
}
