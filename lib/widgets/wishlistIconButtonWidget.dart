import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/widgets/DiologsWidgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistIconButtonWidget extends StatefulWidget {
  String activityId;
  String activityStoreId;
  WishlistIconButtonWidget({super.key, required this.activityStoreId, required this.activityId});

  @override
  State<WishlistIconButtonWidget> createState() =>
      _WishlistIconButtonWidgetState();
}

class _WishlistIconButtonWidgetState extends State<WishlistIconButtonWidget> {
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);

    return IconButton(
      icon: Icon(
        userProvider.currentUser != null
            ? (userProvider.currentUser!.wishlist!.contains(widget.activityId)
                ? Icons.favorite
                : Icons.favorite_border)
            : Icons.favorite_border,
      ),
      onPressed: () async {
        if (userProvider.currentUser == null) {
          DialogWidgets.mustSginin(context);
          return;
        }
        if (userProvider.currentUser!.wishlist!.contains(widget.activityId)) {
          await userProvider.removeFromWishlist(widget.activityId);
        } else {
          await userProvider.addToWishlist(
              widget.activityStoreId, widget.activityId, activityProvider);
        }
        setState(() {
          userProvider.currentUser!.wishlist =
              userProvider.currentUser!.wishlist;
        });
      },
    );
  }
}
