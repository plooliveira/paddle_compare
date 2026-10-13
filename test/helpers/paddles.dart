import 'package:paddle_compare/data/repositories/paddle/paddle_repository.dart';

/// Even indexes are standard, odd ones hybrid. Prices go up with the index.
List<Paddle> catalogPaddles(int count) => [
  for (var i = 0; i < count; i++)
    Paddle(
      id: 'p$i',
      brand: 'Brand',
      name: 'Paddle $i',
      priceUsd: 100.0 + i,
      inStock: true,
      shape: i.isEven ? PaddleShape.standard : PaddleShape.hybrid,
    ),
];

/// Every field set.
const fullPaddle = Paddle(
  id: 'summit',
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
  description: 'Tour-level control paddle with a thick core.',
);

/// Only the required fields and one rating.
const sparsePaddle = Paddle(
  id: 'sparse',
  brand: 'Brand',
  name: 'Sparse',
  ratings: PaddleRatings(power: 5),
);
