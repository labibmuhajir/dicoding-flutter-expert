import 'package:cached_network_image/cached_network_image.dart';
import 'package:ditonton/common/constants.dart';
import 'package:flutter/material.dart';

class DitontonImage extends StatelessWidget {
  final String posterPath;
  final double? width;
  final double? height;

  DitontonImage(this.posterPath, {this.width, this.height});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: '$BASE_IMAGE_URL$posterPath',
        placeholder: (context, url) => Container(
          width: width,
          height: height,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
