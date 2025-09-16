import 'package:flutter/material.dart';

class PhotoViewDefaultLoading extends StatelessWidget {
  const PhotoViewDefaultLoading({Key? key, this.event}) : super(key: key);

  final ImageChunkEvent? event;

  @override
  Widget build(BuildContext context) {
    final expectedBytes = event?.expectedTotalBytes;
    final loadedBytes = event?.cumulativeBytesLoaded;
    final value = loadedBytes != null && expectedBytes != null ? loadedBytes / expectedBytes : null;

    return Center(
      child: Container(
        width: 20.0,
        height: 20.0,
        child: CircularProgressIndicator(value: value),
      ),
    );
  }
}
