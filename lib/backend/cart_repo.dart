import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:wow_shopping/backend/wishlist_repo.dart';
import 'package:wow_shopping/models/cart_item.dart';
import 'package:wow_shopping/models/cart_storage.dart';
import 'package:wow_shopping/models/product_item.dart';

/// FIXME: Very similar to the [WishlistRepo] and should be refactored out and simplified
class CartRepo {
  CartRepo._(this._file, storage) {
    storageNotifier = ValueNotifier(storage);
  }

  final File _file;
  late ValueNotifier<CartStorage> storageNotifier;
  Timer? _saveTimer;

  static Future<CartRepo> create() async {
    CartStorage storage;
    try {
      final dir = await path_provider.getApplicationDocumentsDirectory();
      final file = File(path.join(dir.path, 'cart.json'));
      if (await file.exists()) {
        storage = CartStorage.fromJson(
          json.decode(await file.readAsString()),
        );
      } else {
        storage = CartStorage.empty;
      }
      return CartRepo._(file, storage);
    } catch (error, stackTrace) {
      print('$error\n$stackTrace'); // Send to server?
      rethrow;
    }
  }

  Decimal get currentCartTotal =>
      _calculateCartTotal(storageNotifier.value.items);

  Decimal _calculateCartTotal(List<CartItem> items) {
    return items.fold<Decimal>(Decimal.zero, (prev, el) => prev + el.total);
  }

  CartItem cartItemForProduct(ProductItem item) {
    return storageNotifier.value.items //
        .firstWhere((el) => el.product.id == item.id,
            orElse: () => CartItem.none);
  }

  bool cartContainsProduct(ProductItem item) {
    return cartItemForProduct(item) != CartItem.none;
  }

  void addToCart(ProductItem item,
      {ProductOption option = ProductOption.none}) {
    final existingItem = cartItemForProduct(item);
    if (existingItem != CartItem.none) {
      updateQuantity(item.id, existingItem.quantity + 1);
      return;
    }
    storageNotifier.value = storageNotifier.value.copyWith(
      items: {
        ...storageNotifier.value.items,
        CartItem(
          product: item,
          option: option,
          deliveryFee: Decimal.zero,
          // FIXME: where from?
          deliveryDate: DateTime.now(),
          // FIXME: where from?
          quantity: 1,
        ),
      },
    );
    _saveCart();
  }

  void updateQuantity(String productId, int quantity) {
    storageNotifier.value = storageNotifier.value.copyWith(
      items: storageNotifier.value.items.map((item) {
        if (item.product.id == productId) {
          return item.copyWith(quantity: quantity);
        } else {
          return item;
        }
      }),
    );
    _saveCart();
  }

  void removeToCart(String productId) {
    storageNotifier.value = storageNotifier.value.copyWith(
      items:
          storageNotifier.value.items.where((el) => el.product.id != productId),
    );
    _saveCart();
  }

  void _saveCart() {
    _saveTimer?.cancel();
    _saveTimer = Timer(const Duration(seconds: 1), () async {
      await _file.writeAsString(json.encode(storageNotifier.value.toJson()));
    });
  }
}
