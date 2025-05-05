import 'package:flutter/material.dart';

import '../../model/response/categoryListResponse.dart';
import '../../theme/CustomAppColor.dart';
import '../../utils/Util.dart';
import 'circluar_profile_image.dart';

class CategoryComponent extends StatefulWidget {
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
  _CategoryComponentState createState() => _CategoryComponentState();
}

class _CategoryComponentState extends State<CategoryComponent> {
  final ScrollController _scrollController = ScrollController();

  @override
  void didUpdateWidget(CategoryComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If selected category changed, scroll to start
    if (oldWidget.selectedCategory != widget.selectedCategory) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: widget.categories.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          var currentItem = widget.categories[index];
          var currentCategoryName = currentItem?.categoryName;
          return GestureDetector(
            onTap: () => widget.onTap(index),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: widget.selectedCategory == currentCategoryName
                    ? widget.primaryColor
                    : widget.isDarkMode ? AppColor.CardDarkColor : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(0, 0, 0, 0.06),
                    offset: Offset(0, 1),
                    blurRadius: 5,
                    spreadRadius: 0.1,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 4),
              margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProfileImage(
                    size: 25,
                    imageUrl: currentItem?.categoryImage,
                    name: "$currentCategoryName",
                    needTextLetter: true,
                    placeholderImage: "",
                    isDarkMode: widget.isDarkMode,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      capitalizeFirstLetter("$currentCategoryName"),
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: widget.selectedCategory == currentCategoryName
                            ? Colors.white
                            : widget.isDarkMode ? Colors.white : Colors.black,
                        fontWeight: widget.selectedCategory == currentCategoryName
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
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

