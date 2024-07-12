import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:podcast_search/podcast_search.dart';

class UniversalAudioPlayer extends ChangeNotifier {
  UniversalAudioPlayer();

  final AudioPlayer player = AudioPlayer();

  Future<void> setAudio(Episode newSource) async {
    if (newSource.contentUrl == null) {
      return;
    }
    if (source != null && newSource.contentUrl == source!.contentUrl) {
      togglePlay();
    } else {
      _loading = true;
      notifyListeners();
      await player.pause();
      _source = newSource;
      await player.setUrl(source!.contentUrl!, preload: false);
      await player.play();
      _loading = false;
      notifyListeners();
    }
  }

  bool _loading = false;
  bool get loading => _loading;
  Episode? _source;
  Episode? get source => _source;

  bool get hasSource => source != null;
  bool get isPlaying => player.playing;
  Duration? get duration => player.duration;
  Duration? get currentDuration => player.position;
  Stream<Duration> get positionStream => player.positionStream;
  void togglePlay() {
    if (hasSource) {
      if (player.playing) {
        player.pause();
      } else {
        player.play();
      }
      notifyListeners();
    }
  }

  void seek(Duration d) {
    player.seek(d);
  }

  void notif() => notifyListeners();
}
