import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/data/repositories/paddle/models/paddle.dart';
import 'package:paddle_compare/data/repositories/paddle/models/paddle_dimensions.dart';
import 'package:paddle_compare/data/repositories/paddle/models/paddle_ratings.dart';
import 'package:paddle_compare/data/repositories/paddle/models/paddle_shape.dart';

Map<String, Object?> paddleJson([Map<String, Object?> overrides = const {}]) =>
    {
      'id': 'apex-court-summit-pro-16',
      'brand': 'Apex Court',
      'name': 'Summit Pro 16',
      'releaseYear': 2025,
      'priceUsd': 249.99,
      'inStock': true,
      'shape': 'elongated',
      'faceMaterial': 'raw carbon',
      'coreThicknessMm': 16,
      'weight': {'value': 8.0, 'unit': 'oz'},
      'swingWeight': 116,
      'twistWeight': 6.4,
      'dimensionsIn': {'length': 16.5, 'width': 7.5, 'handleLength': 5.5},
      'gripCircumferenceIn': 4.25,
      'ratings': {'power': 7, 'control': 8, 'spin': 9, 'pop': 6},
      'imagePath': 'assets/images/paddles/apex-court-summit-pro-16.png',
      'description': 'Tour-level control paddle.',
      ...overrides,
    };

void main() {
  group('Paddle.tryFromJson', () {
    test('parses a clean entry', () {
      expect(
        Paddle.tryFromJson(paddleJson()),
        const Paddle(
          id: 'apex-court-summit-pro-16',
          brand: 'Apex Court',
          name: 'Summit Pro 16',
          releaseYear: 2025,
          priceUsd: 249.99,
          inStock: true,
          shape: PaddleShape.elongated,
          faceMaterial: 'raw carbon',
          coreThicknessMm: 16,
          weightOz: 8,
          swingWeight: 116,
          twistWeight: 6.4,
          dimensions: PaddleDimensions(
            lengthIn: 16.5,
            widthIn: 7.5,
            handleLengthIn: 5.5,
          ),
          gripCircumferenceIn: 4.25,
          ratings: PaddleRatings(power: 7, control: 8, spin: 9, pop: 6),
          imagePath: 'assets/images/paddles/apex-court-summit-pro-16.png',
          description: 'Tour-level control paddle.',
        ),
      );
    });

    test('converts grams to ounces', () {
      final paddle = Paddle.tryFromJson(
        paddleJson({
          'weight': {'value': 222, 'unit': 'g'},
        }),
      );

      expect(paddle!.weightOz, closeTo(7.83, 0.01));
    });

    test('drops weight with an unknown unit', () {
      final paddle = Paddle.tryFromJson(
        paddleJson({
          'weight': {'value': 3, 'unit': 'stone'},
        }),
      );

      expect(paddle!.weightOz, isNull);
    });

    test('turns missing, null and blank fields into null', () {
      final json = paddleJson({
        'swingWeight': null,
        'priceUsd': null,
        'description': '',
        'imagePath': null,
        'ratings': {'power': 6, 'control': 5, 'pop': 6},
      })..remove('twistWeight');

      final paddle = Paddle.tryFromJson(json)!;

      expect(paddle.swingWeight, isNull);
      expect(paddle.twistWeight, isNull);
      expect(paddle.priceUsd, isNull);
      expect(paddle.description, isNull);
      expect(paddle.imagePath, isNull);
      expect(paddle.ratings.spin, isNull);
      expect(paddle.ratings.power, 6);
    });

    test('ignores invalid values instead of failing', () {
      final paddle = Paddle.tryFromJson(
        paddleJson({
          'shape': 'triangle',
          'priceUsd': -10,
          'ratings': {'power': 42, 'control': 'high'},
          'dimensionsIn': 'n/a',
        }),
      )!;

      expect(paddle.shape, isNull);
      expect(paddle.priceUsd, isNull);
      expect(paddle.ratings, const PaddleRatings());
      expect(paddle.dimensions, const PaddleDimensions());
    });

    test('accepts numbers sent as strings', () {
      final paddle = Paddle.tryFromJson(
        paddleJson({'priceUsd': '199.00', 'releaseYear': '2024'}),
      )!;

      expect(paddle.priceUsd, 199.0);
      expect(paddle.releaseYear, 2024);
    });

    test('returns null without id, brand or name', () {
      expect(Paddle.tryFromJson(paddleJson({'id': null})), isNull);
      expect(Paddle.tryFromJson(paddleJson({'brand': ' '})), isNull);
      expect(Paddle.tryFromJson(paddleJson()..remove('name')), isNull);
    });

    test('returns null for non-object entries', () {
      expect(Paddle.tryFromJson(null), isNull);
      expect(Paddle.tryFromJson('paddle'), isNull);
      expect(Paddle.tryFromJson([1, 2]), isNull);
    });
  });
}
