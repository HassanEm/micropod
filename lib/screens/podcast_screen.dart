import 'package:flutter/material.dart';
import 'package:micropod/components/img_placeholder.dart';
import 'package:micropod/components/universal_scaffold.dart';
import 'package:micropod/models/universal_audio_player.dart';
import 'package:micropod/screens/episode_screen.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

class PodcastScreen extends StatefulWidget {
  const PodcastScreen({required this.rssFeed, required this.name, super.key});
  final String rssFeed;
  final String name;

  @override
  State<PodcastScreen> createState() => _PodcastScreenState();
}

class _PodcastScreenState extends State<PodcastScreen> {
  Podcast? podcast;

  @override
  void initState() {
    Podcast.loadFeed(url: widget.rssFeed).then((value) {
      setState(() => podcast = value);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return UniversalScaffold(
        appBar: AppBar(title: Text(widget.name)),
        body: podcast != null
            ? _EpisodesWidget(podcast!.episodes)
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }
}

class _EpisodesWidget extends StatelessWidget {
  const _EpisodesWidget(this.episodes);
  final List<Episode> episodes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (_, __) => const Divider(indent: 90),
        itemCount: episodes.length,
        itemBuilder: (context, i) {
          final source = episodes[i];
          return ListTile(
            trailing:
                Consumer<UniversalAudioPlayer>(builder: (context, player, _) {
              final current = player.source == source;
              final isPlaying = current && (player.isPlaying || player.loading);
              return IconButton(
                icon: current && isPlaying
                    ? const Icon(Icons.pause_rounded)
                    : const Icon(Icons.play_arrow_rounded),
                onPressed: () async {
                  final player =
                      Provider.of<UniversalAudioPlayer>(context, listen: false);
                  await player.setAudio(source);
                },
              );
            }),
            leading: source.imageUrl == null
                ? ImgPlaceholder(
                    preffredLetter: source.title[0], preffredLetterSize: 32)
                : Image(
                    image: NetworkImage(source.imageUrl!),
                    frameBuilder:
                        (context, child, frame, wasSynchronouslyLoaded) =>
                            Container(
                      clipBehavior: Clip.antiAlias,
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(8)),
                      child: child,
                    ),
                  ),
            title: Text(source.title),
            onTap: () {
              final player =
                  Provider.of<UniversalAudioPlayer>(context, listen: false);
              player.setAudio(source).then((_) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const EpisodeScreen()),
                );
              });
            },
          );
        });
  }
}
