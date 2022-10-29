import "package:flutter/material.dart";
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RatingBarWidget extends StatefulWidget {
  double? size;
  Function(double)? init;
  Function(double) onRated;
  RatingBarWidget({Key? key, required this.onRated, this.size, this.init})
      : super(key: key);

  @override
  State<RatingBarWidget> createState() => RatingBarStateWidget();
}

class RatingBarStateWidget extends State<RatingBarWidget> {
  double ratingBarValue = 3;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.init != null) {
      widget.init!(ratingBarValue);
    }

    // Future.delayed(
    //   Duration.zero,
    //   widget.onRated(ratingBarValue),
    // );
  }

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
