import 'package:app/helpers/appHelper.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/settingsProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/activitySchema.dart';
import 'package:app/screens/activityDetailsScreen.dart';
import 'package:app/screens/bookingScreen.dart';
import 'package:app/screens/chatScreen.dart';
import 'package:app/screens/discoverScreen.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/notificationSceen.dart';
import 'package:app/screens/overViewScreen.dart';
import 'package:app/screens/ownerActivitiesScreen.dart';
import 'package:app/screens/profileScreen.dart';
import 'package:app/screens/wishlistScreen.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/activityCardWidget.dart';
import 'package:app/widgets/categoryCardWidget.dart';
import 'package:app/widgets/loadingWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import "package:flutter/material.dart";
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:badges/badges.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _isLoading = true;
  PageController _pageController = PageController(initialPage: 0);

  void autoSignin(context) async {
    // EasyLoading.show(status: "Loading")
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getBool("first") == null ||
        sharedPreferences.getBool("first") != false) {
      await sharedPreferences.setBool("first", false);
      Navigator.pushNamedAndRemoveUntil(
          context, OverviewScreen.router, (route) => false);
      return;
    }
    if (userProvider.credentialUser != null) {
      await userProvider.saveSignInUserData(
          context, userProvider.credentialUser!,
          sginup: false);
    }
    Future.delayed(Duration(milliseconds: 200), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  Future signout(UserProvider userProvider) async {
    await userProvider.signout();

    Navigator.pushNamedAndRemoveUntil(
        context, OverviewScreen.router, (route) => false);
  }

  Future getNofitication() async {
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);

    await userProvider.fetchNotifications();
  }

  void initDynamicLink() async {
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      if (event.link.path.isNotEmpty) {
        // * link navigator
        linkNavigator(event.link.path);
      }
    }).onError((err) {
      print(err);
    });
  }

  Future linkNavigator(String path) async {
    EasyLoading.show();
    try {
      print(path);
      final activityProvider =
          Provider.of<ActivityProvider>(context, listen: false);

      if (path.startsWith("/post")) {
        ActivitySchema activitySchema =
            await activityProvider.fetchActivityWStore(path.split("/post")[1]);
        Navigator.pushNamed(context, ActivityDetailsScreen.router,
            arguments: activitySchema);
      }
    } catch (err) {
      print(err);
    }

    await Future.delayed(Duration(milliseconds: 1500));
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration(seconds: 5), () {
      //   int index = ModalRoute.of(context)!.settings.arguments as int;
      //   setState(() {
      //     _currentTab = index;
      //   });

      getNofitication();
    });

    initDynamicLink();

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

    //
    return Builder(builder: (context) {
      if ((userProvider.currentUser == null &&
          userProvider.credentialUser != null)) {
        autoSignin(context);
      } else {
        _isLoading = false;
      }

      if (_isLoading) {
        return const LoadingWidget();
      }

      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: TextButton(
            onPressed: () {
              Navigator.pushNamed(context, NotificationScreen.router);
            },
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
                badgeContent: userProvider.islogin() &&
                        auth.currentUser?.emailVerified == true
                    ? null
                    : const Icon(
                        Icons.error_outline_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
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
            children: [
              const DiscoverScreen(),
              const ChatScreen(),
              const BookingScreen(),
              if (userProvider.currentUser != null)
                if (userProvider.currentUser!.isProAccount == true)
                  const OwnerActivitesScreen(),
              const WishlistScreen(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: ColorsHelper.grey,
          onPressed: () async {
            EasyLoading.show();
            String url = await AppHelper.buildDynamicLink(
                title: 'Trippoint Oman || عمان', Id: "app");
            await FlutterShare.share(
              title: 'Trippoint Oman || عمان',
              // text: args.title,
              linkUrl: url,
            );

            EasyLoading.dismiss();
          },
          child: const SizedBox(
            width: 60,
            height: 60,
            child: Icon(
              Icons.share_rounded,
              size: 30,
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: "Discover",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded),
              label: "chat",
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: "Booking",
            ),
            if (userProvider.currentUser != null)
              if (userProvider.currentUser!.isProAccount == true)
                const BottomNavigationBarItem(
                  icon: Icon(Icons.assessment_rounded),
                  label: "Ads",
                ),
            const BottomNavigationBarItem(
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
