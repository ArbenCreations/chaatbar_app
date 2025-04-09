import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/CustomAppColor.dart';

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
        itemCount: 1,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        padding: const EdgeInsets.only(bottom: 5),
        itemBuilder: (BuildContext context, int index) {
          return  GridView.builder(
            gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 5 items per row
                crossAxisSpacing: 2,
                mainAxisSpacing: 1,
                childAspectRatio: 0.87),
            padding: EdgeInsets.symmetric(
                horizontal: 8, vertical: 18),
            itemCount: 5,
            itemBuilder: (context, index) {
              return Container(
                  width: 110,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200]
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  padding: EdgeInsets.symmetric(
                      vertical: 8, horizontal: 4),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    crossAxisAlignment:
                    CrossAxisAlignment.center,
                    children: [Container(
                        decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(
                              80),),
                        height: 70,
                        width: 70,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor:
                          Colors.white,
                          backgroundImage: AssetImage(
                              "assets/appLogo.png"),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Shimmer.fromColors(
                        baseColor:isDarkMode? Colors.grey[800]! :Colors.grey[300]!,
                        highlightColor:isDarkMode? Colors.grey[700]!: Colors.grey[100]!,
                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 4),
                          width: 105,
                          height: 20,
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            margin: EdgeInsets.zero,
                          ),
                        ),
                      )
                    ],
                  ));
            },
          );
          // I omit the part to build card items from the list
        },
      ),
    );
  }

}
