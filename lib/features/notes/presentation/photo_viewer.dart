import 'dart:io';

import 'package:flutter/material.dart';

/// Полноэкранный просмотр фото заметки: зум (pinch) + свайп между снимками.
Future<void> openPhotoViewer(
  BuildContext context,
  List<File> files,
  int initialIndex,
) {
  if (files.isEmpty) return Future.value();
  return Navigator.of(context, rootNavigator: true).push<void>(
    MaterialPageRoute(
      fullscreenDialog: true,
      builder: (_) => _PhotoViewer(files: files, initialIndex: initialIndex),
    ),
  );
}

class _PhotoViewer extends StatelessWidget {
  const _PhotoViewer({required this.files, required this.initialIndex});
  final List<File> files;
  final int initialIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: files.length,
        itemBuilder: (_, i) => InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          child: Center(
            child: Image.file(
              files[i],
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(
                Icons.broken_image_outlined,
                color: Colors.white54,
                size: 48,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
