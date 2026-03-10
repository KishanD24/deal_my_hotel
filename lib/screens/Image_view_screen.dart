import 'package:flutter/material.dart';
import '../components/app_bar_components.dart';
import '../extensions/extension_util/context_extensions.dart';
import 'package:photo_view/photo_view_gallery.dart';
import '../models/property_details_model.dart';
import '../utils/app_common.dart';
import '../utils/colors.dart';
import '../utils/constants.dart';

class ImageViewScreen extends StatefulWidget {
  final List<PropertyGallaryArray>? propertyGallery;

  ImageViewScreen({this.propertyGallery});

  @override
  _ImageViewScreenState createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: appBarWidget("", context1: context, bgColor: Colors.black),
      body: PhotoViewGallery.builder(
        itemCount: widget.propertyGallery!.length,
        scrollPhysics: BouncingScrollPhysics(),
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: Image.network(
              width: context.width(),
              color: scaffoldColorDark,
              widget.propertyGallery![index].url.toString(),
              loadingBuilder: (context, child, loadingProgress) {
                return commonCacheImageWidget('');
              },
            ).image,
          );
        },
        loadingBuilder: (context, event) => Center(
          child: Container(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              value: 2,
              valueColor: AlwaysStoppedAnimation(defaultLoaderAccentColorGlobal),
            ),
          ),
        ),
      ),
    );
  }
}
