import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/response/categoryListResponse.dart';
import '../../theme/CustomAppColor.dart';
import '../../utils/Util.dart';

class CategoryProductList extends StatelessWidget {
  final bool isLoading;
  final List<CategoryData?> categories;
  final double mediaWidth;
  final double screenHeight;
  final Color primaryColor;
  final Function(int) onProductTap;

  const CategoryProductList({
    Key? key,
    required this.isLoading,
    required this.categories,
    required this.mediaWidth,
    required this.screenHeight,
    required this.primaryColor,
    required this.onProductTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 2.0),
          child: GestureDetector(
            onTap: () => onProductTap(index),
            child: Card(
              margin: EdgeInsets.symmetric(horizontal: 3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              elevation: 1,
              shadowColor: Colors.white,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white),
                width: 60,
                padding: EdgeInsets.only(bottom: 8, top: 2, left: 2, right: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    categories[index]?.categoryImage == "" ||
                            categories[index]?.categoryImage == null
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(80),
                                color: primaryColor),
                            height: 50,
                            width: 50,
                            child: CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                              backgroundImage:
                                  AssetImage("assets/appLogo.png"),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                  color: Theme.of(context).cardColor,
                                  width: 0.3),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100.0),
                              child: Image.network(
                                "${categories[index]?.categoryImage}",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                                  return Container(
                                    height: 50,
                                    width: 50,
                                    child: CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.white,
                                      backgroundImage: AssetImage(
                                        "assets/appLogo.png",
                                      ),
                                    ),
                                  );
                                },
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.white38,
                                      highlightColor: Colors.grey,
                                      child: Container(
                                        height: 52,
                                        width: 52,
                                        color: Colors.white,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                            margin: EdgeInsets.only(top: 4),
                          ),
                    SizedBox(
                      height: 6,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Text(
                        capitalizeFirstLetter(
                            "${categories[index]?.categoryName}"),
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
