import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/backend/api_service.dart';
import 'package:wow_shopping/backend/auth_repo.dart';

import 'backend/cart_repo.dart';
import 'backend/product_repo.dart';
import 'backend/wishlist_repo.dart';

setup() async {
  di.registerSingletonAsync<AuthRepo>(() async {
    late AuthRepo authRepo;
    final apiService = ApiService(() async => authRepo.token);
    authRepo = await AuthRepo.create(apiService);
    authRepo.retrieveUser();
    return authRepo;
  });

  di.registerSingletonAsync<ProductsRepo>(
      () async => await ProductsRepo.create());
  di.registerSingletonAsync<WishlistRepo>(
    () async => await WishlistRepo.create(
      di<ProductsRepo>(),
    ),
    dependsOn: [ProductsRepo],
  );
  di.registerSingletonAsync<CartRepo>(() async => await CartRepo.create());
}
