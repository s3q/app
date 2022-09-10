import 'package:flutter/material.dart';

class ListTitleWidget extends StatelessWidget {
  String title;
  IconData icon;
  Function() onTap;
  ListTitleWidget(
      {super.key,
      required this.title,
      required this.icon,
      required this.onTap});

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
        
            splashColor: Colors.white12,
            child: ListTile(
                onTap: onTap,
              title: Text(
                title,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              leading: Icon(
                icon,
                color: Colors.black,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black,
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
