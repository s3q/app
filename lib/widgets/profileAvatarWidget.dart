import 'package:flutter/material.dart';

class ProfileAvatarWidget extends StatelessWidget {
  String? profileImagePath;
  int? profileColor;
  double size;
  ProfileAvatarWidget(
      {super.key, required this.profileColor, required this.profileImagePath, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: profileImagePath == null
          ? Icon(
            Icons.person,
            size: 30,
          )
          : null,
      backgroundImage:
          profileImagePath != null ? NetworkImage(profileImagePath!) : null,
      backgroundColor: Color(profileColor ?? 0xFFFFE082),
      radius: size,
    );
  }
}
