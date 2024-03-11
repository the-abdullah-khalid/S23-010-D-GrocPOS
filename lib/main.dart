//our coding starts from here
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:groc_pos_app/resources/localization/Languages.dart';
import 'package:groc_pos_app/resources/routes/routes.dart';
import 'package:groc_pos_app/resources/routes/unkown_route.dart';
import 'package:groc_pos_app/resources/theme/app_theme_data.dart';
import 'package:torch_controller/torch_controller.dart';
import 'firebase_options.dart';
import 'view/checkout/checkout_functionalities_implementations/live_feed_object_detection/helper_widgets/model_unpacking/live_screen_parms.dart';

/// get list of all cameras in our device
late List<CameraDescription> CAMERAS_LIST_OF_DEVICE;

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint("vm-entry-point   - ${message.notification!.title.toString()}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// getting the list of cameras in the mobile device
  CAMERAS_LIST_OF_DEVICE = await availableCameras();
  debugPrint("LIST OF ALL CAMERAS are ${CAMERAS_LIST_OF_DEVICE}");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //our top level function to handle close app notifications
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

bool localizationFlag = true;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenParams.screenSize = MediaQuery.sizeOf(context);

    return GetMaterialApp(
      title: 'GROC-POS-App',
      translations: Languages(),
      fallbackLocale: const Locale('en', 'US'),
      locale: const Locale('en', 'US'),
      theme: AppThemeData.appThemeData,
      unknownRoute:
          GetPage(name: '/notfound', page: () => const UnknownRoute()),
      getPages: AppRoutes.appRoutes(),
    );
  }
}
