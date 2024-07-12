import 'package:flutter/material.dart';
import 'package:micropod/models/universal_audio_player.dart';
import 'package:micropod/utils/utils.dart';
import 'package:provider/provider.dart';

class EpisodeScreen extends StatelessWidget {
  const EpisodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final player = Provider.of<UniversalAudioPlayer>(context);
    final source = player.source;

    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: source == null
            ? const Text("Nothing to show!!!")
            : ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Image(
                        image: source.imageUrl == null
                            ? const AssetImage('assets/defualt__pooster.jpg')
                            : NetworkImage(source.imageUrl!),
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) =>
                                Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          child: child,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        source.publicationDate == null
                            ? "No publish date found!"
                            : source.publicationDate!.displayFormat,
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.apply(color: Colors.grey),
                      ),
                      Text(
                        source.title,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              iconSize: 30,
                              onPressed: () {
                                player.seek(
                                    (player.currentDuration ?? Duration.zero) -
                                        const Duration(seconds: 30));
                              },
                              icon: const Icon(Icons.replay_30_rounded)),
                          Selector<UniversalAudioPlayer, bool>(
                              selector: (_, m) => m.isPlaying || m.isPlaying,
                              builder: (context, isPlaying, _) {
                                return IconButton(
                                    iconSize: 40,
                                    onPressed: () {
                                      player.togglePlay();
                                    },
                                    icon: isPlaying
                                        ? const Icon(Icons.pause_rounded)
                                        : const Icon(Icons.play_arrow_rounded));
                              }),
                          IconButton(
                              iconSize: 30,
                              onPressed: () {
                                player.seek(
                                    (player.currentDuration ?? Duration.zero) +
                                        const Duration(seconds: 30));
                              },
                              icon: const Icon(Icons.forward_30_rounded)),
                        ],
                      ),
                      StreamBuilder(
                          stream: player.positionStream,
                          builder: (context, snapShot) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: 32,
                                  child: SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                        overlayShape:
                                            SliderComponentShape.noOverlay,
                                        thumbColor: Colors.transparent,
                                        thumbShape: const RoundSliderThumbShape(
                                            enabledThumbRadius: 0.0)),
                                    child: Slider(
                                      thumbColor: Colors.red,
                                      activeColor: Colors.white,
                                      min: 0,
                                      max: player.duration?.inSeconds
                                              .toDouble() ??
                                          0,
                                      value:
                                          snapShot.data?.inSeconds.toDouble() ??
                                              0,
                                      onChanged: (value) {},
                                      onChangeEnd: (value) {
                                        player.seek(
                                            Duration(seconds: value.ceil()));
                                      },
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(snapShot.data?.ms ?? "..."),
                                    Text(player.duration?.ms ?? "...")
                                  ],
                                )
                              ],
                            );
                          }),
                      const SizedBox(height: 8),
                      Text(source.description)
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
