import 'package:TheChaatBar/theme/CustomAppColor.dart';
import 'package:flutter/material.dart';

class ViewCartContainer extends StatefulWidget {
  late final int cartItemCount;
  late final String theme;
  late final Color primaryColor;
  late final AnimationController controller;

  ViewCartContainer(
      {required this.cartItemCount,
      required this.theme,
      required this.controller,
      required this.primaryColor});

  @override
  _ViewCartContainerState createState() => _ViewCartContainerState();
}

class _ViewCartContainerState extends State<ViewCartContainer>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _slideAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _slideAnimation =
        Tween<Offset>(begin: Offset(0, 1.0), end: Offset(0, 0)).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.easeInOut),
    );

    // Define the opacity animation for fade effect
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, "/CartScreen");
            },
            child: Stack(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 18, vertical: 22),
                  width: mediaWidth * 0.45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: AppColor.Secondary),
                  height: 55,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 4, vertical: 8),
                                child: Text(
                                  'View Cart',
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            //shape: BoxShape.circle,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: AppColor.Secondary,
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${widget.cartItemCount}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 6.0),
                                child: Text(
                                  'item/s',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                /* Positioned(
                  top: 0,
                  left: 1,
                  right: 1 ,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.grey.shade300, // Border color (optional)
                        width: 0.5,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.cartItemCount}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6.0),
                          child: Text(
                            'item/s',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
