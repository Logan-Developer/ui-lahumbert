import 'dart:convert';
import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/embeds/image/toolbar/image_button.dart';
import 'package:quill_html_converter/quill_html_converter.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';

import 'my_quill_custom_toolbar_buttons.dart';

class MyQuillToolbar extends StatelessWidget {
  const MyQuillToolbar({
    required this.controller,
    super.key,
  });

  final QuillController controller;

  Future<void> _generatePdf() async {
    // Create a PDF document.
    PdfDocument document = PdfDocument();

    final html = controller.document.toDelta().toHtml();

    // Split the html into lines
    final lines = const LineSplitter().convert(html);

    const nbLinesPerPage = 50;
    const nbCharsPerLine = 100;
    const lineHeight = 15; // Adjust for desired line spacing

    var currentNbLines = 0;

    // Create a new page if the content is too long
    for (var line in lines) {
      if (currentNbLines == nbLinesPerPage) {
        document.pages.add(); // Add a new page
        currentNbLines = 0;
      }

      // Split the line into chunks of 100 characters
      final chunks = <String>[];
      for (var i = 0; i < line.length; i += nbCharsPerLine) {
        var endIndex = i + nbCharsPerLine;
        if (endIndex > line.length) {
          endIndex = line.length;
        }
        chunks.add(line.substring(i, endIndex));
      }

      // Add the chunks to the page
      for (var chunk in chunks) {
        if (document.pages.count == 0) {
          document.pages.add(); // Add a page if none exist
        }

        final page = document.pages[document.pages.count - 1];
        final graphics = page.graphics;
        final font = PdfStandardFont(PdfFontFamily.helvetica, 12);
        final brush = PdfSolidBrush(PdfColor(0, 0, 0));
        final format = PdfStringFormat(
          alignment: PdfTextAlignment.left,
          lineAlignment: PdfVerticalAlignment.top,
        );

        final yPosition = (currentNbLines * lineHeight) as double;
        var bounds = Rect.fromLTWH(
            0, yPosition, 500, lineHeight as double); // Adjust width if needed
        graphics.drawString(
          chunk,
          font,
          brush: brush,
          bounds: bounds,
          format: format,
        );

        currentNbLines++; // Increment after drawing each line
      }
    }

    // Save the document
    List<int> bytes = await document.save();
    // Dispose the document
    document.dispose();
    AnchorElement(
        href:
            "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
      ..setAttribute("download", "output.pdf")
      ..click();
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
