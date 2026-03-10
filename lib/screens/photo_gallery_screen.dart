import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import '../components/app_bar_components.dart';
import '../extensions/animatedList/animated_wrap.dart';
import '../extensions/extension_util/context_extensions.dart';
import '../extensions/extension_util/int_extensions.dart';
import '../extensions/extension_util/widget_extensions.dart';
import '../main.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../components/VideoPlayerScreen.dart';
import '../components/adMob_component.dart';
import '../extensions/decorations.dart';
import '../models/property_details_model.dart';
import '../utils/app_common.dart';
import '../utils/app_config.dart';
import '../utils/colors.dart';
import 'Image_view_screen.dart';
import 'YoutubePlayerScreen.dart';

class PhotoGalleyScreen extends StatefulWidget {
  final PropertyDetail? mPropertyDetail;

  PhotoGalleyScreen({required this.mPropertyDetail});

  @override
  State<PhotoGalleyScreen> createState() => _PhotoGalleyScreenState();
}

class _PhotoGalleyScreenState extends State<PhotoGalleyScreen> {
  String thumbnail = '';

  @override
  void initState() {
    super.initState();
  }

  String getYoutubeThumbnail(String url) {
    String? videoId = YoutubePlayer.convertUrlToId(url);
    thumbnail = "https://img.youtube.com/vi/$videoId/maxresdefault.jpg";
    return thumbnail;
  }

  bool validateYouTubeUrl(String? url) {
    if (url != null) {
      RegExp regExp = RegExp(r"(https?://)?(www\.)?(youtube\.com/watch\?v=|youtu\.be/)([a-zA-Z0-9_-]+)");
      return regExp.hasMatch(url);
    }
    return false;
  }

  void handleOnTap(String? url, String? img) {
    if (url!.contains("youtube.com") && validateYouTubeUrl(widget.mPropertyDetail!.videoUrl)) {
      YoutubeVideoScreen(url: url).launch(context);
    } else {
      VideoPlayerScreen(thumbnail: img, url: url).launch(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language.gallery, context1: context, titleSpace: 0),
      bottomNavigationBar: showBannerAdOnPhotoGallerySelected && userStore.isSubscribe == 0 ? showBannerAds(context) : SizedBox(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.mPropertyDetail!.videoUrl != null)
              Stack(
                alignment: Alignment.center,
                children: [
                  widget.mPropertyDetail!.videoUrl != null && widget.mPropertyDetail!.videoUrl.contains("youtube.com")
                      ? cachedImage(getYoutubeThumbnail(widget.mPropertyDetail!.videoUrl), fit: BoxFit.fill, height: context.height() * 0.25, width: context.width())
                          .cornerRadiusWithClipRRect(12)
                          .paddingSymmetric(horizontal: 16)
                      : cachedImage(widget.mPropertyDetail!.videoUrl, fit: BoxFit.fill, height: context.height() * 0.25, width: context.width()).paddingSymmetric(horizontal: 16),
                  InkWell(
                    onTap: () {
                      handleOnTap(widget.mPropertyDetail!.videoUrl, thumbnail);
                    },
                    child: widget.mPropertyDetail!.videoUrl.contains("youtube.com")
                        ? Icon(AntDesign.youtube, color: Colors.red, size: 36)
                        : Container(
                            height: 45,
                            width: 45,
                            decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: primaryColor),
                            child: Icon(Icons.play_arrow, color: Colors.white, size: 28),
                          ),
                  ).center(),
                ],
              ),
            if (widget.mPropertyDetail!.videoUrl != null) Divider(),
            AnimatedWrap(
              columnCount: 2,
              runSpacing: 8,
              spacing: 8,
              itemCount: widget.mPropertyDetail!.propertyGallaryArray!.length,
              children: List.generate(
                widget.mPropertyDetail!.propertyGallaryArray!.length,
                (i) {
                  return cachedImage(widget.mPropertyDetail!.propertyGallaryArray![i].url, fit: BoxFit.cover, height: context.height() * 0.2, width: (context.width() - 40) / 2)
                      .cornerRadiusWithClipRRect(12)
                      .onTap(() {
                    ImageViewScreen(propertyGallery: widget.mPropertyDetail!.propertyGallaryArray).launch(context);
                  });
                },
              ),
            ).paddingSymmetric(horizontal: 16),
            16.height.visible(widget.mPropertyDetail!.propertyGallaryArray!.isNotEmpty),
          ],
        ),
      ),
    );
  }
}
