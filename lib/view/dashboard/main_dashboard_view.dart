import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/main.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/notification_services/notification_services.dart';
import 'package:groc_pos_app/view/dashboard/widgets/dashboard_header_shop_details.dart';
import 'package:groc_pos_app/view/dashboard/widgets/grid_feature_tiles_builder.dart';

import '../../resources/colors/app_colors.dart';
import '../../view_model/dashboard/main_dashboard_view_model.dart';

class MainDashboardView extends StatefulWidget {
  const MainDashboardView({super.key});

  @override
  State<MainDashboardView> createState() => _MainDashboardViewState();
}

class _MainDashboardViewState extends State<MainDashboardView> {
  NotificationServices notificationServices = NotificationServices();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notificationServices.requestNotificationPermission();
    notificationServices.forgroundMessage();
    notificationServices.firebaseInit(context);
    notificationServices.setupInteractMessage(context);
    notificationServices.isTokenRefresh();

    notificationServices.getDeviceToken().then((value) {
      debugPrint("My Device Token - ${value}");
    });
  }

  void _performLogout() {
    MainDashBoardViewModel().logoutUser(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: CustomAppColors.mainThemeColorBlueLogo,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                if (localizationFlag) {
                  Locale locale = const Locale('ur', 'PK');
                  Get.updateLocale(locale);
                  localizationFlag = false;
                } else {
                  Locale locale = Locale('en', 'US');
                  Get.updateLocale(locale);
                  localizationFlag = true;
                }
              },
              icon: Icon(Icons.translate),
            ),
            IconButton(
              onPressed: _performLogout,
              icon: const Icon(Icons.logout),
            ),
          ],
          title: Center(
            child: Text(
              'groc_pos_main_dashboard'.tr,
              style: GoogleFonts.getFont(
                AppFontsNames.kBodyFont,
                textStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const DashboardHeaderShopDetails(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'explore_the_features'.tr,
                      style: GoogleFonts.getFont(
                        AppFontsNames.kBodyFont,
                        textStyle: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const GridFeatureTilesBuilder()
            ],
          ),
        ),
      ),
    );
  }
}
