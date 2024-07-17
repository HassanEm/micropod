import 'package:flutter/material.dart';
import 'package:micropod/models/podcast_model.dart';
import 'package:podcast_search/podcast_search.dart';

class FavoritesPool extends ChangeNotifier {
  final List<PodcastModel> _podcasts = [];
  List<PodcastModel> get podcasts => _podcasts;
  String? get favGener {
    List<String> geners =
        podcasts.map((p) => p.gener).expand((g) => g).toList();
    Map<String, int> countMap = {};

    for (var gener in geners) {
      if (countMap.containsKey(gener)) {
        countMap[gener] = countMap[gener]! + 1;
      } else {
        countMap[gener] = 1;
      }
    }
    String mostUsed = "";
    int maxCount = 0;
    countMap.forEach((gener, count) {
      if (count > maxCount) {
        maxCount = count;
        mostUsed = gener;
      }
    });

    return mostUsed;
  }

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
