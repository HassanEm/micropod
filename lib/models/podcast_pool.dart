import 'package:flutter/material.dart';
import 'package:micropod/models/podcast_model.dart';
import 'package:micropod/utils/utils.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastPool extends ChangeNotifier {
  PodcastPool({PoolQuery? poolQuery}) {
    fetch(poolQuery: poolQuery);
  }

  FetchState _fetchState = FetchState.unfetched;
  FetchState get fetchState => _fetchState;
  String? _error;
  String? get erorr => _error;
  final search = Search();
  Future<List<PodcastModel>?> fetch({PoolQuery? poolQuery}) async {
    _fetchState = FetchState.fetching;
    notifyListeners();
    final q = poolQuery ?? PoolQuery();

    /// Search for podcasts with 'widgets' in the title.
    final SearchResult results = await search.charts(
        limit: 20,
        country: q.country,
        explicit: q.explicit,
        genre: q.genre,
        queryParams: q.queryParams,
        language: q.language);

    _fetchState = results.successful ? FetchState.fetched : FetchState.error;
    _error = results.successful ? null : results.lastError;

    podcasts = results.items
        .map((element) => PodcastModel(
            id: "${element.trackId ?? "unknown"}",
            rssUrl: element.feedUrl ?? "unknown",
            name: element.trackName ?? "unknown",
            channelName: element.artistName ?? "unknown",
            poosterUrl: element.artworkUrl600))
        .toList();

    notifyListeners();
    return podcasts;
  }

  List<PodcastModel>? podcasts;
  int get count => podcasts?.length ?? 0;
  List<String>? get podcastNames =>
      podcasts?.map((element) => element.name).toList();
}

class PoolQuery {
  PoolQuery({
    this.country = Country.none,
    this.genre = '',
    this.language = '',
    this.explicit = false,
    this.queryParams = const {},
    this.limit = 20,
  });

  Country country;
  String language;

  int limit;

  bool explicit;

  String genre;

  Map<String, dynamic> queryParams;
}
