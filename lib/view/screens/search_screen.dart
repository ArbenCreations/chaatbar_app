import 'package:TheChaatBar/languageSection/Languages.dart';
import 'package:TheChaatBar/model/request/globalSearchRequest.dart';
import 'package:TheChaatBar/model/response/globalSearchResponse.dart';
import 'package:TheChaatBar/theme/CustomAppColor.dart';
import 'package:floor/floor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../model/apis/apiResponse.dart';
import '../../model/response/vendorListResponse.dart';
import '../../utils/Util.dart';
import '../../model/viewModel/mainViewModel.dart';
import '../component/connectivity_service.dart';

class GlobalSearchDelegate extends SearchDelegate {

  late String initialQuery;

  GlobalSearchDelegate( {required this.initialQuery}) {
    print("initialQuery${initialQuery}");
    query = initialQuery; // Set the initial query

  }

  List<dynamic> _productResults = [];
  List<dynamic> _vendorResults = [];

  List<dynamic> _searchResults =[];
  var _connectivityService = ConnectivityService();
  static const maxDuration = Duration(seconds: 2);
  // This method is called when the user submits a search query.
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          FocusScope.of(context).unfocus();
          query = '';
          showSuggestions(context);// Clear the search field
        },
      ),
    ];
  }

  // This method is called to show a back button on the app bar.
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null); // Close the search bar
      },
    );
  }

  // This method is called to build the search results based on the query.
  @override
  Widget buildResults(BuildContext context) {
    // Run your API with the query
    return _buildSearchResultList(context);
  }

  // This method is called to show search suggestions when the user types.
  @override
  Widget buildSuggestions(BuildContext context) {

    if (query.isEmpty) {
      query = initialQuery;
      if(query.isNotEmpty) {
        Future.microtask(() => showSuggestions(context));
        initialQuery = '';
      }
    }

    if (query.isNotEmpty && query.length >= 3) {
      return FutureBuilder<List<dynamic>>(
        future: fetchSearchResults(query, context), // Hit the API when query is more than 4 characters
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No suggestions.'));
          } else {
            _productResults.clear();
            _vendorResults.clear();

            // Separate the results
            snapshot.data!.forEach((result) {
              if (result?.product != null) {
                _productResults.add(result);
              }
              if (result?.vendor != null) {
                bool exist = doesVendorExist(_vendorResults,result);
                if (!exist) {
                      _vendorResults.add(result);
                }
              }
            });

            return _buildSearchResultList(context);
          }
        },
      );
    } else {
      // Return an empty widget or some initial content if query is less than 4 characters
      return Center(child: Text('Search'));
    }
  }

  Widget _buildSearchResultList(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Slider (PageView)
          if (_productResults.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Products",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.builder(
                //shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                //physics: NeverScrollableScrollPhysics(),
                itemCount: _productResults.length,
                itemBuilder: (context, index) {
                  final product = _productResults[index];
                  return _buildProductCard(product, index, context);
                },
              ),
            ),
            SizedBox(height: 24), // Add space before vendors section
          ],

          // Vendors List
          if (_vendorResults.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Vendors",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _vendorResults.length,
              itemBuilder: (context, index) {
                final vendor = _vendorResults[index];
                return _buildResultTile(vendor, context);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic result, int index, BuildContext context) {
    String? imageUrl = result.product?.image1 ?? result.vendor?.vendorImage;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: GestureDetector(
            onTap: () {
              // Handle tap on search result
              VendorData data = result?.vendor;
              Navigator.pushReplacementNamed(context, "/HomeScreen", arguments:  data);
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.42,
              //margin: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
              //padding: EdgeInsets.symmetric(vertical: 5, horizontal: 4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                //border: Border.all(color: Colors.black, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      imageUrl == null || imageUrl.isEmpty
                          ? ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(15),
                                      topLeft: Radius.circular(15)),
                              //padding: EdgeInsets.all(6),
                              child: Image.asset(
                                "assets/appLogo.png",
                                height: 80,
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              ),
                            )
                          : ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15)),
                              child: Image.network(
                               imageUrl,
                                height: 80,
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                                errorBuilder: (BuildContext
                                context,
                                    Object exception,
                                    StackTrace? stackTrace) {
                                  return Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(15),
                                            topLeft: Radius.circular(15)),
                                        color: Colors.grey),
                                    child: Image.asset(
                                      "assets/appLogo.png",
                                      height: 80,
                                      width: double.infinity,
                                      fit: BoxFit.fitWidth,
                                    ),
                                  );
                                },
                                loadingBuilder:
                                    (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent?
                                    loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return Shimmer.fromColors(
                                      baseColor: Colors.white38,
                                      highlightColor:
                                      Colors.grey,
                                      child: Container(
                                        height: 80,
                                        width: double.infinity,
                                      ),
                                    );
                                  }
                                },
                              ),
                            ),
                      result.product != null
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                                height: 32,
                                width: 32,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: AppColor.Primary),
                                child: Center(
                                  child: Text(
                                    "\$${result.product?.price ?? ""}",
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                  SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          result?.product?.title ,
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        if (result.product != null)
                          Text(
                            result?.product?.shortDescription ?? '',
                            style: TextStyle(fontSize: 10),
                          ),
                        //Spacer(),
                        Text(
                          result?.vendor?.businessName ?? '',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColor.Primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
    /* },
    );*/
  }

  Widget _buildResultTile(dynamic result, BuildContext context) {
    return GestureDetector(
          onTap: (){
            VendorData data = result?.vendor;
            hideKeyBoard();
            Navigator.pushReplacementNamed(context, "/HomeScreen", arguments:  data);
          },
          child: Container(
            height: MediaQuery.of(context).size.height*0.15,
            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 3),

            padding: EdgeInsets.symmetric( vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              //border: Border.all(color: Colors.black, width: 0.5)
              color: Colors.grey[100]
            ),
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Card(
                  elevation: 15,
                  child:
                  result?.vendor?.vendorImage == "" || result?.product?.image1 == ""
                      ? ClipRRect(
                    borderRadius:
                    BorderRadius.circular(12),
                    child: Image.asset(
                      "assets/appLogo.png",
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width*0.29,
                      fit: BoxFit.fitHeight,
                    ),
                  )
                      : ClipRRect(
                    borderRadius:
                    BorderRadius.circular(12),
                    child: Image.network(
                      "${result?.vendor?.vendorImage}" ,
                      height: double.infinity,
                      width: MediaQuery.of(context).size.width*0.29,
                      fit: BoxFit.fitHeight,
                      errorBuilder: (BuildContext
                      context,
                          Object exception,
                          StackTrace? stackTrace) {
                        return ClipRRect(
                          borderRadius:
                          BorderRadius.circular(12),
                          child: Image.asset(
                            "assets/appLogo.png",
                            height: double.infinity,
                            width: MediaQuery.of(context).size.width*0.29,
                            fit: BoxFit.fitHeight,
                          ),
                        );
                      },
                      loadingBuilder:
                          (BuildContext context,
                          Widget child,
                          ImageChunkEvent?
                          loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        } else {
                          return Shimmer.fromColors(
                            baseColor: Colors.white38,
                            highlightColor:
                            Colors.grey,
                            child: Container(
                              height: double.infinity,
                              width: MediaQuery.of(context).size.width*0.29,
                              color: Colors.white,
                            ),
                          );
                        }
                      },
                    ),
                  )
                  ,
                ),


                SizedBox(width: 8,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 10),
                  child: Container(
                    width: MediaQuery.of(context).size.width*0.535,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(result.vendor?.businessName,style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                        SizedBox(height: 8,),
                        Text(result.vendor?.description ?? "",style: TextStyle(fontSize: 12,fontWeight: FontWeight.w500, color: AppColor.Primary),),
                        Spacer(),
                        Align(
                            alignment: Alignment.bottomRight,
                            child: Icon(Icons.favorite_border_sharp, ))
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 5,),
                //Icon(Icons.call_made)
              ],
            ),
          ),
        ) ;

  }

  bool doesVendorExist(List<dynamic> searchItems, SearchItemDetails newItem) {
    return searchItems.any((item) => item.vendor?.businessName == newItem.vendor?.businessName);
  }

  Future<List<SearchItemDetails>> fetchSearchResults(String query, BuildContext context) async {

        bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
            Text('${Languages.of(context)?.labelNoInternetConnection}'),
            duration: maxDuration,
          ),
        );
        return [];
    } else {
      await Future.delayed(Duration(milliseconds: 2));
      GlobalSearchRequest request =
      GlobalSearchRequest(query: query);
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchGlobalSearchResults("/api/v1/products/global_filter", request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context , listen: false).response;
      return getProductList(context , apiResponse) ?? [];
    }
  }

  List<SearchItemDetails>? getProductList(BuildContext context, ApiResponse apiResponse) {
    GlobalSearchResponse? globalSearchResponse =
    apiResponse.data as GlobalSearchResponse?;
    var message = apiResponse.message.toString();

    switch (apiResponse.status) {
      case Status.LOADING:

        return globalSearchResponse?.data;
      case Status.COMPLETED:
        print("rwrwr ${globalSearchResponse?.data?[0].product?.title}");
        //hideKeyBoard();

        return globalSearchResponse?.data; // Return an empty container as you'll navigate away
      case Status.ERROR:
        return globalSearchResponse?.data;
      case Status.INITIAL:
      default:
        return globalSearchResponse?.data;
    }
  }
}

