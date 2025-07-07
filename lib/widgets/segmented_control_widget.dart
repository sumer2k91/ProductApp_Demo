import 'package:flutter/material.dart';
import 'package:ProductDemoApp/global.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SegmentedControlScreen(),
    );
  }
}

class SegmentedControlScreen extends StatefulWidget {
  const SegmentedControlScreen({super.key});

  @override
  _SegmentedControlScreenState createState() => _SegmentedControlScreenState();
}

class _SegmentedControlScreenState extends State<SegmentedControlScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // ✅ Allows content behind the AppBar
      appBar: CustomAppBar(title: 'My Profile', borderRadius: 20.0), // ✅ Added CustomAppBar

      body: Stack(
        children: [
          // ✅ Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.backGroundColor,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(height: CustomAppBar().height + 20), //AppBar space
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: AppColors.primaryColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(4),
                  child: ToggleButtons(
                    borderRadius: BorderRadius.circular(30),
                    selectedBorderColor: Colors.transparent,
                    fillColor: AppColors.primaryColor,
                    color: AppColors.gradientColor1,
                    selectedColor: AppColors.whiteColor,
                    borderWidth: 1,
                    constraints: BoxConstraints(minWidth: 140, minHeight: 50),
                    isSelected: [selectedIndex == 0, selectedIndex == 1],
                    onPressed: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    children: [
                      buildSegment(Icons.add, "Add Merchant", selectedIndex == 0),
                      buildSegment(Icons.people, "Merchants", selectedIndex == 1),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),

              // ✅ Scrollable Area
              Expanded(
                child: AnimatedSwitcher(
                  duration: Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  child: selectedIndex == 0
                      ? KeyedSubtree(
                    key: ValueKey(0),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Add Merchant Screen",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  )
                      : KeyedSubtree(
                    key: ValueKey(1),
                    child: MerchantListScreen(), // ✅ Wrapped in KeyedSubtree
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSegment(IconData icon, String text, bool isSelected) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isSelected ? AppColors.whiteColor : AppColors.primaryColor),
          SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// ✅ Merchant List Screen (Scrollable)
class MerchantListScreen extends StatelessWidget {
  final List<Map<String, String>> merchants = [
    {
      "name": "Sumztest1",
      "shopName": "Sumz Mart",
      "address": "Office no.306 RB Mehta Marg Ghatkopar, East Mumbai, Maharashtra, 400077",
      "phone": "+91 9321656949"
    },
    {
      "name": "Neha Jain",
      "shopName": "Neha's Fashion",
      "address": "Mumbai 400066",
      "phone": "+91 9820890153"
    },
    {
      "name": "Sumer Kamble",
      "shopName": "Kamble Stores",
      "address": "Mumbai",
      "phone": "+91 9820890153"
    },
    {
      "name": "Diptesh D",
      "shopName": "Diptesh Electronics",
      "address": "",
      "phone": "+91 8348296083"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(12),
      itemCount: merchants.length,
      itemBuilder: (context, index) {
        final merchant = merchants[index];

        return MerchantCard(
          name: merchant["name"]!,
          shopName: merchant["shopName"]!,
          address: merchant["address"]!,
          phone: merchant["phone"]!,
        );
      },
    );
  }
}

// ✅ Merchant Card UI (Unchanged)
class MerchantCard extends StatelessWidget {
  final String name;
  final String shopName;
  final String address;
  final String phone;

  MerchantCard({
    required this.name,
    required this.shopName,
    required this.address,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.store, color: Colors.orange, size: 22),
                SizedBox(width: 8),
                Text(
                  shopName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.person, color: Colors.blueGrey, size: 20),
                SizedBox(width: 8),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.location_on, color: Colors.red, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    address.isNotEmpty ? address : "No Address Available",
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Divider(color: Colors.grey.shade300),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    print("Open Google Maps for $name");
                  },
                  icon: Icon(Icons.map, color: Colors.white),
                  label: Text("Google Map"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    print("Calling $phone");
                  },
                  icon: Icon(Icons.phone, color: Colors.white),
                  label: Text(phone),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
