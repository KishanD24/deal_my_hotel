import 'package:flutter/material.dart';
import '../components/app_bar_components.dart';
import '../extensions/extension_util/widget_extensions.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoScreen extends StatefulWidget {
  final String? url;

  YoutubeVideoScreen({this.url});

  @override
  State<YoutubeVideoScreen> createState() => _YoutubeVideoScreenState();
}

class _YoutubeVideoScreenState extends State<YoutubeVideoScreen> {
  late YoutubePlayerController youtubePlayerController;
  late TextEditingController idController;
  late TextEditingController seekToController;
  late PlayerState playerState;
  late YoutubeMetaData videoMetaData;
  bool _isPlayerReady = false;
  String videoId = '';

  bool visibleOption = true;


  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  Future<void> initializePlayer() async {

    videoId = YoutubePlayer.convertUrlToId(widget.url.toString())!;
    youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    )..addListener(listener);
    idController = TextEditingController();
    seekToController = TextEditingController();
    videoMetaData = const YoutubeMetaData();
    playerState = PlayerState.unknown;

    setState(() {});
  }

  void listener() {
    if (_isPlayerReady && mounted && !youtubePlayerController.value.isFullScreen) {
      setState(() {
        playerState = youtubePlayerController.value.playerState;
        videoMetaData = youtubePlayerController.metadata;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("", context1: context, bgColor: Colors.black),
      backgroundColor: Colors.black,
      body: YoutubePlayer(
        controller: youtubePlayerController,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.white,
        progressColors: ProgressBarColors(
          playedColor: Colors.white,
          bufferedColor: Colors.grey.shade200,
          handleColor: Colors.white,
          backgroundColor: Colors.grey,
        ),

        // topActions: <Widget>[
        //   if (MediaQuery.of(context).orientation == Orientation.landscape)
        //     Align(
        //       alignment: Alignment.topRight,
        //       child: IconButton(
        //         padding: EdgeInsets.only(top: context.statusBarHeight + 20),
        //         icon: const Icon(Icons.close, color: Colors.white, size: 25.0),
        //         onPressed: () {
        //           exitScreen();
        //         },
        //       ),
        //     ),
        // ],
        onReady: () {
          _isPlayerReady = true;
        },
        onEnded: (data) {
          //
        },
      ).center(),
    );
  }
}
