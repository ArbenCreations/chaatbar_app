// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ChaatBarDatabase.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $ChaatBarDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $ChaatBarDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $ChaatBarDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<ChaatBarDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorChaatBarDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ChaatBarDatabaseBuilderContract databaseBuilder(String name) =>
      _$ChaatBarDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $ChaatBarDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$ChaatBarDatabaseBuilder(null);
}

class _$ChaatBarDatabaseBuilder implements $ChaatBarDatabaseBuilderContract {
  _$ChaatBarDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $ChaatBarDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $ChaatBarDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<ChaatBarDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$ChaatBarDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$ChaatBarDatabase extends ChaatBarDatabase {
  _$ChaatBarDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CartDataDao? _cartDaoInstance;

  FavoritesDataDao? _favoritesDaoInstance;

  CategoryDataDao? _categoryDaoInstance;

  ProductsDataDao? _productDaoInstance;

  DashboardDao? _dashboardDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `CategoryDataDB` (`id` INTEGER, `categoryName` TEXT, `categoryImage` TEXT, `menuImgUrl` TEXT, `status` INTEGER, `createdAt` TEXT, `updatedAt` TEXT, `franchiseId` INTEGER, `vendorId` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ProductDataDB` (`productId` INTEGER, `title` TEXT, `shortDescription` TEXT, `description` TEXT, `vendorId` INTEGER, `franchiseId` INTEGER, `price` REAL, `productCategoryId` INTEGER, `deposit` TEXT, `status` INTEGER, `favorite` INTEGER, `isBuy1Get1` INTEGER, `addOnIdsList` TEXT, `salePrice` TEXT, `qtyLimit` INTEGER, `addOnType` TEXT, `imageUrl` TEXT, `vendorName` TEXT, `theme` TEXT, `addOn` TEXT, `categoryName` TEXT, `addedToCartAt` TEXT, `quantity` INTEGER, `productSizesList` TEXT, PRIMARY KEY (`productId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `ProductData` (`id` INTEGER, `title` TEXT, `shortDescription` TEXT, `description` TEXT, `gst` INTEGER, `createdAt` TEXT, `updatedAt` TEXT, `vendorId` INTEGER, `franchiseId` INTEGER, `price` REAL, `productCategoryId` INTEGER, `pst` INTEGER, `vpt` INTEGER, `deposit` TEXT, `featured` INTEGER, `status` INTEGER, `isBuy1Get1` INTEGER, `favorite` INTEGER, `environmentalFee` TEXT, `addOnIdsList` TEXT, `salePrice` TEXT, `qtyLimit` INTEGER, `addOnType` TEXT, `imageUrl` TEXT, `addOn` TEXT, `categoryName` TEXT, `quantity` INTEGER NOT NULL, `vendorName` TEXT, `theme` TEXT, `productSizesList` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FavoritesDataDb` (`productId` INTEGER, `title` TEXT, `shortDescription` TEXT, `description` TEXT, `vendorId` INTEGER, `price` REAL, `productCategoryId` INTEGER, `deposit` TEXT, `status` INTEGER, `addOnIdsList` TEXT, `salePrice` TEXT, `qtyLimit` INTEGER, `addOnType` TEXT, `imageUrl` TEXT, `vendorName` TEXT, `theme` TEXT, `categoryName` TEXT, `addedToFavoritesAt` TEXT, `quantity` INTEGER, `productSizesList` TEXT, PRIMARY KEY (`productId`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `DashboardDataResponse` (`featuredProducts` TEXT, `favoriteProducts` TEXT, `categories` TEXT, `banners` TEXT, `recentOrders` TEXT, `message` TEXT, `status` INTEGER, PRIMARY KEY (`status`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  CartDataDao get cartDao {
    return _cartDaoInstance ??= _$CartDataDao(database, changeListener);
  }

  @override
  FavoritesDataDao get favoritesDao {
    return _favoritesDaoInstance ??=
        _$FavoritesDataDao(database, changeListener);
  }

  @override
  CategoryDataDao get categoryDao {
    return _categoryDaoInstance ??= _$CategoryDataDao(database, changeListener);
  }

  @override
  ProductsDataDao get productDao {
    return _productDaoInstance ??= _$ProductsDataDao(database, changeListener);
  }

  @override
  DashboardDao get dashboardDao {
    return _dashboardDaoInstance ??= _$DashboardDao(database, changeListener);
  }
}

class _$CartDataDao extends CartDataDao {
  _$CartDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productDataDBInsertionAdapter = InsertionAdapter(
            database,
            'ProductDataDB',
            (ProductDataDB item) => <String, Object?>{
                  'productId': item.productId,
                  'title': item.title,
                  'shortDescription': item.shortDescription,
                  'description': item.description,
                  'vendorId': item.vendorId,
                  'franchiseId': item.franchiseId,
                  'price': item.price,
                  'productCategoryId': item.productCategoryId,
                  'deposit': item.deposit,
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'favorite':
                      item.favorite == null ? null : (item.favorite! ? 1 : 0),
                  'isBuy1Get1': item.isBuy1Get1 == null
                      ? null
                      : (item.isBuy1Get1! ? 1 : 0),
                  'addOnIdsList': item.addOnIdsList,
                  'salePrice': item.salePrice,
                  'qtyLimit': item.qtyLimit,
                  'addOnType': item.addOnType,
                  'imageUrl': item.imageUrl,
                  'vendorName': item.vendorName,
                  'theme': item.theme,
                  'addOn': item.addOn,
                  'categoryName': item.categoryName,
                  'addedToCartAt': item.addedToCartAt,
                  'quantity': item.quantity,
                  'productSizesList': item.productSizesList
                }),
        _productDataDBUpdateAdapter = UpdateAdapter(
            database,
            'ProductDataDB',
            ['productId'],
            (ProductDataDB item) => <String, Object?>{
                  'productId': item.productId,
                  'title': item.title,
                  'shortDescription': item.shortDescription,
                  'description': item.description,
                  'vendorId': item.vendorId,
                  'franchiseId': item.franchiseId,
                  'price': item.price,
                  'productCategoryId': item.productCategoryId,
                  'deposit': item.deposit,
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'favorite':
                      item.favorite == null ? null : (item.favorite! ? 1 : 0),
                  'isBuy1Get1': item.isBuy1Get1 == null
                      ? null
                      : (item.isBuy1Get1! ? 1 : 0),
                  'addOnIdsList': item.addOnIdsList,
                  'salePrice': item.salePrice,
                  'qtyLimit': item.qtyLimit,
                  'addOnType': item.addOnType,
                  'imageUrl': item.imageUrl,
                  'vendorName': item.vendorName,
                  'theme': item.theme,
                  'addOn': item.addOn,
                  'categoryName': item.categoryName,
                  'addedToCartAt': item.addedToCartAt,
                  'quantity': item.quantity,
                  'productSizesList': item.productSizesList
                }),
        _productDataDBDeletionAdapter = DeletionAdapter(
            database,
            'ProductDataDB',
            ['productId'],
            (ProductDataDB item) => <String, Object?>{
                  'productId': item.productId,
                  'title': item.title,
                  'shortDescription': item.shortDescription,
                  'description': item.description,
                  'vendorId': item.vendorId,
                  'franchiseId': item.franchiseId,
                  'price': item.price,
                  'productCategoryId': item.productCategoryId,
                  'deposit': item.deposit,
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'favorite':
                      item.favorite == null ? null : (item.favorite! ? 1 : 0),
                  'isBuy1Get1': item.isBuy1Get1 == null
                      ? null
                      : (item.isBuy1Get1! ? 1 : 0),
                  'addOnIdsList': item.addOnIdsList,
                  'salePrice': item.salePrice,
                  'qtyLimit': item.qtyLimit,
                  'addOnType': item.addOnType,
                  'imageUrl': item.imageUrl,
                  'vendorName': item.vendorName,
                  'theme': item.theme,
                  'addOn': item.addOn,
                  'categoryName': item.categoryName,
                  'addedToCartAt': item.addedToCartAt,
                  'quantity': item.quantity,
                  'productSizesList': item.productSizesList
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductDataDB> _productDataDBInsertionAdapter;

  final UpdateAdapter<ProductDataDB> _productDataDBUpdateAdapter;

  final DeletionAdapter<ProductDataDB> _productDataDBDeletionAdapter;

  @override
  Future<List<ProductDataDB?>> findAllCartProducts() async {
    return _queryAdapter.queryList(
        'SELECT * FROM ProductDataDB ORDER BY addedToCartAt DESC',
        mapper: (Map<String, Object?> row) => ProductDataDB(
            productId: row['productId'] as int?,
            title: row['title'] as String?,
            shortDescription: row['shortDescription'] as String?,
            description: row['description'] as String?,
            price: row['price'] as double?,
            productCategoryId: row['productCategoryId'] as int?,
            vendorId: row['vendorId'] as int?,
            franchiseId: row['franchiseId'] as int?,
            deposit: row['deposit'] as String?,
            addOnIdsList: row['addOnIdsList'] as String?,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            isBuy1Get1: row['isBuy1Get1'] == null
                ? null
                : (row['isBuy1Get1'] as int) != 0,
            salePrice: row['salePrice'] as String?,
            favorite:
                row['favorite'] == null ? null : (row['favorite'] as int) != 0,
            qtyLimit: row['qtyLimit'] as int?,
            addOnType: row['addOnType'] as String?,
            vendorName: row['vendorName'] as String?,
            addOn: row['addOn'] as String?,
            theme: row['theme'] as String?,
            imageUrl: row['imageUrl'] as String?,
            categoryName: row['categoryName'] as String?,
            addedToCartAt: row['addedToCartAt'] as String?,
            productSizesList: row['productSizesList'] as String?,
            quantity: row['quantity'] as int?));
  }

  @override
  Future<ProductDataDB?> getSpecificCartProduct(
    String vendorId,
    String categoryId,
    String productId,
  ) async {
    return _queryAdapter.query(
        'SELECT 1 FROM ProductDataDB WHERE vendorId = ?1 AND productCategoryId = ?2 AND productId =?3',
        mapper: (Map<String, Object?> row) => ProductDataDB(productId: row['productId'] as int?, title: row['title'] as String?, shortDescription: row['shortDescription'] as String?, description: row['description'] as String?, price: row['price'] as double?, productCategoryId: row['productCategoryId'] as int?, vendorId: row['vendorId'] as int?, franchiseId: row['franchiseId'] as int?, deposit: row['deposit'] as String?, addOnIdsList: row['addOnIdsList'] as String?, status: row['status'] == null ? null : (row['status'] as int) != 0, isBuy1Get1: row['isBuy1Get1'] == null ? null : (row['isBuy1Get1'] as int) != 0, salePrice: row['salePrice'] as String?, favorite: row['favorite'] == null ? null : (row['favorite'] as int) != 0, qtyLimit: row['qtyLimit'] as int?, addOnType: row['addOnType'] as String?, vendorName: row['vendorName'] as String?, addOn: row['addOn'] as String?, theme: row['theme'] as String?, imageUrl: row['imageUrl'] as String?, categoryName: row['categoryName'] as String?, addedToCartAt: row['addedToCartAt'] as String?, productSizesList: row['productSizesList'] as String?, quantity: row['quantity'] as int?),
        arguments: [vendorId, categoryId, productId]);
  }

  @override
  Future<void> clearAllCartProduct() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ProductDataDB');
  }

  @override
  Future<void> insertCartProduct(ProductDataDB data) async {
    await _productDataDBInsertionAdapter.insert(
        data, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateCartProduct(ProductDataDB data) async {
    await _productDataDBUpdateAdapter.update(data, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCartProduct(ProductDataDB data) async {
    await _productDataDBDeletionAdapter.delete(data);
  }
}

class _$FavoritesDataDao extends FavoritesDataDao {
  _$FavoritesDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _favoritesDataDbInsertionAdapter = InsertionAdapter(
            database,
            'FavoritesDataDb',
            (FavoritesDataDb item) => <String, Object?>{
                  'productId': item.productId,
                  'title': item.title,
                  'shortDescription': item.shortDescription,
                  'description': item.description,
                  'vendorId': item.vendorId,
                  'price': item.price,
                  'productCategoryId': item.productCategoryId,
                  'deposit': item.deposit,
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'addOnIdsList': item.addOnIdsList,
                  'salePrice': item.salePrice,
                  'qtyLimit': item.qtyLimit,
                  'addOnType': item.addOnType,
                  'imageUrl': item.imageUrl,
                  'vendorName': item.vendorName,
                  'theme': item.theme,
                  'categoryName': item.categoryName,
                  'addedToFavoritesAt': item.addedToFavoritesAt,
                  'quantity': item.quantity,
                  'productSizesList': item.productSizesList
                }),
        _favoritesDataDbUpdateAdapter = UpdateAdapter(
            database,
            'FavoritesDataDb',
            ['productId'],
            (FavoritesDataDb item) => <String, Object?>{
                  'productId': item.productId,
                  'title': item.title,
                  'shortDescription': item.shortDescription,
                  'description': item.description,
                  'vendorId': item.vendorId,
                  'price': item.price,
                  'productCategoryId': item.productCategoryId,
                  'deposit': item.deposit,
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'addOnIdsList': item.addOnIdsList,
                  'salePrice': item.salePrice,
                  'qtyLimit': item.qtyLimit,
                  'addOnType': item.addOnType,
                  'imageUrl': item.imageUrl,
                  'vendorName': item.vendorName,
                  'theme': item.theme,
                  'categoryName': item.categoryName,
                  'addedToFavoritesAt': item.addedToFavoritesAt,
                  'quantity': item.quantity,
                  'productSizesList': item.productSizesList
                }),
        _favoritesDataDbDeletionAdapter = DeletionAdapter(
            database,
            'FavoritesDataDb',
            ['productId'],
            (FavoritesDataDb item) => <String, Object?>{
                  'productId': item.productId,
                  'title': item.title,
                  'shortDescription': item.shortDescription,
                  'description': item.description,
                  'vendorId': item.vendorId,
                  'price': item.price,
                  'productCategoryId': item.productCategoryId,
                  'deposit': item.deposit,
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'addOnIdsList': item.addOnIdsList,
                  'salePrice': item.salePrice,
                  'qtyLimit': item.qtyLimit,
                  'addOnType': item.addOnType,
                  'imageUrl': item.imageUrl,
                  'vendorName': item.vendorName,
                  'theme': item.theme,
                  'categoryName': item.categoryName,
                  'addedToFavoritesAt': item.addedToFavoritesAt,
                  'quantity': item.quantity,
                  'productSizesList': item.productSizesList
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FavoritesDataDb> _favoritesDataDbInsertionAdapter;

  final UpdateAdapter<FavoritesDataDb> _favoritesDataDbUpdateAdapter;

  final DeletionAdapter<FavoritesDataDb> _favoritesDataDbDeletionAdapter;

  @override
  Future<List<FavoritesDataDb?>> findAllFavoritesProducts() async {
    return _queryAdapter.queryList(
        'SELECT * FROM FavoritesDataDb ORDER BY addedToFavoritesAt DESC',
        mapper: (Map<String, Object?> row) => FavoritesDataDb(
            productId: row['productId'] as int?,
            title: row['title'] as String?,
            shortDescription: row['shortDescription'] as String?,
            description: row['description'] as String?,
            price: row['price'] as double?,
            productCategoryId: row['productCategoryId'] as int?,
            vendorId: row['vendorId'] as int?,
            deposit: row['deposit'] as String?,
            addOnIdsList: row['addOnIdsList'] as String?,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            salePrice: row['salePrice'] as String?,
            qtyLimit: row['qtyLimit'] as int?,
            addOnType: row['addOnType'] as String?,
            vendorName: row['vendorName'] as String?,
            theme: row['theme'] as String?,
            imageUrl: row['imageUrl'] as String?,
            categoryName: row['categoryName'] as String?,
            addedToFavoritesAt: row['addedToFavoritesAt'] as String?,
            productSizesList: row['productSizesList'] as String?,
            quantity: row['quantity'] as int?));
  }

  @override
  Future<FavoritesDataDb?> getSpecificFavoritesProduct(
    String vendorId,
    String categoryId,
    String productId,
  ) async {
    return _queryAdapter.query(
        'SELECT 1 FROM FavoritesDataDb WHERE vendorId = ?1 AND productCategoryId = ?2 AND productId =?3',
        mapper: (Map<String, Object?> row) => FavoritesDataDb(productId: row['productId'] as int?, title: row['title'] as String?, shortDescription: row['shortDescription'] as String?, description: row['description'] as String?, price: row['price'] as double?, productCategoryId: row['productCategoryId'] as int?, vendorId: row['vendorId'] as int?, deposit: row['deposit'] as String?, addOnIdsList: row['addOnIdsList'] as String?, status: row['status'] == null ? null : (row['status'] as int) != 0, salePrice: row['salePrice'] as String?, qtyLimit: row['qtyLimit'] as int?, addOnType: row['addOnType'] as String?, vendorName: row['vendorName'] as String?, theme: row['theme'] as String?, imageUrl: row['imageUrl'] as String?, categoryName: row['categoryName'] as String?, addedToFavoritesAt: row['addedToFavoritesAt'] as String?, productSizesList: row['productSizesList'] as String?, quantity: row['quantity'] as int?),
        arguments: [vendorId, categoryId, productId]);
  }

  @override
  Future<void> clearAllFavoritesProduct() async {
    await _queryAdapter.queryNoReturn('DELETE FROM FavoritesDataDb');
  }

  @override
  Future<void> insertFavoritesProduct(FavoritesDataDb data) async {
    await _favoritesDataDbInsertionAdapter.insert(
        data, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateFavoritesProduct(FavoritesDataDb data) async {
    await _favoritesDataDbUpdateAdapter.update(data, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteFavoritesProduct(FavoritesDataDb data) async {
    await _favoritesDataDbDeletionAdapter.delete(data);
  }
}

class _$CategoryDataDao extends CategoryDataDao {
  _$CategoryDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _categoryDataDBInsertionAdapter = InsertionAdapter(
            database,
            'CategoryDataDB',
            (CategoryDataDB item) => <String, Object?>{
                  'id': item.id,
                  'categoryName': item.categoryName,
                  'categoryImage': item.categoryImage,
                  'menuImgUrl': item.menuImgUrl,
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'franchiseId': item.franchiseId,
                  'vendorId': item.vendorId
                }),
        _categoryDataDBUpdateAdapter = UpdateAdapter(
            database,
            'CategoryDataDB',
            ['id'],
            (CategoryDataDB item) => <String, Object?>{
                  'id': item.id,
                  'categoryName': item.categoryName,
                  'categoryImage': item.categoryImage,
                  'menuImgUrl': item.menuImgUrl,
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'franchiseId': item.franchiseId,
                  'vendorId': item.vendorId
                }),
        _categoryDataDBDeletionAdapter = DeletionAdapter(
            database,
            'CategoryDataDB',
            ['id'],
            (CategoryDataDB item) => <String, Object?>{
                  'id': item.id,
                  'categoryName': item.categoryName,
                  'categoryImage': item.categoryImage,
                  'menuImgUrl': item.menuImgUrl,
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'franchiseId': item.franchiseId,
                  'vendorId': item.vendorId
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<CategoryDataDB> _categoryDataDBInsertionAdapter;

  final UpdateAdapter<CategoryDataDB> _categoryDataDBUpdateAdapter;

  final DeletionAdapter<CategoryDataDB> _categoryDataDBDeletionAdapter;

  @override
  Future<List<CategoryDataDB?>> findAllCategories() async {
    return _queryAdapter.queryList(
        'SELECT * FROM CategoryDataDB ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => CategoryDataDB(
            id: row['id'] as int?,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            categoryName: row['categoryName'] as String?,
            categoryImage: row['categoryImage'] as String?,
            menuImgUrl: row['menuImgUrl'] as String?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?,
            vendorId: row['vendorId'] as int?,
            franchiseId: row['franchiseId'] as int?));
  }

  @override
  Future<List<CategoryDataDB?>> getCategoriesAccToVendor(int vendorId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM CategoryDataDB WHERE vendorId = ?1',
        mapper: (Map<String, Object?> row) => CategoryDataDB(
            id: row['id'] as int?,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            categoryName: row['categoryName'] as String?,
            categoryImage: row['categoryImage'] as String?,
            menuImgUrl: row['menuImgUrl'] as String?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?,
            vendorId: row['vendorId'] as int?,
            franchiseId: row['franchiseId'] as int?),
        arguments: [vendorId]);
  }

  @override
  Future<CategoryDataDB?> getCategoryWithId(int categoryId) async {
    return _queryAdapter.query(
        'SELECT 1 FROM CategoryDataDB WHERE productCategoryId = ?1',
        mapper: (Map<String, Object?> row) => CategoryDataDB(
            id: row['id'] as int?,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            categoryName: row['categoryName'] as String?,
            categoryImage: row['categoryImage'] as String?,
            menuImgUrl: row['menuImgUrl'] as String?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?,
            vendorId: row['vendorId'] as int?,
            franchiseId: row['franchiseId'] as int?),
        arguments: [categoryId]);
  }

  @override
  Future<void> clearAllCategories() async {
    await _queryAdapter.queryNoReturn('DELETE FROM CategoryDataDB');
  }

  @override
  Future<void> insertCategory(CategoryDataDB category) async {
    await _categoryDataDBInsertionAdapter.insert(
        category, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateCategory(CategoryDataDB category) async {
    await _categoryDataDBUpdateAdapter.update(
        category, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteCategory(CategoryDataDB category) async {
    await _categoryDataDBDeletionAdapter.delete(category);
  }
}

class _$ProductsDataDao extends ProductsDataDao {
  _$ProductsDataDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _productDataInsertionAdapter = InsertionAdapter(
            database,
            'ProductData',
            (ProductData item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'shortDescription': item.shortDescription,
                  'description': item.description,
                  'gst': item.gst,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'vendorId': item.vendorId,
                  'franchiseId': item.franchiseId,
                  'price': item.price,
                  'productCategoryId': item.productCategoryId,
                  'pst': item.pst,
                  'vpt': item.vpt,
                  'deposit': item.deposit,
                  'featured':
                      item.featured == null ? null : (item.featured! ? 1 : 0),
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'isBuy1Get1': item.isBuy1Get1 == null
                      ? null
                      : (item.isBuy1Get1! ? 1 : 0),
                  'favorite':
                      item.favorite == null ? null : (item.favorite! ? 1 : 0),
                  'environmentalFee': item.environmentalFee,
                  'addOnIdsList': item.addOnIdsList,
                  'salePrice': item.salePrice,
                  'qtyLimit': item.qtyLimit,
                  'addOnType': item.addOnType,
                  'imageUrl': item.imageUrl,
                  'addOn': item.addOn,
                  'categoryName': item.categoryName,
                  'quantity': item.quantity,
                  'vendorName': item.vendorName,
                  'theme': item.theme,
                  'productSizesList': item.productSizesList
                }),
        _productDataUpdateAdapter = UpdateAdapter(
            database,
            'ProductData',
            ['id'],
            (ProductData item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'shortDescription': item.shortDescription,
                  'description': item.description,
                  'gst': item.gst,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'vendorId': item.vendorId,
                  'franchiseId': item.franchiseId,
                  'price': item.price,
                  'productCategoryId': item.productCategoryId,
                  'pst': item.pst,
                  'vpt': item.vpt,
                  'deposit': item.deposit,
                  'featured':
                      item.featured == null ? null : (item.featured! ? 1 : 0),
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'isBuy1Get1': item.isBuy1Get1 == null
                      ? null
                      : (item.isBuy1Get1! ? 1 : 0),
                  'favorite':
                      item.favorite == null ? null : (item.favorite! ? 1 : 0),
                  'environmentalFee': item.environmentalFee,
                  'addOnIdsList': item.addOnIdsList,
                  'salePrice': item.salePrice,
                  'qtyLimit': item.qtyLimit,
                  'addOnType': item.addOnType,
                  'imageUrl': item.imageUrl,
                  'addOn': item.addOn,
                  'categoryName': item.categoryName,
                  'quantity': item.quantity,
                  'vendorName': item.vendorName,
                  'theme': item.theme,
                  'productSizesList': item.productSizesList
                }),
        _productDataDeletionAdapter = DeletionAdapter(
            database,
            'ProductData',
            ['id'],
            (ProductData item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'shortDescription': item.shortDescription,
                  'description': item.description,
                  'gst': item.gst,
                  'createdAt': item.createdAt,
                  'updatedAt': item.updatedAt,
                  'vendorId': item.vendorId,
                  'franchiseId': item.franchiseId,
                  'price': item.price,
                  'productCategoryId': item.productCategoryId,
                  'pst': item.pst,
                  'vpt': item.vpt,
                  'deposit': item.deposit,
                  'featured':
                      item.featured == null ? null : (item.featured! ? 1 : 0),
                  'status': item.status == null ? null : (item.status! ? 1 : 0),
                  'isBuy1Get1': item.isBuy1Get1 == null
                      ? null
                      : (item.isBuy1Get1! ? 1 : 0),
                  'favorite':
                      item.favorite == null ? null : (item.favorite! ? 1 : 0),
                  'environmentalFee': item.environmentalFee,
                  'addOnIdsList': item.addOnIdsList,
                  'salePrice': item.salePrice,
                  'qtyLimit': item.qtyLimit,
                  'addOnType': item.addOnType,
                  'imageUrl': item.imageUrl,
                  'addOn': item.addOn,
                  'categoryName': item.categoryName,
                  'quantity': item.quantity,
                  'vendorName': item.vendorName,
                  'theme': item.theme,
                  'productSizesList': item.productSizesList
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ProductData> _productDataInsertionAdapter;

  final UpdateAdapter<ProductData> _productDataUpdateAdapter;

  final DeletionAdapter<ProductData> _productDataDeletionAdapter;

  @override
  Future<List<ProductData?>> findAllProducts() async {
    return _queryAdapter.queryList(
        'SELECT * FROM ProductData ORDER BY createdAt DESC',
        mapper: (Map<String, Object?> row) => ProductData(
            id: row['id'] as int?,
            title: row['title'] as String?,
            shortDescription: row['shortDescription'] as String?,
            description: row['description'] as String?,
            gst: row['gst'] as int?,
            favorite:
                row['favorite'] == null ? null : (row['favorite'] as int) != 0,
            price: row['price'] as double?,
            productCategoryId: row['productCategoryId'] as int?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?,
            vendorId: row['vendorId'] as int?,
            franchiseId: row['franchiseId'] as int?,
            isBuy1Get1: row['isBuy1Get1'] == null
                ? null
                : (row['isBuy1Get1'] as int) != 0,
            pst: row['pst'] as int?,
            vpt: row['vpt'] as int?,
            deposit: row['deposit'] as String?,
            environmentalFee: row['environmentalFee'] as String?,
            addOnIdsList: row['addOnIdsList'] as String?,
            featured:
                row['featured'] == null ? null : (row['featured'] as int) != 0,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            salePrice: row['salePrice'] as String?,
            qtyLimit: row['qtyLimit'] as int?,
            addOnType: row['addOnType'] as String?,
            imageUrl: row['imageUrl'] as String?,
            addOn: row['addOn'] as String?,
            categoryName: row['categoryName'] as String?,
            productSizesList: row['productSizesList'] as String?,
            quantity: row['quantity'] as int,
            vendorName: row['vendorName'] as String?,
            theme: row['theme'] as String?));
  }

  @override
  Future<List<ProductData?>> getProductsAccToCategory(int categoryId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM ProductData WHERE productCategoryId = ?1',
        mapper: (Map<String, Object?> row) => ProductData(
            id: row['id'] as int?,
            title: row['title'] as String?,
            shortDescription: row['shortDescription'] as String?,
            description: row['description'] as String?,
            gst: row['gst'] as int?,
            favorite:
                row['favorite'] == null ? null : (row['favorite'] as int) != 0,
            price: row['price'] as double?,
            productCategoryId: row['productCategoryId'] as int?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?,
            vendorId: row['vendorId'] as int?,
            franchiseId: row['franchiseId'] as int?,
            isBuy1Get1: row['isBuy1Get1'] == null
                ? null
                : (row['isBuy1Get1'] as int) != 0,
            pst: row['pst'] as int?,
            vpt: row['vpt'] as int?,
            deposit: row['deposit'] as String?,
            environmentalFee: row['environmentalFee'] as String?,
            addOnIdsList: row['addOnIdsList'] as String?,
            featured:
                row['featured'] == null ? null : (row['featured'] as int) != 0,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            salePrice: row['salePrice'] as String?,
            qtyLimit: row['qtyLimit'] as int?,
            addOnType: row['addOnType'] as String?,
            imageUrl: row['imageUrl'] as String?,
            addOn: row['addOn'] as String?,
            categoryName: row['categoryName'] as String?,
            productSizesList: row['productSizesList'] as String?,
            quantity: row['quantity'] as int,
            vendorName: row['vendorName'] as String?,
            theme: row['theme'] as String?),
        arguments: [categoryId]);
  }

  @override
  Future<ProductData?> getCategoryWithId(int productId) async {
    return _queryAdapter.query('SELECT 1 FROM ProductData WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ProductData(
            id: row['id'] as int?,
            title: row['title'] as String?,
            shortDescription: row['shortDescription'] as String?,
            description: row['description'] as String?,
            gst: row['gst'] as int?,
            favorite:
                row['favorite'] == null ? null : (row['favorite'] as int) != 0,
            price: row['price'] as double?,
            productCategoryId: row['productCategoryId'] as int?,
            createdAt: row['createdAt'] as String?,
            updatedAt: row['updatedAt'] as String?,
            vendorId: row['vendorId'] as int?,
            franchiseId: row['franchiseId'] as int?,
            isBuy1Get1: row['isBuy1Get1'] == null
                ? null
                : (row['isBuy1Get1'] as int) != 0,
            pst: row['pst'] as int?,
            vpt: row['vpt'] as int?,
            deposit: row['deposit'] as String?,
            environmentalFee: row['environmentalFee'] as String?,
            addOnIdsList: row['addOnIdsList'] as String?,
            featured:
                row['featured'] == null ? null : (row['featured'] as int) != 0,
            status: row['status'] == null ? null : (row['status'] as int) != 0,
            salePrice: row['salePrice'] as String?,
            qtyLimit: row['qtyLimit'] as int?,
            addOnType: row['addOnType'] as String?,
            imageUrl: row['imageUrl'] as String?,
            addOn: row['addOn'] as String?,
            categoryName: row['categoryName'] as String?,
            productSizesList: row['productSizesList'] as String?,
            quantity: row['quantity'] as int,
            vendorName: row['vendorName'] as String?,
            theme: row['theme'] as String?),
        arguments: [productId]);
  }

  @override
  Future<void> clearAllProducts() async {
    await _queryAdapter.queryNoReturn('DELETE FROM ProductData');
  }

  @override
  Future<void> insertProduct(ProductData product) async {
    await _productDataInsertionAdapter.insert(
        product, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateProduct(ProductData product) async {
    await _productDataUpdateAdapter.update(product, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteProduct(ProductData product) async {
    await _productDataDeletionAdapter.delete(product);
  }
}

class _$DashboardDao extends DashboardDao {
  _$DashboardDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _dashboardDataResponseInsertionAdapter = InsertionAdapter(
            database,
            'DashboardDataResponse',
            (DashboardDataResponse item) => <String, Object?>{
                  'featuredProducts': item.featuredProducts,
                  'favoriteProducts': item.favoriteProducts,
                  'categories': item.categories,
                  'banners': item.banners,
                  'recentOrders': item.recentOrders,
                  'message': item.message,
                  'status': item.status
                }),
        _dashboardDataResponseUpdateAdapter = UpdateAdapter(
            database,
            'DashboardDataResponse',
            ['status'],
            (DashboardDataResponse item) => <String, Object?>{
                  'featuredProducts': item.featuredProducts,
                  'favoriteProducts': item.favoriteProducts,
                  'categories': item.categories,
                  'banners': item.banners,
                  'recentOrders': item.recentOrders,
                  'message': item.message,
                  'status': item.status
                }),
        _dashboardDataResponseDeletionAdapter = DeletionAdapter(
            database,
            'DashboardDataResponse',
            ['status'],
            (DashboardDataResponse item) => <String, Object?>{
                  'featuredProducts': item.featuredProducts,
                  'favoriteProducts': item.favoriteProducts,
                  'categories': item.categories,
                  'banners': item.banners,
                  'recentOrders': item.recentOrders,
                  'message': item.message,
                  'status': item.status
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<DashboardDataResponse>
      _dashboardDataResponseInsertionAdapter;

  final UpdateAdapter<DashboardDataResponse>
      _dashboardDataResponseUpdateAdapter;

  final DeletionAdapter<DashboardDataResponse>
      _dashboardDataResponseDeletionAdapter;

  @override
  Future<DashboardDataResponse?> findData() async {
    return _queryAdapter.query('SELECT * FROM DashboardDataResponse',
        mapper: (Map<String, Object?> row) => DashboardDataResponse(
            featuredProducts: row['featuredProducts'] as String?,
            favoriteProducts: row['favoriteProducts'] as String?,
            categories: row['categories'] as String?,
            banners: row['banners'] as String?,
            recentOrders: row['recentOrders'] as String?,
            message: row['message'] as String?,
            status: row['status'] as int?));
  }

  @override
  Future<void> clearAllData() async {
    await _queryAdapter.queryNoReturn('DELETE FROM DashboardDataResponse');
  }

  @override
  Future<void> insertData(DashboardDataResponse data) async {
    await _dashboardDataResponseInsertionAdapter.insert(
        data, OnConflictStrategy.replace);
  }

  @override
  Future<void> updateData(DashboardDataResponse data) async {
    await _dashboardDataResponseUpdateAdapter.update(
        data, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteData(DashboardDataResponse data) async {
    await _dashboardDataResponseDeletionAdapter.delete(data);
  }
}

// ignore_for_file: unused_element
final _listConverter = ListConverter();
final _productSizeListConverter = ProductSizeListConverter();
