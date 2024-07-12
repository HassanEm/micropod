import 'package:flutter/material.dart';

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

  MaterialColor letterToMateriaColor(String letter) {
    final x = letter.codeUnits.first;
    const int oldMin = 0;
    const int oldMax = 150;
    const int newMin = 0;
    const int newMax = 17;
    int newNum =
        ((x - oldMin) * (newMax - newMin) / (oldMax - oldMin) + newMin).round();
    if (newNum > 18) {
      newNum = 17;
    } else if (newNum < 0) {
      newNum = 0;
    }
    return Colors.primaries[newNum];
  }
}
