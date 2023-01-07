import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:app/helpers/colorsHelper.dart';
import 'package:app/providers/activityProvider.dart';
import 'package:app/providers/chatProvider.dart';
import 'package:app/providers/settingsProvider.dart';
import 'package:app/providers/userProvider.dart';
import 'package:app/schemas/userSchema.dart';
import 'package:app/screens/ContactOwnerScreen.dart';
import 'package:app/screens/ContactUsScreen.dart';
import 'package:app/screens/VertifyEmailScreen.dart';
import 'package:app/screens/accountCreatedScreen.dart';
import 'package:app/screens/accountDeletedScreen.dart';
import 'package:app/screens/activityCreatedScreen.dart';
import 'package:app/screens/activityDetailsScreen.dart';
import 'package:app/screens/activityStatisticsScreen.dart';
import 'package:app/screens/addActivityScreen.dart';
import 'package:app/screens/changeLanguageScreen.dart';
import 'package:app/screens/deleteAccountScreen.dart';
import 'package:app/screens/editActivityScreen.dart';
import 'package:app/screens/editProfileScreen.dart';
import 'package:app/screens/forgotPasswordScreen.dart';
import 'package:app/screens/getStartedScreen.dart';
import 'package:app/screens/homeScreen.dart';
import 'package:app/screens/mapScreen.dart';
import 'package:app/screens/massagesScreen.dart';
import 'package:app/screens/notificationSceen.dart';
import 'package:app/screens/overViewScreen.dart';
import 'package:app/screens/overviewAddActivityScreen.dart';
import 'package:app/screens/ownerActivitiesScreen.dart';
import 'package:app/screens/pickLocationScreen.dart';
import 'package:app/screens/policyAndPrivacyScreen.dart';
import 'package:app/screens/proAccount/switchToProAccountScreen.dart';
import 'package:app/screens/profileScreen.dart';
import 'package:app/screens/reportActivityScreen.dart';
import 'package:app/screens/searchScreen.dart';
import 'package:app/screens/sendReviewScreen.dart';
import 'package:app/screens/signinPhoneNumberScreen.dart';
import 'package:app/screens/signinScreen.dart';
import 'package:app/screens/supportUsScreen.dart';
import 'package:app/screens/termsAndConditionsScreen.dart';
import 'package:app/screens/updateProfileDataScreen.dart';
import 'package:app/screens/viewReviewsScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localization/localization.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

Future load(BuildContext context) async {
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
//   WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
//   FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

//   FirebaseAppCheck firebaseAppCheck = FirebaseAppCheck.getInstance();
//         firebaseAppCheck.installAppCheckProviderFactory(
//         SafetyNetAppCheckProviderFactory.getInstance());

//   FlutterNativeSplash.remove();

//   load();

//   print(Intl.);
//   print(DateTime.now().millisecondsSinceEpoch);
//   print(DateFormat('MM/dd/yyyy, hh:mm a').format(
//       DateTime.fromMillisecondsSinceEpoch(
//           DateTime.now().millisecondsSinceEpoch)));
  runApp(const MainApp());
  configLoading();
//   runApp(const MainApp());
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // print(context.locale.toString());
    return MultiProvider(providers: [
      ChangeNotifierProvider.value(value: SettingsProvider()),
      ChangeNotifierProvider.value(value: UserProvider()),
      ChangeNotifierProvider.value(value: ChatProvider()),
      ChangeNotifierProvider.value(value: ActivityProvider()),
    ], child: const MApp()

        //   AnimatedSplashScreen(splash: const MaterialApp(
        //         debugShowCheckedModeBanner: false,
        //         home: Scaffold(
        //           body: SafeArea(
        //             child: Center(
        //               child: CircularProgressIndicator(),
        //             ),
        //           ),
        //         ),
        //       ), nextScreen: const MApp(),),
        );
  }
}

class MApp extends StatelessWidget {
  const MApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: settingsProvider.setting["language"],
      child: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, future) => const MMApp(),
      ),
    );

    // return FutureBuilder(
    //     future: Firebase.initializeApp(),
    //     builder: (context, snap) {
    //       if (snap.connectionState == ConnectionState.done) {
    //         return EasyLocalization(
    //           supportedLocales: const [Locale('en'), Locale('ar')],
    //           path:
    //               'assets/translations', // <-- change the path of the translation files
    //           fallbackLocale: settingsProvider.setting["language"],
    //           child: const MMApp(),
    //         );
    //       }

    //   return MaterialApp(
    //     debugShowCheckedModeBanner: false,
    //     home: Scaffold(
    //       body: SafeArea(
    //         child: Center(
    //           child: CircularProgressIndicator(),
    //         ),
    //       ),31
    //     ),
    //   );
    //     });
  }
}

class MMApp extends StatefulWidget {
  const MMApp({Key? key}) : super(key: key);

  @override
  State<MMApp> createState() => _MMAppState();
}

class _MMAppState extends State<MMApp> {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  Map? _fireMessageData;
  double _totalNotifications = 1;

