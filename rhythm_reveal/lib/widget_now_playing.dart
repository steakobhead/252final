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
  Widget build(BuildContext context)
  {
  return StreamProvider<NowPlayingTrack>.value(
    value: NowPlaying.instance.stream,
    initialData: NowPlayingTrack(
        title: 'Unknown',
        artist: 'Unknown',
        album: 'Unknown',
      ),
    child: Scaffold(
        body: Consumer<NowPlayingTrack>(
          builder: (context, track, _) {
            return Container(
              child: Text('Current Song: ${track.title}'),
            );
          }
        )
      )
    );
  }
}

