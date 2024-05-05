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
  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final isEnabled = await NowPlaying.instance.isEnabled();
    if (!isEnabled) {
      final shown = await NowPlaying.instance.requestPermissions();
      print('Permissions page shown: $shown');
    }
  }
  

  @override
  Widget build(BuildContext context) {
    return StreamProvider<NowPlayingTrack>.value(
      initialData: NowPlayingTrack.loading,
      value: NowPlaying.instance.stream,
      child: Consumer<NowPlayingTrack>(
        builder: (context, track, _) {
          // if (track == NowPlayingTrack.loading) return Container();
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (track.isStopped) Text('nothing playing'),
              if (!track.isStopped) ...[
                if (track.title != null) Text(track.title!.trim()),
                if (track.artist != null) Text(track.artist!.trim()),
                if (track.album != null) Text(track.album!.trim()),
                Text(track.state.toString()),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(8, 8, 8, 16),
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      color: Colors.grey,
                      ),
              ]),
                    Positioned(
                        bottom: 0, left: 8, child: Text(track.source!.trim())),
                  ],
                ]
              );
            }
          )
        );
    
      }
  }