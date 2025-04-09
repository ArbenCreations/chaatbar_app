import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../theme/CustomAppColor.dart';

class CircularProfileImage extends StatelessWidget {
  late final String? imageUrl;
  late final String placeholderImage;
  late final double size;
  late final bool needTextLetter;
  late final String name;
  late final bool isDarkMode;

  CircularProfileImage({
    required this.imageUrl,
    required this.placeholderImage,
    required this.size,
    required this.needTextLetter,
    required this.name,
    required this.isDarkMode,
  });

  Widget build(BuildContext context) {
    String initial = "";
    if (needTextLetter) {
      initial = name.isNotEmpty && name != "null" ? name[0].toUpperCase() : '';
    }
    return imageUrl == ""
        ? needTextLetter
            ? Container(
                width: size, // Width of the round image
                height: size, // Height of the round image
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  shape: BoxShape.circle, // Make it circular
                ),
                child: Center(
                  child: Text(
                    initial,
                    style: TextStyle(
                      color: AppColor.Primary,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : Container(
                height: size,
                width: size,
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor:
                      isDarkMode ? AppColor.CardDarkColor : Colors.white,
                  backgroundImage: AssetImage(placeholderImage),
                ),
              )
        : Container(
            margin: EdgeInsets.only(top: size == 35 ?0 : 0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40.0),
              child: Image.network(
                imageUrl ?? "",
                height: size,
                width: size,
                fit: BoxFit.cover,
                errorBuilder: (BuildContext context, Object exception,
                    StackTrace? stackTrace) {
                  return needTextLetter
                      ? Container(
                          width: size, // Width of the round image
                          height: size, // Height of the round image
                          decoration: BoxDecoration(
                            color: Colors.blue[900], // Background color
                            shape: BoxShape.circle, // Make it circular
                          ),
                          child: Center(
                            child: Text(
                              initial,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          height: size,
                          width: size,
                          child: CircleAvatar(
                            radius: 30,
                            backgroundColor: isDarkMode
                                ? AppColor.CardDarkColor
                                : Colors.white,
                            backgroundImage: AssetImage(
                              placeholderImage,
                            ),
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
                        height: size,
                        width: size,
                        color: isDarkMode
                            ? AppColor.CardDarkColor
                            : Colors.white,
                      ),
                    );
                  }
                },
              ),
            ),
          );
  }
}
