import 'dart:convert';

import 'package:TheChaatBar/model/response/productListResponse.dart';
import 'package:floor/floor.dart';

class ListConverter extends TypeConverter<List<int>, String> {
  @override
  String encode(List<int> items) {
    return jsonEncode(items); // Convert List<int> to JSON String
  }

  @override
  List<int> decode(String itemsString) {
    return (jsonDecode(itemsString) as List<dynamic>).cast<int>(); // Convert JSON String back to List<int>
  }
}

// TypeConverter for List<ProductSize>
class ProductSizeListConverter extends TypeConverter<List<ProductSize>, String> {
  @override
  String encode(List<ProductSize> items) {
    return jsonEncode(items.map((item) => item.toJson()).toList()); // Convert List<ProductSize> to JSON String
  }

  @override
  List<ProductSize> decode(String itemsString) {
    final decoded = jsonDecode(itemsString) as List<dynamic>;
    return decoded.map((item) => ProductSize.fromJson(item as Map<String, dynamic>)).toList(); // Convert JSON String back to List<ProductSize>
  }
}