  void NotificationPermission() async {
    try {
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      print(await FirebaseMessaging.instance.getToken());
      assert(userProvider.currentUser != null);

      // 3. On iOS, this helps to take the user permissions

      NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        provisional: false,
        sound: true,
      );

      _messaging.subscribeToTopic(userProvider.currentUser!.Id.toString());

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        await FirebaseMessaging.instance
            .setForegroundNotificationPresentationOptions(
          alert: true, // Required to display a heads up notification
          badge: true,
          sound: true,
        );

        AndroidNotificationChannel channel = AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', //name
          description: 'This channel is used for important notifications.',
          importance: Importance.max,
        );

        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();

        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.createNotificationChannel(channel);

        FirebaseMessaging.onMessage.listen((RemoteMessage m) async {
          /*
        _fireMessageData = {
          "title": m.notification?.title,
          "body": m.notification?.body,
        };
        print("new massage");
        print(_fireMessageData);
        _totalNotifications++;

        showSimpleNotification(
          Text(_fireMessageData?["title"]),
          leading: NotificationBadge(totalNotifications: _totalNotifications),
          subtitle: Text(_fireMessageData?["body"]),
          background: Colors.cyan.shade700,
          duration: Duration(seconds: 2),
        );
        */
          RemoteNotification? notification = m.notification;
          AndroidNotification? androidNotification = m.notification?.android;
          print({
            notification?.title,
            notification?.body,
          });

          await flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification?.title,
            notification?.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: androidNotification?.smallIcon,
              ),
            ),
          );
        });

        //   Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
        //     print("Handling a background message: ${message.messageId}");
        //   }

        //   FirebaseMessaging.onBackgroundMessage(
        //       _firebaseMessagingBackgroundHandler);

        _messaging.subscribeToTopic("chat");
      } else {
        print('User declined or has not accepted permission');
      }
    } catch (err) {
      print(err);
    }
  }

  checkForInitialMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _fireMessageData = {
        "title": initialMessage.notification?.title,
        "body": initialMessage.notification?.body,
      };
      _totalNotifications++;

      showSimpleNotification(
        Text(_fireMessageData?["title"]),
        // leading: NotificationBadge(totalNotifications: _totalNotifications),
        subtitle: Text(_fireMessageData?["body"]),
        background: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      );
    }
  }

  void doLocationPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
    ].request();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // doLocationPermission();
    NotificationPermission();
  }

  @override
  Widget build(BuildContext context) {
    List p = [
      Color(0xff6200ee), // primary
      Color(0xff03dac6), // secondary
      Color(0xffb00020), // error

      Colors.white, // background
      Colors.black, //onBackground
      Colors.white, // surface
      Colors.black, // onSurface

      const Color(0xff3700b3), // primaryVariant
      const Color(0xff018786), // secondaryVariant
    ];
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: MaterialApp(
        title: 'Flutter Demo', // !
        theme: ThemeData(
          primarySwatch: ColorsHelper.green,
          // colorScheme: const ColorScheme.light(
          //   secondary: Colors.amber,
          // ),

          //   colorScheme: ColorScheme(
          //     brightness: Brightness.light,
          //     primary: ColorsHelper.yellow,
          //     onPrimary: Colors.black,
          //     secondary: Colors.black,
          //     // secondary: ColorsHelper.green,
          //     onSecondary: Colors.black,
          //     error: ColorsHelper.red,
          //     onError: Colors.black,
          //     background: Colors.white,
          //     onBackground: Colors.black38,
          //     surface: Colors.white,
          //     onSurface: Colors.black54,
          //   ),

          colorScheme: ColorScheme(
            brightness: Brightness.light,
            // primary: Colors.black,
            primary: ColorsHelper.yellow,
            onPrimary: Colors.black,
            secondary: Colors.black,
            // secondary: ColorsHelper.green,
            onSecondary: Colors.black,
            error: ColorsHelper.red,
            onError: Colors.black,
            background: Colors.white,
            onBackground: Color(0xEE000000),
            surface: Colors.white,
            onSurface: Color(0xEE000000),
          ),
          backgroundColor: Theme.of(context).hintColor,
          //   textTheme: const TextTheme(
          //     displayLarge: TextStyle(
          //       fontSize: 45,
          //     ),
          //     displayMedium: TextStyle(
          //       fontSize: 35,
          //     ),
          //     displaySmall: TextStyle(
          //       fontSize: 30,
          //     ),
          //     headlineSmall: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Colors.black87,
          //     ),
          //     headlineMedium: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 25,
          //       color: Colors.black87,
          //     ),
          //     headlineLarge: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       color: Colors.black87,
          //     ),
          //     bodyLarge: TextStyle(
          //       fontSize: 22,
          //       color: Color(0xFF424242),
          //     ),
          //     bodyMedium: TextStyle(
          //       fontSize: 16,
          //       color: Color(0xFF424242),
          //     ),
          //     bodySmall: TextStyle(
          //       fontSize: 12,
          //       color: Color(0xFF424242),
          //     ),
          //     titleLarge: TextStyle(
          //       fontSize: 25,
          //       color: Color(0xFF424242), // Colors.gray[800]
          //     ),
          //     titleMedium: TextStyle(
          //       fontWeight: FontWeight.bold,
          //       fontSize: 20,
          //       color: Color(0xFF424242), // Colors.gray[800]
          //     ),
          //     titleSmall: TextStyle(
          //       fontSize: 18,
          //       color: Color(0xFF424242), // Colors.gray[800]
          //     ),
          //   ),

          /*

        buttons: 
        font: 14, 18

        link:
        font: 16, underline

         */
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 34,
            ),
            displayMedium: TextStyle(
              fontSize: 28,
            ),
            displaySmall: TextStyle(
              fontSize: 20,
            ),
            headlineSmall: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Color(0xEE000000),
            ),
            headlineMedium: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Color(0xEE000000),
            ),
            headlineLarge: TextStyle(
              //   fontWeight: FontWeight.bold,
              color: Color(0xEE000000),
            ),
            bodyLarge: TextStyle(
              fontSize: 20,
              color: Colors.black, // Colors.gray[800]
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: Colors.black, // Colors.gray[800]
            ),
            bodySmall: TextStyle(
              fontSize: 14,
              color: Colors.black, // Colors.gray[800]
            ),
            titleLarge: TextStyle(
              fontSize: 20,
              color: Colors.black, // Colors.gray[800]
            ),
            titleMedium: TextStyle(
              //   fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black, // Colors.gray[800]
            ),
            titleSmall: TextStyle(
              fontSize: 14,
              color: Colors.black, // Colors.gray[800]
            ),
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                  elevation: 0,
                  backgroundColor: Colors.white,
                  // foregroundColor: Colors.black, // !!!!!!!!!
                  textStyle: TextStyle(
                    fontSize: 16,
                  ))
              // style: ButtonStyle(
              //   elevation: MaterialStateProperty.all(0),
              //   textStyle: MaterialStateProperty.all(
              //     const TextStyle(
              //       fontSize: 18,
              //     ),

              ),

          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              textStyle: MaterialStateProperty.all(const TextStyle(
                fontSize: 16,
              )),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),
          ),

          outlinedButtonTheme: OutlinedButtonThemeData(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              textStyle: MaterialStateProperty.all(const TextStyle(
                fontSize: 16,
                // fontWeight: FontWeight.bold,
              )),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: const BorderSide(width: 2)),
              ),
            ),
          ),
        ),
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: HomeScreen.router,
        builder: EasyLoading.init(),
        routes: {
          HomeScreen.router: (_) => const HomeScreen(),
          OverviewScreen.router: (_) => const OverviewScreen(),
          GetStartedScreen.router: (_) => const GetStartedScreen(),
          SigninScreen.router: (_) => SigninScreen(),
          PolicyAndPrivacyScreen.router: (_) => const PolicyAndPrivacyScreen(),
          TermsAndConditionsScreen.router: (_) =>
              const TermsAndConditionsScreen(),
              ContactUsScreen.router:(context) => ContactUsScreen(),

          ActivityDetailsScreen.router: (_) => ActivityDetailsScreen(),
          SigninPhoneNumberScreen.router: (context) =>
              SigninPhoneNumberScreen(),
          MassagesScreen.router: (context) => const MassagesScreen(),
          SearchScreen.router: (context) => const SearchScreen(),
          ProfileScreen.router: (context) => const ProfileScreen(),
          EditProfileScreen.router: (context) => const EditProfileScreen(),
          UpdateProfileDataScreen.router: (context) =>
              UpdateProfileDataScreen(),
          SwitchToProAccountScreen.router: (context) =>
              const SwitchToProAccountScreen(),
          AddActivityScreen.router: (context) => const AddActivityScreen(),
          PickLocationSceen.router: (context) => const PickLocationSceen(),
          VertifyEmailScreen.router: (context) => const VertifyEmailScreen(),
          DeleteAccountScreen.router: (context) => const DeleteAccountScreen(),
          SendReviewScreen.router: (context) => SendReviewScreen(),
          ViewReviewScreen.router: (context) => ViewReviewScreen(),
          ContactOwnerScreen.router: (context) => ContactOwnerScreen(),
          ReportActivityScreen.router: (context) => ReportActivityScreen(),
          MapScreen.router: (context) => MapScreen(),
          ForgotPasswordScreen.router: (context) => ForgotPasswordScreen(),
          OwnerActivitesScreen.router: (context) => OwnerActivitesScreen(),
          ActivityStatisticsScreen.router: (context) =>
              ActivityStatisticsScreen(),
          EditActivityScreen.router: (context) => EditActivityScreen(),
          ChangeLanguageScreen.router: (context) =>
              const ChangeLanguageScreen(),
          AccountCreatedScreen.router: (context) =>
              const AccountCreatedScreen(),
          AccountDeletedScreen.router: (context) =>
              const AccountDeletedScreen(),
          ActivityCreatedScreen.router: (context) =>
              const ActivityCreatedScreen(),
          NotificationScreen.router: (context) => NotificationScreen(),
          SupportUsScreen.router: (context) => const SupportUsScreen(),
          OverViewAddActivityScreen.router: (context) =>
              const OverViewAddActivityScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
