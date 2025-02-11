import 'package:flutter/material.dart';
import 'package:micropod/components/episode_cell_widget.dart';
import 'package:micropod/components/universal_scaffold.dart';
import 'package:micropod/models/podcast_model.dart';
import 'package:micropod/utils/utils.dart';
import 'package:podcast_search/podcast_search.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({required this.podcast, super.key});
  final PodcastModel podcast;

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  Podcast? podcast;

  @override
  void initState() {
    Podcast.loadFeed(url: widget.podcast.rssUrl).then((value) {
      setState(() => podcast = value);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UniversalScaffold(
        body: CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 300,
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              foregroundDecoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                    Theme.of(context).canvasColor,
                    Colors.transparent,
                    Colors.transparent,
                  ])),
              decoration: BoxDecoration(
                  color: letterToMateriaColor(widget.podcast.name[0]),
                  image: widget.podcast.poosterUrl != null
                      ? DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(widget.podcast.poosterUrl!))
                      : null),
            ),
            title: Text(widget.podcast.name),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: widget.podcast.gener.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, i) {
                final String g = widget.podcast.gener[i];
                return Chip(
                    label: Text(g),
                    labelStyle: Theme.of(context).textTheme.labelSmall,
                    side: BorderSide.none,
                    color: WidgetStateProperty.all<Color?>(
                        (Colors.grey.shade800)));
              },
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([const SizedBox(height: 16)])),
        podcast != null
            ? SliverList.separated(
                separatorBuilder: (_, __) => const Divider(indent: 90),
                itemBuilder: (context, i) =>
                    EpisodeCellWidget(podcast!.episodes[i]),
                itemCount: podcast!.episodes.length,
              )
            : SliverList(
                delegate: SliverChildListDelegate([
                SizedBox(
                  height: 1,
                  child: LinearProgressIndicator(
                    color: letterToMateriaColor(widget.podcast.name[0]),
                  ),
                )
              ]))
      ],
    ));
  }
}
