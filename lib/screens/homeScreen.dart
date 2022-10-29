import 'package:app/helpers/appHelper.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/settingsProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/screens/bookingScreen.dart';
import 'package:app/screens/chatScreen.dart';
import 'package:app/screens/discoverScreen.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/overViewScreen.dart';
import 'package:app/screens/profileScreen.dart';
import 'package:app/screens/wishlistScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/activityCardWidget.dart';
import 'package:app/widgets/categoryCardWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:badges/badges.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeScreen extends StatefulWidget {
  static String router = "/";
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  int _currentTab = 0;
  PageController _pageController = PageController(initialPage: 0);

  void autoSignin(context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.saveSignInUserData(context, userProvider.credentialUser!,
        sginup: false);
  }

  Future signout(UserProvider userProvider) async {
    await userProvider.signout();

    await Navigator.pushNamedAndRemoveUntil(
        context, OverviewScreen.router, (route) => false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   print("SchedulerBinding");
    //   Future.delayed(Duration(seconds: 1), () => pageController.animateToPage(
    //     _currentTab,
    //     duration: const Duration(milliseconds: 500),
    //     curve: Curves.ease,
    //   ));
    // //   pageController.animateToPage(
    // //     _currentTab,
    // //     duration: const Duration(milliseconds: 500),
    // //     curve: Curves.ease,
    // //   );
    // });
  }

  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    userProvider.credentialUser = auth.currentUser;

    print(auth.currentUser?.emailVerified);

    print(userProvider.credentialUser);
    return Builder(builder: (context) {
      if (userProvider.currentUser == null &&
          userProvider.credentialUser != null) {
        autoSignin(context);
        return SafeScreen(
          child: Center(
              child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () async {
                    await signout(userProvider);
                  },
                  child: Text("sign out"))
            ],
          )),
        );
      }

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: TextButton(
            onPressed: () {},
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.transparent),
            ),
            child: Badge(
              badgeContent: Text('1'),
              badgeColor: ColorsHelper.orange,
              elevation: 1,
              child: const Icon(
                FontAwesomeIcons.bell,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
          title: Text(
            "Oman Trippoint",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, ProfileScreen.router);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.transparent),
              ),
              child: Badge(
                badgeContent: 
                    userProvider.islogin() && auth.currentUser?.emailVerified == true
                        ? null
                        : const Icon(
                            Icons.error_outline_rounded,
                            size: 13,
                            color: Colors.white,
                          )
                    ,
                badgeColor: ColorsHelper.orange,
                elevation: 1,
                child: const Icon(
                  Icons.person,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ],
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          color: Colors.white,
          child: PageView(
            controller: _pageController,
            onPageChanged: (i) {
              FocusScope.of(context).unfocus();
              setState(() {
                _currentTab = i;
              });
            },
            children: const [
              DiscoverScreen(),
              ChatScreen(),
              BookingScreen(),
              WishlistScreen(),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Discover",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded),
              label: "chat",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Booking",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_added_rounded),
              label: "Wishlist",
            ),
          ],
          currentIndex: _currentTab,
          onTap: (int i) {
            setState(() {
              _currentTab = i;
            });

            _pageController.jumpToPage(i);
            // pageController.animateToPage(
            //   i,
            //   duration: const Duration(milliseconds: 500),
            //   curve: Curves.ease,
            // );
          },
          showUnselectedLabels: true,
          selectedFontSize: 15,
          unselectedFontSize: 14,
          backgroundColor: Colors.white,
          unselectedItemColor: Colors.black45,
          selectedItemColor: Colors.black,

          //             showUnselectedLabels: true,
          //   selectedFontSize: 14,
          //   unselectedFontSize: 14,
          //   backgroundColor: Colors.white,
          //   unselectedItemColor: Colors.black54,
          //   selectedItemColor: Color(0xFFE4605E),
        ),
      );
    });
  }
}
