import 'package:flutter/material.dart';
import 'package:flutter_quill/extensions.dart' show isWeb;
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill_extensions/flutter_quill_extensions.dart';

class MyQuillToolbar extends StatelessWidget {
  const MyQuillToolbar({
    required this.controller,
    super.key,
  });

  final QuillController controller;

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
            QuillToolbarImageButton(
              controller: controller,
            ),
            // hide camera button on web platform
            if (!isWeb())
              QuillToolbarCameraButton(
                controller: controller,
              ),
            QuillToolbarVideoButton(
              controller: controller,
            )
          ],
        ),
      ),
    );
  }
}
