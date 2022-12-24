import '../../appstructure/broadcast.dart';
import './bottom_navigation_mixin.dart';
import 'package:flutter/material.dart';

typedef TabChangeCallback = void Function(int index);

class PlainBottomNavigation extends StatefulWidget {
  PlainBottomNavigation({
    super.key,
    required this.pages,
    required this.renderTabBar,
    required this.tabBarHeight,
  });

  List<Widget> pages;
  Widget Function(TabChangeCallback onTabChanged, int index) renderTabBar;
  double tabBarHeight;

  static void setCurrentPage(int page) {
    Broadcast.shared.emit(bottomNavigationEventName, {'type': 'setCurrentPage', 'value': page});
  }

  @override
  PlainBottomNavigationState createState() => PlainBottomNavigationState();
}

class PlainBottomNavigationState extends State<PlainBottomNavigation> with BottomNavigationMixin {
  int index = 0;

  void handleTabChange(i) {
    index = i;
    setState(() {});
  }

  @override
  void initState() {
    addBottomNavigationListener(onChangeCurrentPage: (page) {
      index = page;
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    disposeBottomNavigationListener();
  }

  @override
  Widget build(BuildContext context) {
    double tabHeight = widget.tabBarHeight;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: tabHeight),
            child: IndexedStack(
              index: index,
              sizing: StackFit.expand,
              children: [for (var page in widget.pages) page],
            ),
          ),
          Positioned(bottom: 0.0, left: 0.0, right: 0.0, child: widget.renderTabBar(handleTabChange, index)),
        ],
      ),
    );
  }
}
