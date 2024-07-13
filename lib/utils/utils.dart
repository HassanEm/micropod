import 'package:flutter/material.dart';

enum FetchState {
  unfetched,
  fetching,
  fetched,
  error,
}

extension DateTimeExt on DateTime {
  static const Map<int, String> monthDic = {
    1: "January",
    2: "February",
    3: "March",
    4: "April",
    5: "May",
    6: "June",
    7: "July",
    8: "August",
    9: "September",
    10: "October",
    11: "November",
    12: "December"
  };

  String get displayFormat {
    final year = this.year.toString();
    final month = monthDic[this.month];
    final day = this.day.toString();
    return "$year $month $day";
  }
}

extension DurationExt on Duration {
  String get ms {
    final minutes = inMinutes;
    final seconds = inSeconds - (inMinutes * 60);
    return "$minutes:$seconds";
  }
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
