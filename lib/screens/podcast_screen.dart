import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:micropod/components/episode_cell_widget.dart';
import 'package:micropod/components/img_placeholder.dart';
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
        body: podcast != null
            ? CustomScrollView(
                slivers: [
                  SliverAppBar(
                    // centerTitle: true,
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
                                    image: NetworkImage(
                                        widget.podcast.poosterUrl!))
                                : null),
                      ),
                      title: Text(widget.podcast.name),
                    ),
                  ),
                  SliverList(
                      delegate: SliverChildListDelegate(
                          [const SizedBox(height: 16)])),
                  SliverList.separated(
                    separatorBuilder: (_, __) => const Divider(indent: 90),
                    itemBuilder: (context, i) =>
                        EpisodeCellWidget(podcast!.episodes[i]),
                    itemCount: podcast!.episodes.length,
                  )
                ],
              )
            : const Center(
                child: CupertinoActivityIndicator(),
              ));
  }
}
