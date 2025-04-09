import 'package:flutter/material.dart';

import '../../model/response/categoryListResponse.dart';
import '../../theme/CustomAppColor.dart';
import '../../utils/Util.dart';
import 'circluar_profile_image.dart';

class CategoryComponent extends StatelessWidget {
  final List<CategoryData?> categories;
  final double mediaWidth;
  final double screenHeight;
  final Color primaryColor;
  final bool isDarkMode;
  final String? selectedCategory;
  final Function(int index) onTap;

  const CategoryComponent({
    Key? key,
    required this.categories,
    required this.mediaWidth,
    required this.screenHeight,
    required this.onTap,
    required this.primaryColor,
    required this.isDarkMode,
    required this.selectedCategory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        itemCount: categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var currentItem = categories[index];
          var currentCategoryName = categories[index]?.categoryName;
          return GestureDetector(
            onTap: () {
              onTap(index);
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selectedCategory == currentCategoryName
                      ? primaryColor
                      : isDarkMode?  AppColor.CardDarkColor :Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.06),

                    offset: Offset(0, 1),
                    // Adjust X and Yoffset to match Figma
                    blurRadius: 5,
                    // Adjust this for more/less blur
                    spreadRadius: 0.1,
                  ),
                ],),
              padding: EdgeInsets.symmetric(horizontal: 4),
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProfileImage(
                    size: 25,
                    imageUrl: currentItem?.categoryImage,
                    name: "${currentCategoryName}",
                    needTextLetter: true,
                    placeholderImage: "",
                    isDarkMode: isDarkMode
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      capitalizeFirstLetter("${currentCategoryName}"),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12,
                          color: selectedCategory == currentCategoryName
                              ? Colors.white
                              : isDarkMode? Colors.white : Colors.black,
                          fontWeight: selectedCategory == currentCategoryName
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
