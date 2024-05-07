import 'dart:convert';
import 'dart:html' as htmllib;
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/embeds/image/toolbar/image_button.dart';
import 'package:htmltopdfwidgets/htmltopdfwidgets.dart' as htmltopdf;
import 'package:path_provider/path_provider.dart';
import 'package:quill_html_converter/quill_html_converter.dart';

import 'my_quill_custom_toolbar_buttons.dart';

class MyQuillToolbar extends StatelessWidget {
  const MyQuillToolbar({
    required this.controller,
    super.key,
  });

  final QuillController controller;

  Future<void> _generatePdf() async {
    // Create a PDF document.
    final html = controller.document.toDelta().toHtml();

    final newpdf = htmltopdf.Document();
    final List<htmltopdf.Widget> widgets = await htmltopdf.HTMLToPdf().convert(
      html,
    );

    newpdf.addPage(htmltopdf.MultiPage(build: (context) {
      return widgets;
    }));

    // Save the document
    List<int> bytes = await newpdf.save();

    if (kIsWeb) {
      // Dispose the document
      htmllib.AnchorElement(
          href:
              "data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}")
        ..setAttribute("download", "output.pdf")
        ..click();
    } else if (Platform.isAndroid || Platform.isIOS) {
      // Save the document to the device
      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/output.pdf');
      await file.writeAsBytes(bytes);
    }
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
