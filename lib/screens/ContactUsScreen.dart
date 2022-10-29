
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsScreen extends StatelessWidget {
  static String router = "contact_us";
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeScreen(
        padding: 0,
        child: Column(children: [
          AppBarWidget(title: "Contact Us"),
          Expanded(
            child: ListView(children: [
              SizedBox(
                height: 30,
              ),
              Text("Follow Us"),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                      style: IconButton.styleFrom(backgroundColor: Colors.pink),
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.instagram)),
                  IconButton(
                      style: IconButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.facebook)),
                  IconButton(
                      style: IconButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () {},
                      icon: Icon(FontAwesomeIcons.twitter)),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                onTap: () {},
                title: Text("Customers service"),
                trailing: Icon(FontAwesomeIcons.whatsapp),
              ),
              ListTile(
                onTap: () {},
                title: Text("Technical support"),
                trailing: Icon(FontAwesomeIcons.whatsapp),
              ),
              ListTile(
                onTap: () {},
                title: Text("Complaints and suggeestions"),
                trailing: Icon(FontAwesomeIcons.whatsapp),
              )
            ]),
          )
        ]));
  }
}
