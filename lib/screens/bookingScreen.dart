import "package:flutter/material.dart";

class BookingScreen extends StatelessWidget {
    static String router = "/booking";
  const BookingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ListView(
          children: [
              Text("Booking", style: Theme.of(context).textTheme.titleLarge,),
              Center(child: Text("Coming soon"),)
          ],
      ),
    );
  }
}
