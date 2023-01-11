import 'package:app/helpers/adHelper.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/screens/ContactUsScreen.dart';
import 'package:app/screens/VertifyEmailScreen.dart';
import 'package:app/screens/changeLanguageScreen.dart';
import 'package:app/screens/deleteAccountScreen.dart';
import 'package:app/screens/editProfileScreen.dart';
import 'package:app/screens/forgotPasswordScreen.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/notificationSceen.dart';
import 'package:app/screens/overViewScreen.dart';
import 'package:app/screens/ownerActivitiesScreen.dart';
import 'package:app/screens/policyAndPrivacyScreen.dart';
import 'package:app/screens/proAccount/switchToProAccountScreen.dart';
import 'package:app/screens/supportUsScreen.dart';
import 'package:app/screens/termsAndConditionsScreen.dart';
import 'package:app/widgets/LinkWidget.dart';
import 'package:app/widgets/SafeScreen.dart';
import 'package:app/widgets/appBarWidget.dart';
import 'package:app/widgets/listTitleWidget.dart';
import 'package:app/widgets/profileAvatarWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ProfileScreen extends StatefulWidget {
  static String router = "/profile";
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<int, BannerAd> _bannersAd = {};
  RewardedAd? _rewardedAd;

  Future signout(UserProvider userProvider) async {
    EasyLoading.show(maskType: EasyLoadingMaskType.black);
    await userProvider.signout();

    Navigator.pushNamedAndRemoveUntil(
        context, OverviewScreen.router, (route) => false);

    EasyLoading.dismiss();
  }

  void _creatRewardAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(onAdLoaded: (ad) {
        setState(() {
          _rewardedAd = ad;
        });
      }, onAdFailedToLoad: (err) {
        setState(() {
          _rewardedAd = null;
        });
      }),
    );
  }

  _showRewardedAd() {
    print(_rewardedAd);
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback =
          FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _creatRewardAd();
      }, onAdFailedToShowFullScreenContent: (ad, err) {
        ad.dispose();
        _creatRewardAd();
      });
      _rewardedAd!.show(
        onUserEarnedReward: (ad, reward) {},
      );
      _rewardedAd = null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _creatRewardAd();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannersAd[0] = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();

    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.fullBanner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannersAd[1] = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bannersAd[0]?.dispose();
    _bannersAd[1]?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    final auth = FirebaseAuth.instance;
    bool _isLogin = userProvider.islogin();

    print(auth.currentUser?.emailVerified);
    return SafeScreen(
        padding: 0,
        child: Column(
          children: [
            AppBarWidget(title: "Profile"),
            Expanded(
              child: ListView(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileAvatarWidget(
                              profileColor:
                                  userProvider.currentUser?.profileColor,
                              profileImagePath:
                                  userProvider.currentUser?.profileImagePath,
                            ),

                            // CircleAvatar(
                            //   child: Icon(
                            //     Icons.person,
                            //     size: 50,
                            //   ),
                            //   backgroundColor: Color(
                            //       userProvider.currentUser?.profileColor ??
                            //           0xFFFFE082),
                            //   radius: 40,
                            // ),
                            SizedBox(
                              height: 10,
                            ),
                            _isLogin
                                ? Text(
                                    userProvider.currentUser?.name ?? "",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  )
                                : SizedBox(),
                          ],
                        ),
                        _isLogin
                            ? LinkWidget(
                                text: "Edit profile",
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, EditProfileScreen.router);
                                })
                            : ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, GetStartedScreen.router);
                                },
                                child: const Text("Login")),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  //^---------------------- adverticment -----------------------

                  if (_bannersAd[0] != null)
                    Container(
                      key: Key(Uuid().v4()),
                      width: _bannersAd[0]!.size.width.toDouble(),
                      height: _bannersAd[0]!.size.height.toDouble(),
                      child: AdWidget(ad: _bannersAd[0]!),
                    ),

                  //^----------------------------------------------------------

                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Account Settings",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (_isLogin && auth.currentUser?.emailVerified == false)
                    ListTitleWidget(
                      title: "Verify Email",
                      icon: Icons.verified,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          VertifyEmailScreen.router,
                        );
                      },
                    ),
