import 'package:flutter/material.dart';
import 'package:micropod/components/img_placeholder.dart';
import 'package:micropod/models/universal_audio_player.dart';
import 'package:micropod/screens/player_screen.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

class EpisodeCellWidget extends StatelessWidget {
  const EpisodeCellWidget(this.episode, {super.key});
  final Episode episode;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      trailing: Consumer<UniversalAudioPlayer>(builder: (context, player, _) {
        final current = player.source == episode;
        final isPlaying = current && (player.isPlaying || player.loading);
        return IconButton(
          icon: current && isPlaying
              ? const Icon(Icons.pause_rounded)
              : const Icon(Icons.play_arrow_rounded),
          onPressed: () async {
            final player =
                Provider.of<UniversalAudioPlayer>(context, listen: false);
            await player.setAudio(episode);
          },
        );
      }),
      leading: episode.imageUrl == null
          ? ImgPlaceholder(
              preffredLetter: episode.title[0], preffredLetterSize: 32)
          : Image(
              image: NetworkImage(episode.imageUrl!),
              errorBuilder: (_, __, ___) => ImgPlaceholder(
                  preffredLetter: episode.title[0], preffredLetterSize: 32),
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) =>
                  Container(
                clipBehavior: Clip.antiAlias,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: child,
              ),
            ),
      title: Text(episode.title),
      onTap: () {
        final player =
            Provider.of<UniversalAudioPlayer>(context, listen: false);
        player.setAudio(episode).then((_) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PlayerScreen()),
          );
        });
      },
    );
  }
}
