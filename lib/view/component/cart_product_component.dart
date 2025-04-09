import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/response/productListResponse.dart';
import '../../theme/CustomAppColor.dart';
import '../../utils/Util.dart';

class CartProductComponent extends StatelessWidget {
  final ProductData item;
  final double mediaWidth;
  final double itemTotalPrice;
  final double addOnTotalPrice;
  final bool isDarkMode;
  final double screenHeight;
  final Color primaryColor;
  final Function() onAddTap;
  final Function() onMinusTap;
  final Function() onRemoveTap;

  const CartProductComponent({
    Key? key,
    required this.item,
    required this.mediaWidth,
    required this.isDarkMode,
    required this.itemTotalPrice,
    required this.addOnTotalPrice,
    required this.screenHeight,
    required this.onAddTap,
    required this.onMinusTap,
    required this.onRemoveTap,
    required this.primaryColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 0.1,
            color: Colors.white,
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.07),

              offset: Offset(0, 1),
              // Adjust X and Yoffset to match Figma
              blurRadius: 5,
              spreadRadius: 0.6,
            ),
          ],
        ),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              item.imageUrl == "" || item.imageUrl == null
                  ? Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: primaryColor),
                      child: Image.asset(
                        "assets/appLogo.png",
                        height: 65,
                        width: 60,
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: Theme.of(context).cardColor, width: 0.3),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          "${item.imageUrl}",
                          height: 65,
                          width: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Container(
                              child: Image.asset(
                                "assets/appLogo.png",
                                height: 50,
                                width: 50,
                                fit: BoxFit.fitWidth,
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
                                  height: 65,
                                  width: 60,
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Container(
                  width: mediaWidth * 0.7,
                  child: Column(
                    children: [
                      Container(
                        //height: 90,
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              item.isBuy1Get1 == true
                                  ? Text(
                                      "Buy 1 GET 1",
                                      style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                    )
                                  : SizedBox(),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: mediaWidth * 0.5,
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Text(
                                            capitalizeFirstLetter(
                                              "${item.title}",
                                            ),
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        /* item?.productSizesList ==
                                                                "[]" || item?.productSizesList?.isEmpty == true ? */
                                        Text(' (\$${(item.price)})',
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[700]))
                                        //: SizedBox(),
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                      onTap: onRemoveTap,
                                      child: Align(
                                          alignment: Alignment.topRight,
                                          child: Icon(
                                            Icons.cancel,
                                            color: AppColor.Secondary,
                                            size: 24,
                                          ))),
                                ],
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          width: mediaWidth * 0.44,
                                          child: Text(
                                            item.getAddOnList()?.isEmpty == true
                                                ? capitalizeFirstLetter(
                                                    "${item.shortDescription}")
                                                : addOns(item),
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey[700]),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines:
                                                item.getAddOnList()?.isEmpty ==
                                                        true
                                                    ? 1
                                                    : 2,
                                          )),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                              '\$${itemTotalPrice.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600)),
                                          item.getAddOnList()?.isEmpty == true
                                              ? SizedBox()
                                              : Text(
                                                  '+\$${addOnTotalPrice.toStringAsFixed(2)}',
                                                  style: TextStyle(
                                                      fontSize: 13,
                                                      color: Colors.grey[600])),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 4,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),
                                      /* item?.productSizesList ==
                                                              "[]" || item?.productSizesList?.isEmpty == true ? */
                                      Row(
                                        children: [
                                          /*Text(
                                              'Quantity: ', style: TextStyle(fontSize: 12),),*/
                                          GestureDetector(
                                            child: Icon(
                                              Icons
                                                  .remove_circle_outline_rounded,
                                              size: 20,
                                              color: item.quantity == 0
                                                  ? Colors.grey
                                                  : Colors.red,
                                            ),
                                            onTap: onMinusTap,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Text(
                                            "${item.quantity.toString()}",
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          GestureDetector(
                                            child: Icon(
                                              Icons.add_circle_outlined,
                                              size: 20,
                                              color: AppColor.Primary,
                                            ),
                                            onTap: onAddTap,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  String addOns(ProductData item) {
    String text = "";
    item.getAddOnList().forEach((category) {
      if (category.addOnCategoryType == "multiple") {
        category.addOns?.forEach((addOn) {
          text = capitalizeFirstLetter("${addOn.name} ");
        });
      } else {
        category.addOns?.forEach((addOn) {
          text = capitalizeFirstLetter("${addOn.name} ");
        });
      }
    });
    return text;
  }
}
