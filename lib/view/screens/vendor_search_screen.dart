import 'package:TheChaatBar/languageSection/Languages.dart';
import 'package:TheChaatBar/model/request/vendorSearchRequest.dart';
import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:TheChaatBar/model/response/vendorSearchResponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/apis/apiResponse.dart';
import '../../model/viewModel/mainViewModel.dart';
import '../../theme/CustomAppColor.dart';
import '../../utils/Helper.dart';
import '../../utils/Util.dart';
import '../component/connectivity_service.dart';
import '../component/product_component.dart';

class VendorSearchDelegate extends SearchDelegate {
  late String initialQuery;
  late bool isDarkMode;

  VendorSearchDelegate({
    required this.initialQuery,
    required this.isDarkMode,
  }) {
    print("initialQuery${initialQuery}");
    query = initialQuery; // Set the initial query
  }

  List<dynamic> _productResults = [];
  List<dynamic> _vendorResults = [];
  int vendorId = 0;

  List<dynamic> _searchResults = [];
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
          showSuggestions(context); // Clear the search field
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
    Helper.getVendorDetails().then((onValue) {
      vendorId = int.parse("${onValue?.id}"); //?? VendorData();
      // setThemeColor();
    });
    if (query.isEmpty) {
      query = initialQuery;
      if (query.isNotEmpty) {
        Future.microtask(() => showSuggestions(context));
        initialQuery = '';
      }
    }

    if (query.isNotEmpty && query.length >= 3) {
      return FutureBuilder<List<dynamic>>(
        future: fetchSearchResults(query, context),
        // Hit the API when query is more than 4 characters
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
              if (result != null) {
                _productResults.add(result);
              }
              /*if (result?.vendor != null) {
                bool exist = doesVendorExist(_vendorResults,result);
                if (!exist) {
                      _vendorResults.add(result);
                }
              }*/
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
    print("${_productResults.length}");
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Product Slider (PageView)
            if (_productResults.isNotEmpty) ...[
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Text(
                      "Products",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          color: AppColor.ButtonBackColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8,
              ),
              Wrap(
                spacing: 10,
                // Horizontal space between items
                runSpacing: 5,
                // Vertical space between lines
                children: _productResults.map(
                  (item) {
                    final product = item;
                    return _buildProductCard(product, context);
                  },
                ).toList(),
              ),
              SizedBox(height: 24), // Add space before vendors section
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(dynamic result, BuildContext context) {
    String? imageUrl = result?.imageUrl;

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: GestureDetector(
        onTap: () {
          hideKeyBoard();
          Navigator.pushReplacementNamed(context, "/ProductDetailScreen",
              arguments: result);
        },
        child: ProductComponent(
            item: result,
            isDarkMode: isDarkMode,
            mediaWidth: MediaQuery.of(context).size.width,
            screenHeight: MediaQuery.of(context).size.height,
            showFavIcon: true,
            onAddTap: () {
              Navigator.pushNamed(context, "/ProductDetailScreen",
                  arguments: result);
            },
            onMinusTap: () {
              Navigator.pushNamed(context, "/ProductDetailScreen",
                  arguments: result);
            },
            onPlusTap: () {
              Navigator.pushNamed(context, "/ProductDetailScreen",
                  arguments: result);
            },
            onFavoriteTap: () {
              Navigator.pushNamed(context, "/ProductDetailScreen",
                  arguments: result);
            },
            primaryColor: AppColor.Primary),
      ),
    );
  }

  Future<List<ProductData>> fetchSearchResults(
      String query, BuildContext context) async {
    bool isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${Languages.of(context)?.labelNoInternetConnection}'),
          duration: maxDuration,
        ),
      );
      return [];
    } else {
      await Future.delayed(Duration(milliseconds: 2));
      VendorSearchRequest request =
          VendorSearchRequest(query: query, vendorId: vendorId);
      await Provider.of<MainViewModel>(context, listen: false)
          .fetchVendorSearchResults(
              "/api/v1/app/products/search_filter", request);
      ApiResponse apiResponse =
          Provider.of<MainViewModel>(context, listen: false).response;
      return getProductList(context, apiResponse) ?? [];
    }
  }

  List<ProductData>? getProductList(
      BuildContext context, ApiResponse apiResponse) {
    VendorSearchResponse? vendorSearchResponse =
        apiResponse.data as VendorSearchResponse?;
    var message = apiResponse.message.toString();

    switch (apiResponse.status) {
      case Status.LOADING:
        return vendorSearchResponse?.data;
      case Status.COMPLETED:
        print("rwrwr ${vendorSearchResponse?.data?[0].title}");
        //hideKeyBoard();

        return vendorSearchResponse
            ?.data; // Return an empty container as you'll navigate away
      case Status.ERROR:
        return vendorSearchResponse?.data;
      case Status.INITIAL:
      default:
        return vendorSearchResponse?.data;
    }
  }
}
