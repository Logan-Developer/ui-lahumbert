import 'package:file_saver/file_saver.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';
import 'package:quill_pdf_converter/quill_pdf_converter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:pdf/widgets.dart' as pw;

import 'my_quill_custom_toolbar_buttons.dart';

class MyQuillToolbar extends StatelessWidget {
  MyQuillToolbar({
    required this.controller,
    super.key,
  });

  final QuillController controller;
  final ScreenshotController screenshotController = ScreenshotController();

  // 2. Render a widget as an image
  Future<Uint8List> _takeWidgetScreenshot(Widget widget) async {
    return await screenshotController.captureFromWidget(widget);
  }

// 3. Generate the PDF
  Future<void> _generatePdf() async {
    final pdfDoc = pw.Document();

    final pdfFile = await controller.document.toDelta().toPdf();

    for (final widget in pdfFile) {
      final image =
          pw.MemoryImage(await _takeWidgetScreenshot(widget as Widget));
      pdfDoc.addPage(pw.Page(build: (pw.Context context) => pw.Image(image)));
    }

    await FileSaver.instance.saveFile(
      name: 'note.pdf',
      bytes: await pdfDoc.save(),
      mimeType: MimeType.pdf,
    );
  }

  @override
  Widget build(BuildContext context) {
    return QuillToolbar(
      configurations: const QuillToolbarConfigurations(),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Wrap(
          children: [
            QuillToolbarHistoryButton(
              isUndo: true,
              controller: controller,
            ),
            QuillToolbarHistoryButton(
              isUndo: false,
              controller: controller,
            ),
            const VerticalDivider(),
            QuillToolbarIndentButton(controller: controller, isIncrease: false),
            QuillToolbarIndentButton(controller: controller, isIncrease: true),
            const VerticalDivider(),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.bold),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.italic),
            QuillToolbarToggleStyleButton(
                controller: controller, attribute: Attribute.underline),
            QuillToolbarClearFormatButton(controller: controller),
            const VerticalDivider(),
            QuillToolbarColorButton(
              controller: controller,
              isBackground: false,
            ),
            QuillToolbarColorButton(
              controller: controller,
              isBackground: true,
            ),
            const VerticalDivider(),
            QuillToolbarImageButton(controller: controller),
            QuillToolbarLinkStyleButton(controller: controller),
            const VerticalDivider(),
            QuillToolbarSearchButton(controller: controller),
            const VerticalDivider(),
            ExportPdfButton(controller: controller, onPressed: _generatePdf),
          ],
        ),
      ),
    );
  }
}
