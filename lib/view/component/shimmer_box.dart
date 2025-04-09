import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBoxes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      margin: EdgeInsets.only(bottom: 12, top: 12),
      width: mediaWidth * 0.9,
      height: screenHeight * 0.16,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        margin: EdgeInsets.zero,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          //controller: _scrollController,
          itemCount: 2,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          // padding: const EdgeInsets.only(bottom: 5),
          itemBuilder: (BuildContext context, int index) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                //margin: EdgeInsets.symmetric(horizontal: 16),
                width: mediaWidth * 0.9,
                child: Card(
                  color: Colors.white.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  margin: EdgeInsets.zero,
                ),
              ),
            );
            // I omit the part to build card items from the list
          },
        ),
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
            )));
  }
}
