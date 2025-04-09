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
    return ListView.builder(
      itemCount: categories.length,
      scrollDirection: Axis.horizontal,
      itemBuilder: (context, index) {
        var currentItem = categories[index];
        var currentCategoryName = categories[index]?.categoryName;
        var currentCategoryImage = categories[index]?.categoryImage;
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
                    borderRadius: BorderRadius.circular(40),
                    color: isDarkMode
                        ? AppColor.CardDarkColor
                        : AppColor.GreyTextColor),
                width: 62,
                height: 60,
                margin: EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                //padding: EdgeInsets.only(bottom: 10, top: 10, left: 2, right: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProfileImage(
                        size: 60,
                        imageUrl: currentCategoryImage,
                        name: "${currentCategoryName}",
                        needTextLetter: true,
                        placeholderImage: "",
                        isDarkMode: isDarkMode),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Text(
                  capitalizeFirstLetter("${currentCategoryName}"),
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
