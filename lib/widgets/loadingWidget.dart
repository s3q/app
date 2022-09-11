import 'package:app/helpers/colorsHelper.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeScreen(
      child: Center(
        child: Container(
            height: 60,
            width: 60,
          child: const LoadingIndicator(
                indicatorType: Indicator.ballPulseSync,
                colors: [Colors.black],
                strokeWidth: 6,
                backgroundColor: Colors.white,
                pathBackgroundColor: Colors.white),
        ),
      ),
    );
    }
}