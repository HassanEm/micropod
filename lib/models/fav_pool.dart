import 'package:flutter/material.dart';
import 'package:micropod/models/podcast_model.dart';
import 'package:podcast_search/podcast_search.dart';

class FavPool extends ChangeNotifier {
  final List<PodcastModel> _podcasts = [];
  List<PodcastModel> get podcasts => _podcasts;

  void addPodcast(PodcastModel podcast) {
    _podcasts.add(podcast);
    notifyListeners();
  }

  MapEntry<int, PodcastModel>? lastRemovedCatch;
  void removePodcast(PodcastModel podcast) {
    final index = _podcasts.indexOf(podcast);
    lastRemovedCatch = MapEntry<int, PodcastModel>(index, podcast);
    _podcasts.remove(podcast);
    notifyListeners();
  }

  void undoRemovePodcast() {
    if (lastRemovedCatch != null) {
      _podcasts.insert(lastRemovedCatch!.key, lastRemovedCatch!.value);
      notifyListeners();
    }
  }

  final List<Episode> _episodes = [];
  List<Episode> get episodes => _episodes;

  void addEpisode(Episode episode) {
    _episodes.add(episode);
    notifyListeners();
  }
}
