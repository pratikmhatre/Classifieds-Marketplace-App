import 'package:cached_network_image/cached_network_image.dart';
import 'package:digigad/resources/data/network/response/images.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ViewImagesView extends StatefulWidget {
  final List<Images> imageList;

  ViewImagesView(this.imageList);

  @override
  _ViewImagesViewState createState() => _ViewImagesViewState(imageList);
}

class _ViewImagesViewState extends State<ViewImagesView> {
  final List<Images> _imageList;
  late PageController _pageController;

  _ViewImagesViewState(this._imageList);

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          PageView.builder(
              controller: _pageController,
              itemCount: _imageList.length,
              scrollDirection: Axis.horizontal,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return Container(
                  child: Center(
                    child: PhotoView(
                      imageProvider: CachedNetworkImageProvider(
                        _imageList[index].imgKey,
                      ),
                    ),
                  ),
                );
              }),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(bottom: 70),
              child: SmoothPageIndicator(
                controller: _pageController,
                effect: SlideEffect(
                    dotHeight: 10,
                    dotWidth: 10,
                    spacing: 8,
                    activeDotColor: Colors.redAccent),
                count: _imageList.length,
              ),
            ),
          )
        ],
      ),
    );
  }
}
