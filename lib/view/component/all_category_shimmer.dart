import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AllCategoryShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: mediaWidth,
      height: MediaQuery.of(context).size.height,
      child: GridView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        //controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of items per row
          crossAxisSpacing: 10.0, // Space between grid items horizontally
          mainAxisSpacing: 10.0, // Space between grid items vertically
          childAspectRatio: 0.9, // Aspect ratio of the grid items
        ),
        itemCount: 5,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 5),
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor:
                    isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                child: Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(80),
                  ),
                  height: 70,
                  width: 70,
                  child: Card(
                    color: Colors.white.withOpacity(0.8),
                    shape: CircleBorder(),
                    margin: EdgeInsets.zero,
                  ),
                ),
              ),
              SizedBox(
                height: 3,
              ),
              Shimmer.fromColors(
                baseColor: isDarkMode ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor:
                    isDarkMode ? Colors.grey[700]! : Colors.grey[100]!,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 13),
                  width: 60,
                  height: 10,
                  child: Card(
                    color: Colors.white.withOpacity(0.8),
                    margin: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),
            ],
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
            )));
  }
}
