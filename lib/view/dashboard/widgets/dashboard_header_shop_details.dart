import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:groc_pos_app/resources/fonts/app_fonts_names.dart';
import 'package:groc_pos_app/resources/routes/routes_name.dart';

import '../../../models/shop_model.dart';
import '../../../resources/colors/app_colors.dart';
import '../../../utils/utils.dart';
import '../../../view_model/dashboard/dashboard_header_shop_view_model.dart';

class DashboardHeaderShopDetails extends StatefulWidget {
  const DashboardHeaderShopDetails({
    super.key,
  });

  @override
  State<DashboardHeaderShopDetails> createState() =>
      _DashboardHeaderShopDetailsState();
}

class _DashboardHeaderShopDetailsState
    extends State<DashboardHeaderShopDetails> {
  final dashboardHeaderShopViewModel = Get.put(DashboardHeaderShopViewModel());
  int initialLoaded = 0;

  Future<void> mangeShopDetails() async {
    if (dashboardHeaderShopViewModel.shopModel.value.shopId == 'loading' ||
        dashboardHeaderShopViewModel.shopModel.value.shopOwnerName ==
            'loading' ||
        dashboardHeaderShopViewModel.shopModel.value.shopProfileImageUrl ==
            'loading' ||
        dashboardHeaderShopViewModel.shopModel.value.shopName == 'loading' ||
        dashboardHeaderShopViewModel.shopModel.value.shopAddress == 'loading' ||
        dashboardHeaderShopViewModel.shopModel.value.shopOwnerPhone ==
            'loading' ||
        dashboardHeaderShopViewModel.shopModel.value.shopId == 'loading' ||
        dashboardHeaderShopViewModel.shopModel.value == null) {
      AppUtils.errorDialog(context, "Something went wrong",
          'Something went wrong please try again');
      return;
    } else {
      final result = await Get.toNamed(RouteName.shopProfileView, arguments: {
        "shop_profile_data": dashboardHeaderShopViewModel.shopModel.value
      });

      if (result != null) {
        loadData();
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() {
    dashboardHeaderShopViewModel.fetchShopDetails(context);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (dashboardHeaderShopViewModel.shopModel.value.shopId == 'loading' ||
            dashboardHeaderShopViewModel.shopModel.value.shopOwnerName ==
                'loading' ||
            dashboardHeaderShopViewModel.shopModel.value.shopProfileImageUrl ==
                'loading' ||
            dashboardHeaderShopViewModel.shopModel.value.shopName ==
                'loading' ||
            dashboardHeaderShopViewModel.shopModel.value.shopAddress ==
                'loading' ||
            dashboardHeaderShopViewModel.shopModel.value.shopOwnerPhone ==
                'loading' ||
            dashboardHeaderShopViewModel.shopModel.value.shopId == 'loading') {
          return Container(
            padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
            height: 180,
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              gradient: LinearGradient(
                colors: [
                  CustomAppColors.mainThemeColorBlueLogo,
                  Color(0xff5089e4),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CircularProgressIndicator(
                  color: Colors.white,
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Loading Data !!',
                  style: GoogleFonts.getFont(
                    AppFontsNames.kBodyFont,
                    textStyle: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: .5,
                    ),
                  ),
                ),
              ],
            )),
          );
        } else {
          return InkWell(
            onTap: mangeShopDetails,
            child: Container(
              padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
              height: 180,
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
                gradient: LinearGradient(
                  colors: [
                    CustomAppColors.mainThemeColorBlueLogo,
                    Color(0xff5089e4),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            dashboardHeaderShopViewModel
                                .shopModel.value.shopProfileImageUrl),
                        backgroundColor: Colors.blueAccent,
                        radius: 40,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Column(
                      children: [
                        SizedBox(
                          width: 250.0,
                          child: Text(
                            'Shop Name: ${dashboardHeaderShopViewModel.shopModel.value.shopName}',
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: GoogleFonts.getFont(
                              AppFontsNames.kBodyFont,
                              textStyle: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: 250.0,
                          child: Text(
                            'Shop Owner: ${dashboardHeaderShopViewModel.shopModel.value.shopOwnerName}',
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: GoogleFonts.getFont(
                              AppFontsNames.kBodyFont,
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: .5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }
}

/*
return Container(
padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
height: 180,
width: double.infinity,
decoration: const BoxDecoration(
borderRadius: BorderRadius.only(
bottomRight: Radius.circular(20),
bottomLeft: Radius.circular(20)),
gradient: LinearGradient(
colors: [
AppColors.mainThemeColorBlueLogo,
Color(0xff5089e4),
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
),
child: Container(
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
crossAxisAlignment: CrossAxisAlignment.center,
children: [
const CircularProgressIndicator(
color: Colors.white,
),
const SizedBox(
height: 20,
),
Text(
'Loading Data !!',
style: GoogleFonts.getFont(
AppFontsNames.kBodyFont,
textStyle: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
color: Colors.white,
letterSpacing: .5,
),
),
),
],
)),
));
} else {
// debugPrint('URL :${_shopModel!.shopProfileImageUrl}');
return  InkWell(
onTap: mangeShopDetails,
child: Container(
padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
height: 180,
width: double.infinity,
decoration: const BoxDecoration(
borderRadius: BorderRadius.only(
bottomRight: Radius.circular(20),
bottomLeft: Radius.circular(20)),
gradient: LinearGradient(
colors: [
AppColors.mainThemeColorBlueLogo,
Color(0xff5089e4),
],
begin: Alignment.topLeft,
end: Alignment.bottomRight,
),
),
child: Row(
mainAxisAlignment: MainAxisAlignment.start,
crossAxisAlignment: CrossAxisAlignment.center,
children: [
Column(
crossAxisAlignment: CrossAxisAlignment.center,
children: [
CircleAvatar(
backgroundImage: NetworkImage(
dashboardHeaderShopViewModel
    .shopModel.value.shopProfileImageUrl),
backgroundColor: Colors.blueAccent,
radius: 40,
),
],
),
Padding(
padding: EdgeInsets.only(left: 10),
child: Column(
children: [
Text(
'Welcome, ${dashboardHeaderShopViewModel.shopModel.value.shopName}',
style: GoogleFonts.getFont(
AppFontsNames.kBodyFont,
textStyle: const TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
color: Colors.white,
letterSpacing: .5,
),
),
),
const SizedBox(
height: 20,
),
Text(
'Shop Owner: ${dashboardHeaderShopViewModel.shopModel.value.shopOwnerName}',
style: GoogleFonts.getFont(
AppFontsNames.kBodyFont,
textStyle: const TextStyle(
fontSize: 18,
fontWeight: FontWeight.bold,
color: Colors.white,
letterSpacing: .5,
),
),
)
],
),
)
],
),
),
));
}


 */
