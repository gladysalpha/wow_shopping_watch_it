import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:wow_shopping/backend/product_repo.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/models/wishlist_storage.dart';

class WishlistRepo {
  WishlistRepo._(this._productsRepo, this._file, wishlist) {
    wishlistStorageNotifier = ValueNotifier(wishlist);
  }

  final ProductsRepo _productsRepo;
  final File _file;
  late ValueNotifier<WishlistStorage> wishlistStorageNotifier;
  Timer? _saveTimer;

  static Future<WishlistRepo> create(ProductsRepo productsRepo) async {
    WishlistStorage wishlist;
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      final file = File(path.join(dir.path, 'wishlist.json'));
      if (await file.exists()) {
        wishlist = WishlistStorage.fromJson(
          json.decode(await file.readAsString()),
        );
      } else {
        wishlist = WishlistStorage.empty;
      }
      return WishlistRepo._(productsRepo, file, wishlist);
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
  }

  List<ProductItem> get currentWishlistItems =>
      wishlistStorageNotifier.value.items
          .map(_productsRepo.findProduct)
          .toList();

  bool isInWishlist(ProductItem item) {
    return wishlistStorageNotifier.value.items.contains(item.id);
  }

  void addToWishlist(String productId) {
    if (wishlistStorageNotifier.value.items.contains(productId)) {
      return;
    }
    wishlistStorageNotifier.value = wishlistStorageNotifier.value.copyWith(
      items: {...wishlistStorageNotifier.value.items, productId},
    );
    _saveWishlist();
  }

  void removeToWishlist(String productId) {
    wishlistStorageNotifier.value = wishlistStorageNotifier.value.copyWith(
      items: wishlistStorageNotifier.value.items.where((el) => el != productId),
    );
    _saveWishlist();
  }

  void _saveWishlist() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      await _file
          .writeAsString(json.encode(wishlistStorageNotifier.value.toJson()));
    });
  }
}
