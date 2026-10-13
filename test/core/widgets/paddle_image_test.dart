import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:paddle_compare/core/widgets/paddle_image.dart';

const _path = 'assets/images/paddles/apex-court-basecamp.png';

Future<void> _pumpAtWidth(WidgetTester tester, double width) =>
    tester.pumpWidget(
      Center(
        child: SizedBox(
          width: width,
          height: width,
          child: const PaddleImage(imagePath: _path),
        ),
      ),
    );

Image _image(WidgetTester tester) => tester.widget<Image>(find.byType(Image));

int? _decodeWidth(WidgetTester tester) =>
    (_image(tester).image as ResizeImage).width;

void main() {
  testWidgets('a resize decodes again only when it needs a larger image', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    await _pumpAtWidth(tester, 100);
    expect(_decodeWidth(tester), 256);
    expect(_image(tester).gaplessPlayback, isTrue);

    // Same step: same image, nothing to decode.
    await _pumpAtWidth(tester, 120);
    expect(_decodeWidth(tester), 256);

    await _pumpAtWidth(tester, 140);
    expect(_decodeWidth(tester), 512);

    // Smaller: keeps the larger decode.
    await _pumpAtWidth(tester, 60);
    expect(_decodeWidth(tester), 512);
  });
}
