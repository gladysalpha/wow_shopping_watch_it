import 'package:flutter/material.dart';
import 'package:watch_it/watch_it.dart';
import 'package:wow_shopping/app/assets.dart';
import 'package:wow_shopping/app/theme.dart';
import 'package:wow_shopping/models/product_item.dart';
import 'package:wow_shopping/widgets/app_icon.dart';

import '../backend/wishlist_repo.dart';

@immutable
class WishlistButton extends StatelessWidget with WatchItMixin {
  const WishlistButton({
    super.key,
    required this.item,
  });

  final ProductItem item;

  void _onTogglePressed(bool value) {
    if (value) {
      di<WishlistRepo>().addToWishlist(item.id);
    } else {
      di<WishlistRepo>().removeToWishlist(item.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isInWishlist = watchValue(
            (WishlistRepo wishlistRepo) => wishlistRepo.wishlistStorageNotifier)
        .items
        .contains(item.id);
    return IconButton(
      onPressed: () => _onTogglePressed(!isInWishlist),
      icon: AppIcon(
        iconAsset: isInWishlist //
            ? Assets.iconHeartFilled
            : Assets.iconHeartEmpty,
        color: isInWishlist //
            ? AppTheme.of(context).appColor
            : const Color(0xFFD0D0D0),
      ),
    );
  }
}
