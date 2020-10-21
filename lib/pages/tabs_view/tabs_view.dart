import 'package:aue/pages/tabs_view/announcements/announcements_tab.dart';
import 'package:aue/pages/tabs_view/chat/chat_tab.dart';
import 'package:aue/pages/tabs_view/contacts/contacts_tab.dart';
import 'package:aue/pages/tabs_view/courses/courses_list_tab.dart';
import 'package:aue/pages/tabs_view/dashboard/dashboard_tab.dart';
import 'package:aue/pages/tabs_view/services/services_tab.dart';
import 'package:aue/pages/tabs_view/support/support_tab.dart';
import 'package:aue/widgets/custom_page_view.dart';
import 'package:flutter/material.dart';
import 'package:aue/res/res.dart';
import 'package:aue/res/screen_size_utils.dart';

class TabsView extends StatefulWidget {
  @override
  _TabsViewState createState() => _TabsViewState();
}

class _TabsViewState extends State<TabsView> {
  CustomPageController pageController;
  int currentIndex = 0;

  @override
  void initState() {
    pageController = CustomPageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          currentIndex = index;
          setState(() {});
        },
        children: [
          DashBoardTab(),
          CoursesListTab(),
          AnnouncementsTab(),
          ServicesTab(),
          SupportTab()
          // ContactsTab(),
          // ChatTab(),
        ],
      ),
      floatingActionButton: Transform.translate(
        offset: Offset(0, 12),
        child: FloatingActionButton(
          onPressed: () => onItemTap(2),
          backgroundColor: AppColors.primary,
          child: Stack(
            children: [
              for (var i = 0; i < 5; i++)
                ImageIcon(
                  AssetImage(Images.announcements),
                  color: Colors.white,
                )
            ],
          ),
          elevation: 0,
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: NavigationBarItem(
                onTap: () => onItemTap(0),
                text: "Dashboard",
                icon: Images.dashboard,
                selected: currentIndex == 0,
              ),
            ),
            Expanded(
              child: NavigationBarItem(
                onTap: () => onItemTap(1),
                text: "Courses",
                icon: Images.courses,
                selected: currentIndex == 1,
              ),
            ),
            Expanded(child: new Text('')),
            Expanded(
              child: NavigationBarItem(
                onTap: () => onItemTap(3),
                text: "Services",
                icon: Images.services,
                selected: currentIndex == 3,
              ),
            ),
            Expanded(
              child: NavigationBarItem(
                onTap: () => onItemTap(4),
                text: "Support",
                icon: Images.chat,
                selected: currentIndex == 4,
              ),
            ),
            // Expanded(
            //   child: NavigationBarItem(
            //     onTap: () => onItemTap(4),
            //     text: "Chat",
            //     icon: Images.chat,
            //     selected: currentIndex == 4,
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  onItemTap(int index) {
    currentIndex = index;
    pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.linearToEaseOut,
    );
    setState(() {});
  }
}

class NavigationBarItem extends StatelessWidget {
  final String text;
  final String icon;
  final bool selected;
  final VoidCallback onTap;
  const NavigationBarItem({
    Key key,
    @required this.text,
    @required this.icon,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 12),
          ImageIcon(
            AssetImage(icon),
            color: selected ? AppColors.primary : Colors.black54,
            size: DS.setSP(20),
          ),
          SizedBox(height: 8),
          Text(
            text,
            style: TextStyle(
              color: selected ? AppColors.primary : Colors.black54,
              fontWeight: FontWeight.w600,
              fontSize: DS.setSP(12.5),
            ),
          ),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
