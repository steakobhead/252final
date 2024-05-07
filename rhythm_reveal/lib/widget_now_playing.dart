import 'package:flutter/material.dart';
import 'package:nowplaying/nowplaying.dart';
import 'package:provider/provider.dart';
import 'package:nowplaying/nowplaying_track.dart';

class NowPlayingWidget extends StatefulWidget {
  const NowPlayingWidget({super.key});

  @override
  _NowPlayingWidgetState createState() => _NowPlayingWidgetState();
}

class _NowPlayingWidgetState extends State<NowPlayingWidget> {
  NowPlaying? _nowPlaying;

  @override
  void initState() {
    super.initState();
    _initializeNowPlaying();
  }

  Future<void> _initializeNowPlaying() async {
    try {
      await NowPlaying.instance.start();
    } catch (e) {
      print('Failed to initialize NowPlaying: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<NowPlayingTrack>.value(
      initialData: NowPlayingTrack.loading,
      value: NowPlaying.instance.stream,
      child: Consumer<NowPlayingTrack>(builder: (context, track, _) {
        return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (track.isStopped) const Text('nothing playing'),
          if (!track.isStopped) ...[
            if (track.title != null) Text(track.title!.trim()),
            if (track.artist != null) Text(track.artist!.trim()),
            if (track.album != null) Text(track.album!.trim()),
            Text(track.state.toString()),
          ]
        ]);
      }),
    );
  }
}
