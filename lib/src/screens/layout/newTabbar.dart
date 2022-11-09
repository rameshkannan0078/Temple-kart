import 'dart:convert';
import 'package:demo_project/src/global/global.dart';
import 'package:demo_project/src/screens/layout/bookings.dart';
import 'package:demo_project/src/screens/layout/cart.dart';
import 'package:demo_project/src/screens/layout/multihome.dart';
import 'package:demo_project/src/screens/layout/ordersListPage.dart';
import 'package:demo_project/src/screens/layout/profile2.dart';
import 'package:demo_project/src/screens/layout/serviceList.dart';
import 'package:demo_project/src/screens/layout/storeScreen.dart';
import 'package:demo_project/src/share_preference/preferencesKey.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class TabbarScreen extends StatefulWidget {
  //int currentIndex;

  @override
  _TabbarScreenState createState() => _TabbarScreenState();
}

class _TabbarScreenState extends State<TabbarScreen> {
  int _currentIndex = 0;

  List<dynamic> _handlePages = [
    // ServiceListScreen(),
    MultiHome(),
    OrdersList(),
    BookingList(),
    // //HomeScreen(),
    // StoreScreenNew(),
    // CategoriesScreen(),
    // StoreScreen(),
    //StoreNewScreen(),
    // // BookingScreen(),
    // BookingList(),
    // Profile(),
    GetCartScreeen(),
    Profile2(),
  ];

  @override
  void initState() {
    if (preferences!.containsKey("guest user")) {
      print("guest user login");
      setState(() {
        userID = preferences!.getString('guest user')!;
      });
    } else {
      getUserDataFromPrefs();
    }

    super.initState();
  }

  getUserDataFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String? userDataStr =
        preferences.getString(SharedPreferencesKey.LOGGED_IN_USERRDATA);
    Map<String, dynamic> userData = json.decode(userDataStr!);
    print(userData);

    setState(() {
      userID = userData['user_id'];
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _handlePages[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          topLeft: Radius.circular(0),
        ),
        child: BottomNavigationBar(
          selectedIconTheme: IconThemeData(color:Color.fromRGBO(95, 63, 4, 1)),
          selectedItemColor: appColorGreen,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          selectedLabelStyle:
              TextStyle(fontWeight: FontWeight.bold, color: appColorGreen),
          backgroundColor: Colors.white,
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: <BottomNavigationBarItem>[
            _currentIndex == 0
                ? BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/home2.png',
                      height: 25,
                      color: appColorGreen,
                    ),
                    label: "Home")
                : BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/home.png',
                      height: 25,
                    ),
                    label: "Home"),
            _currentIndex == 1
                ? BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/order2.png',
                      height: 25,
                      color: appColorGreen,
                    ),
                    label: "Orders")
                : BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/order.png',
                      height: 25,
                    ),
                    label: "Orders"),
            _currentIndex == 2
                ? BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/bookingtab.png',
                  height: 25,
                  color: appColorGreen,
                ),
                label: "Profile")
                : BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/bookingtab2.png',
                  height: 25,
                ),
                label: "Bookings"),
            _currentIndex == 3
                ? BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/cart1.png',
                      height: 25,
                      color: appColorGreen,
                    ),
                    label: "cart")
                : BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/cart.png',
                      height: 25,
                    ),
                    label: "cart"),
            _currentIndex == 4
                ? BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/profile2.png',
                      height: 25,
                      color: appColorGreen,
                    ),
                    label: "Profile")
                : BottomNavigationBarItem(
                    icon: Image.asset(
                      'assets/images/profile.png',
                      height: 25,
                    ),
                    label: "Profile"),
          ],
        ),
      ),
    );
  }
}
