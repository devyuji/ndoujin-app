import 'package:flutter/material.dart';
import 'package:ndoujin/screen/download_list.dart';

import 'package:ndoujin/screen/explorer.dart';
import 'package:ndoujin/screen/list.dart';
import 'package:ndoujin/screen/setting/index.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _idx = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _idx,
        children: const [
          ExplorerScreen(),
          ListScreen(),
          DownloadScreen(),
          SettingScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _idx,
        onDestinationSelected: (index) {
          FocusScope.of(context).requestFocus(FocusNode());
          setState(() => _idx = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.language),
            label: "Explorer",
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite),
            label: "List",
          ),
          NavigationDestination(
            icon: Icon(Icons.download),
            label: "Download",
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: "Setting",
          )
        ],
      ),
    );
  }
}
