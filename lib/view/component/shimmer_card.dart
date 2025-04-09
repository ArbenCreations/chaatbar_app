import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: mediaWidth,
      height: 80,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        //controller: _scrollController,
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 5),
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Shimmer.fromColors(
              baseColor:isDarkMode? Colors.grey[800]! :Colors.grey[300]!,
              highlightColor:isDarkMode? Colors.grey[700]!: Colors.grey[100]!,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 4),
                width: mediaWidth / 1.7,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  margin: EdgeInsets.zero,
                ),
              ),
            ),
          );
          // I omit the part to build card items from the list
        },
      ),
    );
  }

  Widget _buildShimmerBox() {
    return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: 80,
            child: Center(
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  margin: EdgeInsets.zero),
            )
        )
    );
  }
}
