// Helper class for the PDF export button
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ExportPdfButton extends StatelessWidget {
  final QuillController controller;
  final VoidCallback onPressed;

  const ExportPdfButton({
    super.key,
    required this.controller,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.picture_as_pdf),
      tooltip: 'Export to PDF',
      onPressed: onPressed,
    );
  }
}
