import 'package:flutter/material.dart';
import 'package:micropod/components/img_placeholder.dart';
import 'package:micropod/models/fav_pool.dart';
import 'package:micropod/models/podcast_model.dart';
import 'package:micropod/screens/podcast_screen.dart';
// import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

class PodcastCellWidget extends StatelessWidget {
  const PodcastCellWidget(this.podcast, {super.key});
  final PodcastModel podcast;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PodcastModel>.value(
        value: podcast,
        builder: (context, _) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PodcastScreen(
                        name: podcast.name, rssFeed: podcast.rssUrl)),
              );
            },
            child: Stack(
              alignment: Alignment.topRight,
              children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    podcast.poosterUrl == null
                        ? ImgPlaceholder(
                            preffredLetter: podcast.name[0],
                          )
                        : Image(
                            image:
                                //  podcast.poosterUrl == null
                                //     ? const AssetImage('assets/defualt__pooster.jpg')
                                //     :
                                NetworkImage(podcast.poosterUrl!),
                            frameBuilder: (context, child, frame,
                                    wasSynchronouslyLoaded) =>
                                Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8)),
                              child: child,
                            ),
                          ),
                    ListTile(
                      minTileHeight: 0,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                      title: Text(
                        podcast.name,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      titleTextStyle: Theme.of(context).textTheme.labelLarge,
                      subtitle: RichText(
                        text: TextSpan(
                            text: "by ",
                            style: Theme.of(context)
                                .textTheme
                                .labelSmall
                                ?.copyWith(fontWeight: FontWeight.w300),
                            children: [
                              TextSpan(
                                  text: podcast.channelName,
                                  style: Theme.of(context).textTheme.labelSmall)
                            ]),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
                Selector<FavPool, bool>(
                    selector: (_, model) => model.podcasts.contains(podcast),
                    builder: (context, value, _) {
                      return IconButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color?>(
                                  Colors.white)),
                          isSelected: value,
                          selectedIcon: const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          ),
                          onPressed: () async {
                            final favPool =
                                Provider.of<FavPool>(context, listen: false);
                            if (value) {
                              favPool.removePodcast(podcast);
                              final messenger = ScaffoldMessenger.of(context);
                              messenger.showSnackBar(SnackBar(
                                backgroundColor: Colors.blueGrey.shade900,
                                action: SnackBarAction(
                                  textColor: Colors.amber.shade800,
                                  label: "Undo",
                                  onPressed: () {
                                    favPool.undoRemovePodcast();
                                    messenger.showSnackBar(SnackBar(
                                      backgroundColor: Colors.blueGrey.shade900,
                                      content: const Text(
                                        "Podcast is back as favirate",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ));
                                  },
                                ),
                                content: const Text(
                                  "Podcast removed!",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ));
                            } else {
                              favPool.addPodcast(podcast);
                            }
                          },
                          icon: const Icon(Icons.favorite_border));
                    }),
              ],
            ),
          );
        });
  }
}
