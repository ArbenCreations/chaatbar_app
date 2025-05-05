import 'package:TheChaatBar/theme/CustomAppColor.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/response/productListResponse.dart';
import '../../utils/Util.dart';

class FeaturedProductComponent extends StatelessWidget {
  final ProductData data;
  final double mediaWidth;
  final bool isDarkMode;
  final int index;
  final double screenHeight;
  final Color primaryColor;
  final Function() onAddTap;
  final Function() onMinusTap;
  final Function() onPlusTap;

  const FeaturedProductComponent({
    Key? key,
    required this.data,
    required this.index,
    required this.isDarkMode,
    required this.mediaWidth,
    required this.screenHeight,
    required this.onAddTap,
    required this.onMinusTap,
    required this.onPlusTap,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/ProductDetailScreen", arguments: data);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0, horizontal: 10),
        child: Container(
          width: mediaWidth,
          padding: EdgeInsets.only(left: 10, top: 4, bottom: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.04),
                offset: Offset(0, 1),
                blurRadius: 1,
                spreadRadius: 0.1,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Section
                  Container(
                    width: mediaWidth * 0.2,
                    // Responsive width
                    height: mediaWidth * 0.2,
                    margin: EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: data.imageUrl == null ||
                            data.imageUrl?.isEmpty == true
                        ? Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Colors.grey[300]),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.asset(
                                "assets/appLogo.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl: "${data?.imageUrl}",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.white38,
                                highlightColor: Colors.grey,
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.12,
                                  width: double.infinity,
                                  color: Colors.white,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  _placeholderImage(),
                            ),
                          ),
                  ),

                  SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 6),
                        Text(
                          capitalizeFirstLetter(data.title ?? "Product"),
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          capitalizeFirstLetter(data.description ?? "Product"),
                          maxLines: 2,
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Price
                            Text(
                              "\$${data.price}",
                              style: TextStyle(
                                  fontSize: 18,
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold),
                            ),

                            Container(
                              child: data.quantity == 0
                                  ? GestureDetector(
                                      onTap: onPlusTap,
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(right: 10),
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                            color: AppColor.Secondary,
                                            borderRadius: BorderRadius.only(
                                                bottomRight:
                                                    Radius.circular(20),
                                                topLeft: Radius.circular(20))),
                                        child: Icon(Icons.add,
                                            size: 24, color: Colors.white),
                                      ),
                                    )
                                  : Card(
                                      color: AppColor.ButtonBackColor,
                                      elevation: 2,
                                      child: Container(
                                        margin: EdgeInsets.all(6),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            GestureDetector(
                                              child: Icon(Icons.remove,
                                                  size: 20,
                                                  color: Colors.white),
                                              onTap: onMinusTap,
                                            ),
                                            SizedBox(width: 4),
                                            Text(
                                              data.quantity.toString(),
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                            SizedBox(width: 4),
                                            GestureDetector(
                                              child: Icon(Icons.add,
                                                  size: 20,
                                                  color: Colors.white),
                                              onTap: onAddTap,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _placeholderImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColor.Primary,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Image.asset(
          "assets/app_logo.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }

// Helper method to build the card
}
