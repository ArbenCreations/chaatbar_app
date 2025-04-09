import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/response/productListResponse.dart';
import '../../theme/CustomAppColor.dart';
import '../../utils/Util.dart';

class ProductComponent extends StatelessWidget {
  final ProductData item;
  final double mediaWidth;
  final bool isDarkMode;
  final double screenHeight;
  final Color primaryColor;
  final bool showFavIcon;
  final Function() onAddTap;
  final Function() onMinusTap;
  final Function() onPlusTap;
  final Function() onFavoriteTap;

  const ProductComponent({
    Key? key,
    required this.item,
    required this.mediaWidth,
    required this.isDarkMode,
    required this.screenHeight,
    required this.onAddTap,
    required this.showFavIcon,
    required this.onMinusTap,
    required this.onPlusTap,
    required this.onFavoriteTap,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/ProductDetailScreen", arguments: item);
      },
      child: Container(
        width: (mediaWidth / 2) - 20,
        margin: EdgeInsets.only(top: 3, bottom: 4),
        padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            item.imageUrl == "" || item.imageUrl == null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: primaryColor,
                    ),
                    child: ClipRRect(
                      // Ensures rounded corners apply to the image
                      borderRadius: BorderRadius.circular(20),
                      child: Image.asset(
                        "assets/appLogo.png",
                        height: screenHeight * 0.15,
                        width: double.infinity,
                        fit: BoxFit
                            .cover, // Use BoxFit.cover to maintain aspect ratio and fill the container
                      ),
                    ),
                  )
                : Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                              color: Theme.of(context).focusColor, width: 0.3),
                          color: isDarkMode
                              ? AppColor.CardDarkColor
                              : Colors.white,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            "${item.imageUrl}",
                            height: screenHeight * 0.15,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (BuildContext context,
                                Object exception, StackTrace? stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Image.asset(
                                  "assets/appLogo.png",
                                  height: screenHeight * 0.15,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              );
                            },
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: Colors.white38,
                                  highlightColor: Colors.grey,
                                  child: Container(
                                    height: screenHeight * 0.165,
                                    width: double.infinity,
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Container(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: item.quantity == 0
                                ? GestureDetector(
                                    onTap: () {
                                      onAddTap();
                                    },
                                    child: Card(
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 5, vertical: 5),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30)),
                                      color: isDarkMode
                                          ? AppColor.CardDarkColor
                                          : Colors.white,
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        child: Center(
                                          child: Text(
                                            "+",
                                            style: TextStyle(
                                                fontSize: 23,
                                                color: primaryColor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: item.quantity == 0
                                ? SizedBox()
                                : Card(
                                    child: Container(
                                      margin: EdgeInsets.all(6),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 4, vertical: 2),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          color: isDarkMode
                                              ? AppColor.CardDarkColor
                                              : Colors.white),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            child: Icon(
                                              Icons.remove,
                                              size: 18,
                                              color: primaryColor,
                                            ),
                                            onTap: () {
                                              onMinusTap();
                                            },
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            item.quantity.toString(),
                                            style: TextStyle(fontSize: 12),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          GestureDetector(
                                            child: Icon(
                                              Icons.add,
                                              size: 18,
                                              color: primaryColor,
                                            ),
                                            onTap: () {
                                              onPlusTap();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      /*    showFavIcon
                          ? Container(
                              width: double.infinity,
                              height: screenHeight * 0.165,
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: GestureDetector(
                                  onTap: () {
                                    onFavoriteTap();
                                  },
                                  child: item.favorite ?? true
                                      ? Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(35),
                                              color: AppColor.Secondary),
                                          padding: EdgeInsets.all(6),
                                          margin: EdgeInsets.all(4.5),
                                          child: Icon(
                                            Icons.favorite,
                                            size: 14,
                                            color: Colors.white,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(6.0),
                                          child: Icon(
                                            Icons.favorite,
                                            size: 22,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                              ))
                          : SizedBox(),*/
                      item.isBuy1Get1 == true
                          ? Container(
                              width: double.infinity,
                              height: screenHeight * 0.165,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                    margin: EdgeInsets.symmetric(
                                        horizontal: 6, vertical: 6),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 3, vertical: 3),
                                    decoration: BoxDecoration(
                                        color: AppColor.Primary,
                                        borderRadius: BorderRadius.circular(5)),
                                    child: Text(
                                      "Buy 1 GET 1",
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    )),
                              ))
                          : SizedBox()
                    ],
                  ),
            //SizedBox(height: 2,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 5),
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: mediaWidth * 0.25,
                        child: Text(
                          capitalizeFirstLetter("${item.title}"),
                          maxLines: 1,
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        //width: mediaWidth * 0.13,
                        child: Text(
                          "\$${item.price}",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                      )
                    ],
                  ),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 1.8,
                          height: double.infinity,
                          // Set to null so it can adjust dynamically
                          color: primaryColor,
                          margin:
                              EdgeInsets.only(right: 5, top: 3.5, bottom: 3.5),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: Text(
                              capitalizeFirstLetter('${item.shortDescription}'),
                              style: TextStyle(
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // SizedBox(height: 24,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper method to build the card
}
