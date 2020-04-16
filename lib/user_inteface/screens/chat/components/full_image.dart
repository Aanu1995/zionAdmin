import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FullImage extends StatelessWidget {
  final String hero;
  final String imageUrl;
  const FullImage({this.hero, this.imageUrl});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
      ),
      body: SizedBox.expand(
        child: Hero(
          tag: hero,
          child: Material(
            color: Colors.black87,
            child: PhotoView.customChild(
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, value) {
                  return CircularProgressIndicator();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
