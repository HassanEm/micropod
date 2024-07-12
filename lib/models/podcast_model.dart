import 'package:flutter/material.dart';

class PodcastModel extends ChangeNotifier {
  PodcastModel(
      {required String id,
      required String name,
      required String channelName,
      required String rssUrl,
      String? poosterUrl})
      : _posterUrl = poosterUrl,
        _channelName = channelName,
        _name = name,
        _rssUrl = rssUrl,
        _id = id;

  final String _id;
  String get id => _id;
  final String _name;
  String get name => _name;
  final String _rssUrl;
  String get rssUrl => _rssUrl;
  final String _channelName;
  String get channelName => _channelName;
  final String? _posterUrl;
  String? get poosterUrl => _posterUrl;
  bool _favorite = false;
  bool get favorite => _favorite;
  void toggleFavorite() {
    _favorite = !_favorite;
    notifyListeners();
  }
}
