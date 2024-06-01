import 'package:digigad/resources/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerView extends StatefulWidget {
  @override
  _YoutubePlayerViewState createState() => _YoutubePlayerViewState();
}

class _YoutubePlayerViewState extends State<YoutubePlayerView> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
        initialVideoId: '4AOG-xsSA9I',
        flags: YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
          child: YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller,
                thumbnail: Image.asset('images/banner.png'),
                showVideoProgressIndicator: true,
                bottomActions: [
                  CurrentPosition(),
                  ProgressBar(isExpanded: true),
                ],
                onEnded: (meta) => Navigator.pop(context),
                progressIndicatorColor: AppConstants.colorPrimary,
              ),
              builder: (context, player) {
                return Container(
                  height: height,
                  child: player,
                );
              })),
    );
  }
}
