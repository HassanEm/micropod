import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:micropod/components/img_placeholder.dart';
import 'package:micropod/models/universal_audio_player.dart';
import 'package:micropod/screens/player_screen.dart';
import 'package:micropod/utils/utils.dart';
import 'package:podcast_search/podcast_search.dart';
import 'package:provider/provider.dart';

class UniversalScaffold extends StatelessWidget {
  const UniversalScaffold(
      {this.appBar,
      this.body,
      this.floatingActionButton,
      this.floatingActionButtonLocation,
      this.floatingActionButtonAnimator,
      this.persistentFooterButtons,
      this.persistentFooterAlignment = AlignmentDirectional.centerEnd,
      this.drawer,
      this.onDrawerChanged,
      this.endDrawer,
      this.onEndDrawerChanged,
      this.bottomNavigationBar,
      this.bottomSheet,
      this.backgroundColor,
      this.resizeToAvoidBottomInset,
      this.primary = true,
      this.drawerDragStartBehavior = DragStartBehavior.start,
      this.extendBody = false,
      this.extendBodyBehindAppBar = false,
      this.drawerScrimColor,
      this.drawerEdgeDragWidth,
      this.drawerEnableOpenDragGesture = true,
      this.endDrawerEnableOpenDragGesture = true,
      this.restorationId,
      super.key});
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final FloatingActionButtonAnimator? floatingActionButtonAnimator;
  final List<Widget>? persistentFooterButtons;
  final AlignmentDirectional persistentFooterAlignment;
  final Widget? drawer;
  final DrawerCallback? onDrawerChanged;
  final Widget? endDrawer;
  final DrawerCallback? onEndDrawerChanged;
  final Widget? bottomNavigationBar;
  final Widget? bottomSheet;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool primary;
  final DragStartBehavior drawerDragStartBehavior;
  final bool extendBody;
  final bool extendBodyBehindAppBar;
  final Color? drawerScrimColor;
  final double? drawerEdgeDragWidth;
  final bool drawerEnableOpenDragGesture;
  final bool endDrawerEnableOpenDragGesture;
  final String? restorationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
      floatingActionButtonAnimator: floatingActionButtonAnimator,
      persistentFooterButtons: persistentFooterButtons,
      persistentFooterAlignment: persistentFooterAlignment,
      drawer: drawer,
      onDrawerChanged: onDrawerChanged,
      endDrawer: endDrawer,
      onEndDrawerChanged: onDrawerChanged,
      bottomNavigationBar: bottomNavigationBar == null
          ? const _MiniPlayer()
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [const _MiniPlayer(), bottomNavigationBar!]),
      bottomSheet: bottomSheet,
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      primary: primary,
      drawerDragStartBehavior: drawerDragStartBehavior,
      extendBody: extendBody,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      drawerScrimColor: drawerScrimColor,
      drawerEdgeDragWidth: drawerEdgeDragWidth,
      drawerEnableOpenDragGesture: drawerEnableOpenDragGesture,
      endDrawerEnableOpenDragGesture: endDrawerEnableOpenDragGesture,
      restorationId: restorationId,
    );
  }
}

class _MiniPlayer extends StatelessWidget {
  const _MiniPlayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UniversalAudioPlayer>(builder: (context, player, _) {
      if (!player.hasSource) {
        return const SizedBox();
      } else {
        final Episode source = player.source!;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: ListTile(
              dense: true,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              tileColor: Colors.grey.shade800,
              contentPadding: const EdgeInsets.symmetric(horizontal: 6),
              leading: Hero(
                tag: source,
                child: source.imageUrl == null
                    ? ImgPlaceholder(preffredLetter: source.title[0])
                    : Image(
                        image: NetworkImage(source.imageUrl!),
                        frameBuilder:
                            (context, child, frame, wasSynchronouslyLoaded) =>
                                Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8)),
                          child: child,
                        ),
                      ),
              ),
              title: RichText(
                  text: TextSpan(text: source.title, children: [
                    TextSpan(
                        text: " - ${source.publicationDate?.displayFormat}",
                        style: Theme.of(context)
                            .textTheme
                            .labelSmall
                            ?.apply(color: Colors.grey))
                  ]),
                  maxLines: 1),
              subtitle: Text(
                source.description,
                maxLines: 1,
              ),
              trailing: IconButton(
                icon: player.isPlaying || player.loading
                    ? const Icon(Icons.pause_rounded)
                    : const Icon(Icons.play_arrow_rounded),
                onPressed: () {
                  player.togglePlay();
                },
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlayerScreen()),
                );
              },
            ),
          ),
        );
      }

      // Card(
      //   color: Colors.grey.shade800,
      //   margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
      //   child: const SizedBox(
      //     height: 50,
      //     width: double.maxFinite,
      //     child: Text(
      //       "Mini Player",
      //     ),
      //   ),
      // );
    });
  }
}
