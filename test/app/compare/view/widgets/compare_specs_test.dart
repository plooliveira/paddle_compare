import 'package:flutter_test/flutter_test.dart';
import 'package:paddle_compare/app/compare/view/widgets/compare_specs.dart';

void main() {
  group('CompareSpecs.differ', () {
    test('is false when every value is the same', () {
      expect(CompareSpecs.differ(['Hybrid', 'Hybrid']), isFalse);
    });

    test('is true when two values are different', () {
      expect(CompareSpecs.differ(['Hybrid', 'Elongated']), isTrue);
      expect(CompareSpecs.differ([7, 7, 5]), isTrue);
    });

    test('skips missing values', () {
      expect(CompareSpecs.differ(['Hybrid', null]), isFalse);
      expect(CompareSpecs.differ([null, null]), isFalse);
      expect(CompareSpecs.differ(['Hybrid', null, 'Hybrid']), isFalse);
    });

    test('is false with no values', () {
      expect(CompareSpecs.differ([]), isFalse);
    });
  });
}
