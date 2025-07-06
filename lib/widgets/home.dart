import 'package:ProductDemoApp/widgets/tab_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';
import '../screens/home_screen.dart';
import '../screens/merchant_screen.dart';
import '../screens/profile_screen.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    MerchantScreen(),
    ProfileScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(selectedIndex)),
      bottomNavigationBar: TabBarWidget(
        selectedIndex: selectedIndex,
        onItemTapped: onItemTapped,
      ),
    );
  }
}