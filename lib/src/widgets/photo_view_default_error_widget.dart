import 'package:flutter/material.dart';

class PhotoViewDefaultError extends StatelessWidget {
  const PhotoViewDefaultError({Key? key, required this.decoration}) : super(key: key);

  final BoxDecoration decoration;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: decoration,
      child: Center(
        child: Icon(
          Icons.broken_image,
          color: Colors.grey[400],
          size: 40.0,
        ),
      ),
    );
  }
}