// if (_isLogin)
//                     ListTitleWidget(
//                       title: "My Activities",
//                       icon: Icons.verified,
//                       onTap: () {
//                         Navigator.pushNamed(
//                           context,
//                           OwnerActivitesScreen.router,
//                         );
//                       },
//                     ),

                  if (_isLogin)
                    (userProvider.currentUser?.isProAccount == false &&
                            userProvider.proCurrentUser == null
                        ? ListTitleWidget(
                            title: "Switch to Professional Account",
                            icon: Icons.local_police_rounded,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SwitchToProAccountScreen.router);
                            },
                          )
                        : ListTitleWidget(
                            title: "Edit Your Professional Account",
                            icon: Icons.local_police_rounded,
                            onTap: () {
                              Navigator.pushNamed(
                                  context, SwitchToProAccountScreen.router);
                            },
                          )),
                  if (_isLogin &&
                      userProvider.currentUser?.providerId == "password")
                    ListTitleWidget(
                      title: "Reset Password",
                      icon: Icons.vpn_key_rounded,
                      onTap: () {
                        Navigator.pushNamed(
                            context, ForgotPasswordScreen.router);
                      },
                    ),
                  ListTitleWidget(
                    title: "support us",
                    icon: Icons.attach_money_rounded,
                    onTap: () {
                      _showRewardedAd();
                      Navigator.pushNamed(context, SupportUsScreen.router);
                    },
                  ),
                  ListTitleWidget(
                    title: "Language",
                    icon: Icons.language,
                    onTap: () {
                      Navigator.pushNamed(context, ChangeLanguageScreen.router);
                    },
                  ),
                  ListTitleWidget(
                    title: "Notification",
                    icon: Icons.notifications_active_outlined,
                    onTap: () {
                      Navigator.pushNamed(context, NotificationScreen.router);
                    },
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  //^---------------------- adverticment -----------------------

                  if (_bannersAd[1] != null)
                    Container(
                      key: Key(Uuid().v4()),
                      width: _bannersAd[1]!.size.width.toDouble(),
                      height: _bannersAd[1]!.size.height.toDouble(),
                      child: AdWidget(ad: _bannersAd[1]!),
                    ),

                  //^----------------------------------------------------------

                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Support",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ListTitleWidget(
                      title: "How Oman Trippoint works",
                      icon: Icons.work_outline_rounded,
                      onTap: () {}),
                  ListTitleWidget(
                      title: "Get Help",
                      icon: Icons.help_outline_rounded,
                      onTap: () {}),
                  ListTitleWidget(
                      title: "Contact us",
                      icon: Icons.contact_support_outlined,
                      onTap: () {
                        Navigator.pushNamed(context, ContactUsScreen.router);
                      }),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Legal",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTitleWidget(
                      title: "Privacy Policy",
                      icon: Icons.help_outline_rounded,
                      onTap: () {
                        Navigator.pushNamed(
                            context, PolicyAndPrivacyScreen.router);
                      }),
                  ListTitleWidget(
                      title: "Terms of Service",
                      icon: Icons.contact_support_outlined,
                      onTap: () {
                        Navigator.pushNamed(
                            context, TermsAndConditionsScreen.router);
                      }),
                  const SizedBox(
                    height: 40,
                  ),
                  if (_isLogin)
                    ListTitleWidget(
                      title: "Delete Account",
                      icon: Icons.delete_forever_rounded,
                      dang: true,
                      onTap: () {
                        Navigator.pushNamed(
                            context, DeleteAccountScreen.router);
                      },
                    ),
                  SizedBox(
                    height: 40,
                  ),
                  if (userProvider.currentUser != null)
                    LinkWidget(
                      text: "Log out",
                      onPressed: () {
                        signout(userProvider);
                      },
                    ),
                ],
              ),
            ),
          ],
        ));
  }
}
