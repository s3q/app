import 'package:app/helpers/colorsHelper.dart';
import 'package:flutter/material.dart';

class ListTitleWidget extends StatelessWidget {
  String title;
  IconData icon;
  bool dang;
  Function() onTap;
  ListTitleWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap, this.dang = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 10),
        //   child: Divider(
        //     color: Colors.black45,
        //     height: 1,
        //   ),
        // ),
        Material(
          color: Colors.white,
          child: InkWell(
            splashColor: dang ? Color(0x30F44336) : Colors.white12,
            child: ListTile(
              onTap: onTap,
              title: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: dang ? ColorsHelper.red : Colors.black,
                ),
              ),
              leading: Icon(
                icon,
                color: dang ? ColorsHelper.red : Colors.black,
              ),
              trailing:  Icon(
                Icons.arrow_forward_ios_rounded,
                color: dang ? ColorsHelper.red : Colors.black,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Divider(
            color: Colors.black45,
            height: 1,
          ),
        ),
      ],
    );
  }
}
