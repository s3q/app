import "package:flutter/material.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingBarWidget extends StatefulWidget {
  double? size;
  Function onRated;
  RatingBarWidget({Key? key, required this.onRated, this.size})
      : super(key: key);

  @override
  State<RatingBarWidget> createState() => RatingBarStateWidget();
}

class RatingBarStateWidget extends State<RatingBarWidget> {
  double ratingBarValue = 3;
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      onRatingUpdate: (newValue) {
        setState(() {
          ratingBarValue = newValue;
        });
        widget.onRated(newValue);
      },
      itemBuilder: (context, index) => const Icon(
        Icons.star_rounded,
        color: Colors.amber,
      ),
      direction: Axis.horizontal,
      initialRating: ratingBarValue,
      unratedColor: Color(0xFF9E9E9E),
      itemCount: 5,
      itemSize: widget.size ??= 24,
      glowColor: Colors.amber,
    );
  }
}
