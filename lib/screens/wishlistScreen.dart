import "package:flutter/material.dart";

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
          children: [
              Text("Wishlist", style: Theme.of(context).textTheme.titleLarge,),
          ],
      ),
    );
  }
}
