import 'package:fastfood/fastfood/presentations/screens/more/more_view.dart';
import 'package:fastfood/fastfood/presentations/screens/offer/offer_view.dart';
import 'package:flutter/material.dart';
import 'package:fastfood/fastfood/presentations/screens/Home/bottom_navigation_home.dart';

import '../../../../app_theme.dart';
import '../../../../custom_drawer/drawer_user_controller.dart';
import '../../../../custom_drawer/home_drawer.dart';
import '../../../../feedback_screen.dart';
import '../../../../help_screen.dart';
import '../../../../invite_friend_screen.dart';

class NavigationHome extends StatefulWidget {
  const NavigationHome({super.key});
  static final String routeName = 'navigation_screen';

  @override
  State<NavigationHome> createState() => _NavigationHomeState();
}

class _NavigationHomeState extends State<NavigationHome> {
  Widget? screenView;
  DrawerIndex? drawerIndex;

  @override
  void initState() {
    drawerIndex = DrawerIndex.HOME;
    screenView = BottomHomeScreen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppTheme.white,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            backgroundColor: AppTheme.nearlyWhite,
            body: DrawerUserController(
              screenIndex: drawerIndex,
              drawerWidth: MediaQuery.of(context).size.width * 0.75,
              onDrawerCall: (DrawerIndex drawerIndexdata) {
                changeIndex(drawerIndexdata);
                //callback from drawer for replace screen as user need with passing DrawerIndex(Enum index)
              },
              screenView: screenView,
              //we replace screen view as we need on navigate starting screens like MyHomePage, HelpScreen, FeedbackScreen, etc...
            ),
          ),
        ),
      ),
    );
  }

  void changeIndex(DrawerIndex drawerIndexdata) {
    if (drawerIndex != drawerIndexdata) {
      drawerIndex = drawerIndexdata;
      switch (drawerIndex) {
        case DrawerIndex.HOME:
          setState(() {
            screenView = BottomHomeScreen();
          });
          break;
        case DrawerIndex.Help:
          setState(() {
            screenView = OfferView();
          });
          break;
        case DrawerIndex.FeedBack:
          setState(() {
            screenView = MoreView();
          });
          break;
        case DrawerIndex.Invite:
          setState(() {
            screenView = InviteFriend();
          });
          break;

        default:
          break;
      }
    }
  }
}
