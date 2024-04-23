import 'package:app/pages/bottom_app_bar_page/account_page.dart';
import 'package:app/pages/bottom_app_bar_page/home_page.dart';
import 'package:app/pages/bottom_app_bar_page/message_page.dart';
import 'package:app/pages/bottom_app_bar_page/settings_page.dart';
import 'package:app/pages/bottom_app_bar_page/upload_post_page.dart';
import 'package:app/themes/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class CommonPage extends StatefulWidget {
  const CommonPage({super.key});

  @override
  State<CommonPage> createState() => _CommonPageState();
}

class _CommonPageState extends State<CommonPage> {

  int _selectedIndex = 0;
  void _navigationBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  final List<Widget> _pages = [
    HomePage(),
    MyMessagePage(),
    UploadPage(),
    MyAccountPage(),
    MySettingsPage(),
  ];
  final user = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context, listen: false).isDarkMode;
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? Theme.of(context).colorScheme.background : Colors.white,
          boxShadow: [BoxShadow(
            color: Colors.black.withOpacity(0.2), // Màu của đổ bóng
            spreadRadius: 2, // Bán kính phân tán của đổ bóng
            blurRadius: 7, // Độ mờ của đổ bóng
            offset: Offset(0, 3), // Độ dịch chuyển của đổ bóng
          ),]
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 18.0),
          child: GNav(
            backgroundColor: isDarkMode ? Theme.of(context).colorScheme.background : Colors.white,
            color: isDarkMode ? Colors.white : Colors.black,
            tabBackgroundColor: isDarkMode ? Theme.of(context).colorScheme.secondary : Colors.grey.shade200,
            gap: 8,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
            onTabChange: _navigationBottomBar,
            activeColor: Colors.blueAccent,
            tabs: const [
              GButton(icon: Icons.home, text: 'Home', iconColor: Color(0xFFCED5EB)),
              GButton(icon: Icons.chat_bubble, text: 'Message', iconColor: Color(0xFFCED5EB)),
              GButton(icon: Icons.add_circle, iconSize: 35, iconColor: Colors.blueAccent,),
              GButton(icon: Icons.person, text: 'Account', iconColor: Color(0xFFCED5EB)),
              GButton(icon: Icons.settings, text: 'Settings', iconColor: Color(0xFFCED5EB)),
            ],
            
          ),
        ),
      ),
    );
  }
}