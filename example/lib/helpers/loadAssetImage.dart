import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget loadImage({required String imageUrl, double? height, double? width}) {
  return Container(
    height: height ?? 25,
    width: width ?? 25,
    decoration: BoxDecoration(
      image: DecorationImage(
        // colorFilter:  ColorFilter.mode(
        //     Colors.transparent, BlendMode.dstATop),
        image: AssetImage(imageUrl),
        fit: BoxFit.contain,
      ),
    ),
  );
}
