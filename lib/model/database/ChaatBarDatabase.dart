import 'dart:async';
import 'package:TheChaatBar/model/database/dao.dart';
import 'package:TheChaatBar/model/response/favoriteDataDB.dart';
import 'package:TheChaatBar/model/response/productDataDB.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../response/categoryDataDB.dart';
import '../response/dashboardDataResponse.dart';
import '../response/productListResponse.dart';
import 'list_converter.dart';

part 'ChaatBarDatabase.g.dart'; // the generated code will be there

@TypeConverters([ListConverter, ProductSizeListConverter])
@Database(version: 2, entities: [CategoryDataDB,ProductDataDB, ProductData, FavoritesDataDb, DashboardDataResponse ])
abstract class ChaatBarDatabase extends FloorDatabase {
  CartDataDao get cartDao;
  FavoritesDataDao get favoritesDao;
  CategoryDataDao get categoryDao;
  ProductsDataDao get productDao;
  DashboardDao get dashboardDao;
}