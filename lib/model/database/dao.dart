import 'package:TheChaatBar/model/response/favoriteDataDB.dart';
import 'package:TheChaatBar/model/response/productDataDB.dart';
import 'package:floor/floor.dart';

import '../response/categoryDataDB.dart';
import '../response/dashboardDataResponse.dart';
import '../response/productListResponse.dart';

@dao
abstract class CartDataDao {
  @Query('SELECT * FROM ProductDataDB ORDER BY addedToCartAt DESC')
  Future<List<ProductDataDB?>> findAllCartProducts();

  @Query('SELECT 1 FROM ProductDataDB WHERE vendorId = :vendorId AND productCategoryId = :categoryId AND productId =:productId')
  Future<ProductDataDB?> getSpecificCartProduct(String vendorId, String categoryId, String productId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCartProduct(ProductDataDB data);

  @delete
  Future<void> deleteCartProduct(ProductDataDB data);

  @update
  Future<void> updateCartProduct(ProductDataDB data);

  @Query('DELETE FROM ProductDataDB')
  Future<void> clearAllCartProduct();
}

@dao
abstract class FavoritesDataDao {
  @Query('SELECT * FROM FavoritesDataDb ORDER BY addedToFavoritesAt DESC')
  Future<List<FavoritesDataDb?>> findAllFavoritesProducts();

  @Query('SELECT 1 FROM FavoritesDataDb WHERE vendorId = :vendorId AND productCategoryId = :categoryId AND productId =:productId')
  Future<FavoritesDataDb?> getSpecificFavoritesProduct(String vendorId, String categoryId, String productId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertFavoritesProduct(FavoritesDataDb data);

  @delete
  Future<void> deleteFavoritesProduct(FavoritesDataDb data);

  @update
  Future<void> updateFavoritesProduct(FavoritesDataDb data);

  @Query('DELETE FROM FavoritesDataDb')
  Future<void> clearAllFavoritesProduct();
}


@dao
abstract class CategoryDataDao {
  @Query('SELECT * FROM CategoryDataDB ORDER BY createdAt DESC')
  Future<List<CategoryDataDB?>> findAllCategories();


  @Query('SELECT * FROM CategoryDataDB WHERE vendorId = :vendorId ')
  Future<List<CategoryDataDB?>> getCategoriesAccToVendor(int vendorId);

  @Query('SELECT 1 FROM CategoryDataDB WHERE productCategoryId = :categoryId ')
  Future<CategoryDataDB?> getCategoryWithId( int categoryId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertCategory(CategoryDataDB category);

  @delete
  Future<void> deleteCategory(CategoryDataDB category);

  @update
  Future<void> updateCategory(CategoryDataDB category);

  @Query('DELETE FROM CategoryDataDB')
  Future<void> clearAllCategories();
}

@dao
abstract class ProductsDataDao {
  @Query('SELECT * FROM ProductData ORDER BY createdAt DESC')
  Future<List<ProductData?>> findAllProducts();


  @Query('SELECT * FROM ProductData WHERE productCategoryId = :categoryId ')
  Future<List<ProductData?>> getProductsAccToCategory(int categoryId);


  @Query('SELECT 1 FROM ProductData WHERE id = :productId ')
  Future<ProductData?> getCategoryWithId( int productId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertProduct(ProductData product);

  @delete
  Future<void> deleteProduct(ProductData product);

  @update
  Future<void> updateProduct(ProductData product);

  @Query('DELETE FROM ProductData')
  Future<void> clearAllProducts();
}

@dao
abstract class DashboardDao {
  @Query('SELECT * FROM DashboardDataResponse ')
  Future<DashboardDataResponse?> findData();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertData(DashboardDataResponse data);

  @delete
  Future<void> deleteData(DashboardDataResponse data);

  @update
  Future<void> updateData(DashboardDataResponse data);

  @Query('DELETE FROM DashboardDataResponse')
  Future<void> clearAllData();
}
