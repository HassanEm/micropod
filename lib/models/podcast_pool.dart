import 'package:flutter/material.dart';
import 'package:micropod/models/podcast_model.dart';
import 'package:micropod/utils/utils.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastPool extends ChangeNotifier {
  PodcastPool.chart({PoolQuery? poolQuery}) {
    q = poolQuery ?? PoolQuery();
    fetch(chart: true);
  }
  PodcastPool.search({PoolQuery? poolQuery}) {
    q = poolQuery ?? PoolQuery();
    fetch(chart: false);
  }

  FetchState _fetchState = FetchState.unfetched;
  FetchState get fetchState => _fetchState;
  String? _error;
  String? get erorr => _error;
  final search = Search();
  PoolQuery q = PoolQuery();
  Future<List<PodcastModel>?> fetch(
      {bool chart = false, PoolQuery? poolQuery}) async {
    _fetchState = FetchState.fetching;
    notifyListeners();
    if (poolQuery != null) q = poolQuery;

    /// Search for podcasts with 'widgets' in the title.
    final SearchResult results = chart
        ? await search.charts(
            limit: 20,
            country: q.country,
            explicit: q.explicit,
            genre: q.genre,
            queryParams: q.queryParams,
            language: q.language)
        : await search.search(q.term,
            limit: 20,
            country: q.country,
            explicit: q.explicit,
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
            poosterUrl: element.artworkUrl600,
            gener: element.genre?.map((g) => g.name).toList() ?? []))
        .toList();

    notifyListeners();
    return podcasts;
  }

  Future<List<PodcastModel>?> newSearch(PoolQuery query) async {
    return await fetch(chart: false, poolQuery: query);
  }

  List<PodcastModel>? podcasts;
  int get count => podcasts?.length ?? 0;
  List<String>? get podcastNames =>
      podcasts?.map((element) => element.name).toList();
}

class PoolQuery {
  PoolQuery({
    this.term = "",
    this.country = Country.none,
    this.genre = '',
    this.language = '',
    this.explicit = false,
    this.queryParams = const {},
    this.limit = 20,
  });

  String term;
  Country country;
  String language;
  int limit;
  bool explicit;
  String genre;
  Map<String, dynamic> queryParams;
}
