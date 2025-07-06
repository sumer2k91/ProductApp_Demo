import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';
class TabBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const TabBarWidget({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Merchant'),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'My Profile'),
      ],
      onTap: onItemTapped,
      currentIndex: selectedIndex,
      selectedItemColor: AppColors.primaryColor,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
    );
  }
}
