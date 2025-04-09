import 'dart:async';

import 'package:TheChaatBar/model/response/bannerListResponse.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Import CachedNetworkImage
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '/view/component/shimmer_box.dart';
import '../../theme/CustomAppColor.dart';

class BannerListWidget extends StatefulWidget {
  final List<BannerData> data;
  final bool isInternetConnected;
  final bool isLoading;
  final bool isDarkMode;

  BannerListWidget({
    required this.data,
    required this.isInternetConnected,
    required this.isLoading,
    required this.isDarkMode,
  });

  @override
  _BannerListWidgetState createState() => _BannerListWidgetState();
}

class _BannerListWidgetState extends State<BannerListWidget> {
  late PageController _pageController;
  late Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _timer = Timer.periodic(Duration(seconds: 5), _onTimerTick);
  }

  void _onTimerTick(Timer timer) {
    if (_pageController.hasClients) {
      setState(() {
        _currentPage = (_currentPage + 1) % widget.data.length;
      });

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildBannerImage(int index, double mediaWidth, double screenHeight) {
    final banner = widget.data[index];
    final image = banner.bannerImages.toString().isEmpty
        ? "assets/appLogo.png"
        : banner.bannerImages;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).cardColor, width: 0.1),
        color: widget.isDarkMode ? AppColor.CardDarkColor : Colors.white,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: image.toString().isEmpty
            ? Image.asset(
                image!,
                width: mediaWidth * 0.95,
                height: screenHeight * 0.25,
                fit: BoxFit.none,
              )
            : CachedNetworkImage(
                imageUrl: image!,
                width: mediaWidth * 0.95,
                height: screenHeight * 0.25,
                fit: BoxFit.cover,
                placeholder: (context, url) {
                  return Shimmer.fromColors(
                    baseColor: Colors.white38,
                    highlightColor: widget.isDarkMode
                        ? AppColor.CardDarkColor
                        : Colors.grey,
                    child: Container(
                      width: mediaWidth * 0.95,
                      height: screenHeight * 0.25,
                      decoration: BoxDecoration(
                        color: widget.isDarkMode
                            ? AppColor.CardDarkColor
                            : Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                  );
                },
                errorWidget: (context, url, error) {
                  return Image.asset(
                    "assets/appLogo.png",
                    width: mediaWidth * 0.95,
                    height: screenHeight * 0.22,
                    fit: BoxFit.none,
                  );
                },
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double mediaWidth = MediaQuery.of(context).size.width;

    if (!widget.isInternetConnected || widget.isLoading) {
      return ShimmerBoxes();
    }

    if (widget.data.isEmpty) {
      return SizedBox(height: 8);
    }

    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 0, top: 8),
          width: mediaWidth,
          height: screenHeight * 0.2,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (page) => setState(() => _currentPage = page),
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: widget.data.length,
            itemBuilder: (context, index) {
              return Container(
                width: mediaWidth * 0.95,
                child: Center(
                  child: Card(
                    color: Colors.white.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    margin: EdgeInsets.zero,
                    child: Stack(
                      children: [
                        _buildBannerImage(index, mediaWidth, screenHeight)
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Positioned(
          bottom: 0,
          left: 22,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.black54,
            ),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: widget.data.length,
              effect: WormEffect(
                dotHeight: 5.0,
                dotWidth: 5.0,
                spacing: 5.0,
                dotColor: Colors.white70,
                activeDotColor: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
