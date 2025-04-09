import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: mediaWidth,
      child: Container(
        child: GridView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          //controller: _scrollController,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items per row
            crossAxisSpacing: 10.0, // Space between grid items horizontally
            mainAxisSpacing: 10.0, // Space between grid items vertically
            childAspectRatio: 0.9, // Aspect ratio of the grid items
          ),
          itemCount: 4,
          shrinkWrap: true,
          padding: const EdgeInsets.only(bottom: 5),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Shimmer.fromColors(
                  baseColor:isDarkMode? Colors.grey[800]! :Colors.grey[300]!,
                  highlightColor:isDarkMode? Colors.grey[700]!: Colors.grey[100]!,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.165,
                    child: Card(
                      color: Colors.white
                          .withOpacity(0.8),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(
                              12.5)),
                      margin: EdgeInsets.zero,
                    ),
                  ),
                ),
                SizedBox(height: 3,),
                Shimmer.fromColors(
                  baseColor:isDarkMode? Colors.grey[800]! :Colors.grey[300]!,
                  highlightColor:isDarkMode? Colors.grey[700]!: Colors.grey[100]!,
                  child: Container(

                    margin: EdgeInsets.symmetric(horizontal: 13),
                    width: (MediaQuery.of(context)
                        .size
                        .width / 2) - 55,
                    height:12,
                    child: Card(
                      color: Colors.white
                          .withOpacity(0.8),

                      margin: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                  ),
                ),
              ],
            );
            // I omit the part to build card items from the list
          },
        ),
      ),
    );
  }

}
