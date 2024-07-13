import 'package:flutter/material.dart';
import 'package:micropod/utils/utils.dart';

class ImgPlaceholder extends StatelessWidget {
  const ImgPlaceholder(
      {this.preffredLetter = "🎧",
      this.preffredLetterSize = 20,
      this.preffredLetterColor,
      super.key});
  final String preffredLetter;
  final double preffredLetterSize;
  final Color? preffredLetterColor;

  @override
  Widget build(BuildContext context) {
    final color = preffredLetterColor ?? letterToMateriaColor(preffredLetter);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        // padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: color.withOpacity(0.7)),
        child: Text(
          preffredLetter,
          style: TextStyle(
            fontSize: preffredLetterSize,
            color: color,
          ),
        ),
      ),
    );
  }
}
