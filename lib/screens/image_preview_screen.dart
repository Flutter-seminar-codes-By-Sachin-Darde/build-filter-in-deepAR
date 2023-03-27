import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class ImagePreview extends StatelessWidget {
  final File file;
  const ImagePreview({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Image.file(
        file,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}
