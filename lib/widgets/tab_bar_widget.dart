import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';

class TabBarWidget extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;

  const TabBarWidget({required this.selectedIndex, required this.onItemTapped});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.gradientColor2, AppColors.gradientColor1],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border(top: BorderSide(color: AppColors.blackColor, width: 0.1))
      ),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent, // Important to allow gradient to show
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
        currentIndex: selectedIndex,
        onTap: onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Merchant'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My Profile'),
        ],
      ),
    );
  }
}
