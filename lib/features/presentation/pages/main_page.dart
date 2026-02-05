import 'package:flutter/material.dart';

import 'online_home_page.dart';
import 'library_page.dart';
import 'ranking_page.dart';
import '../widgets/mini_player.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  /// Selected Bottom Nav Index
  int _currentIndex = 0;

  /// Pages
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    _pages = const [
      OnlineHomePage(),
      LibraryPage(),
      RankingPage(),
    ];
  }

  void _onChangeTab(int index) {
    if (_currentIndex == index) return;
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      /// BODY
      body: Stack(
        children: [

          /// PAGE CONTENT
          IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),

          /// MINI PLAYER FLOATING
          const Align(
            alignment: Alignment.bottomCenter,
            child: MiniPlayer(),
          ),
        ],
      ),

      /// BOTTOM NAV
      bottomNavigationBar: NavigationBar(
        height: 70,
        selectedIndex: _currentIndex,
        onDestinationSelected: _onChangeTab,

        destinations: const [

          NavigationDestination(
            icon: Icon(Icons.public_outlined),
            selectedIcon: Icon(Icons.public),
            label: "Online",
          ),

          NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music),
            label: "Musik Saya",
          ),

          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard),
            label: "Peringkat",
          ),
        ],
      ),
    );
  }
}
