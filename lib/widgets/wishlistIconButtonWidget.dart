import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/widgets/DiologsWidgets.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

class WishlistIconButtonWidget extends StatefulWidget {
  String activityId;
  String activityStoreId;
  WishlistIconButtonWidget(
      {super.key, required this.activityStoreId, required this.activityId});

  @override
  State<WishlistIconButtonWidget> createState() =>
      _WishlistIconButtonWidgetState();
}

class _WishlistIconButtonWidgetState extends State<WishlistIconButtonWidget> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    ActivityProvider activityProvider = Provider.of<ActivityProvider>(context);

    // return ProgressButton.icon(
    //     iconedButtons: {
    //       ButtonState.idle: IconedButton(
    //           // text: "Send",
    //           icon: Icon(
    //             userProvider.currentUser != null
    //                 ? (userProvider.currentUser!.wishlist!
    //                         .contains(widget.activityId)
    //                     ? Icons.favorite
    //                     : Icons.favorite_border)
    //                 : Icons.favorite_border,
    //           ),
    //           color: Colors.transparent),
    //       ButtonState.loading: IconedButton(color: Colors.transparent),
    //         ButtonState.fail:
    //     IconedButton(
    //         text: "Failed",
    //         icon: Icon(Icons.cancel,color: Colors.white),
    //         color: Colors.red.shade300),
    //   ButtonState.success:
    //     IconedButton(
    //         text: "Success",
    //         icon: Icon(Icons.check_circle,color: Colors.white,),
    //         color: Colors.green.shade400)
    //     },
    //     onPressed: () async {
    //       if (buttonState == ButtonState.loading) {
    //         return;
    //       }
    //       if (userProvider.currentUser == null) {
    //         setState(() {
    //           buttonState = ButtonState.loading;
    //         });

    //         DialogWidgets.mustSginin(context);
    //         return;
    //       }
    //       if (userProvider.currentUser!.wishlist!.contains(widget.activityId)) {
    //         await userProvider.removeFromWishlist(widget.activityId);
    //       } else {
    //         await userProvider.addToWishlist(
    //             widget.activityStoreId, widget.activityId, activityProvider);
    //       }
    //       setState(() {
    //         userProvider.currentUser!.wishlist =
    //             userProvider.currentUser!.wishlist;

    //         buttonState = ButtonState.loading;
    //       });
    //     },
    //     state: buttonState);

    return IconButton(
      icon: Icon(
        userProvider.currentUser != null
            ? (userProvider.currentUser!.wishlist!.contains(widget.activityId)
                ? Icons.favorite
                : Icons.favorite_border)
            : Icons.favorite_border,
      ),
      onPressed: _isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              if (userProvider.currentUser == null) {
                DialogWidgets.mustSginin(context);
              } else {
                if (userProvider.currentUser!.wishlist!
                    .contains(widget.activityId)) {
                  await userProvider.removeFromWishlist(widget.activityId);
                } else {
                  await userProvider.addToWishlist(widget.activityStoreId,
                      widget.activityId, activityProvider);
                }
              }
              setState(() {
                _isLoading = false;
                userProvider.currentUser!.wishlist =
                    userProvider.currentUser!.wishlist;
              });
            },
    );
  }
}
