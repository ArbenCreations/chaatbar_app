import 'package:flutter/material.dart';

import '../../model/response/categoryListResponse.dart';
import '../../model/response/vendorListResponse.dart';
import '../../theme/CustomAppColor.dart';
import '../../utils/Util.dart';
import 'circluar_profile_image.dart';

class DashboardCategoryComponent extends StatelessWidget {
  final List<CategoryData?> categories;
  final double mediaWidth;
  final double screenHeight;
  final Color primaryColor;
  final bool isDarkMode;
  final VendorData? vendorData;

  const DashboardCategoryComponent({
    Key? key,
    required this.categories,
    required this.mediaWidth,
    required this.screenHeight,
    required this.primaryColor,
    required this.isDarkMode,
    required this.vendorData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaWidth = MediaQuery.of(context).size.width;
    double avatarSize = mediaWidth * 0.11;
    double fontSize = mediaWidth * 0.022;
    return SizedBox(
      height: 150,
      child: GridView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // two rows
          mainAxisSpacing: 0,
          crossAxisSpacing: 6,
          childAspectRatio: 0.9,
        ),
        padding: EdgeInsets.symmetric(horizontal: 8),
        itemBuilder: (context, index) {
          var currentItem = categories[index];
          var currentCategoryName = currentItem?.categoryName;
          var currentCategoryImage = currentItem?.categoryImage;

          return GestureDetector(
            onTap: () {
              VendorData? data = vendorData;
              data?.detailType = "menu";
              data?.selectedCategoryId = currentItem?.id;
              Navigator.pushNamed(context, "/MenuScreen", arguments: data);
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(avatarSize),
                    color: isDarkMode
                        ? AppColor.CardDarkColor
                        : AppColor.GreyTextColor,
                  ),
                  width: avatarSize,
                  height: avatarSize,
                  child: Center(
                    child: CircularProfileImage(
                      size: avatarSize,
                      imageUrl: currentCategoryImage,
                      name: "$currentCategoryName",
                      needTextLetter: true,
                      placeholderImage: "",
                      isDarkMode: isDarkMode,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.006),
                Text(
                  capitalizeFirstLetter("$currentCategoryName"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
