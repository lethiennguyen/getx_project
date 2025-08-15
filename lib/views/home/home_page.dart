import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_statemanagement/views/home/home.dart';
import 'package:getx_statemanagement/views/product/list_product_view.dart';

import '../common/app_colors.dart';

class LogoutPage extends StatefulWidget {
  const LogoutPage({Key? key}) : super(key: key);

  @override
  State<LogoutPage> createState() => _LogoutPageState();
}

class _LogoutPageState extends State<LogoutPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    ProductList(), // màn load san phâm
    LogoutScreen(),
    LogoutScreen(),
    LogoutScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff8f5f2),
      body: _pages[_currentIndex],
      bottomNavigationBar: _buildCustomBottomNavBar(),
    );
  }

  Widget _buildCustomBottomNavBar() {
    return Stack(
      alignment: Alignment.center,
      children: [
        BottomAppBar(
          height: 70,
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                NavItem.values.asMap().entries.expand((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final selected = index == _currentIndex;
                  final color = selected ? kBrandOrange : Colors.grey;
                  final navButton = _NavButton(
                    icon: item.iconData,
                    selected: index == _currentIndex,
                    onTap: () => setState(() => _currentIndex = index),
                  );
                  if (index == 1) {
                    return [navButton, SizedBox(width: 50)];
                  } else {
                    return [navButton];
                  }
                }).toList(),
          ),
        ),
        Positioned(
          // nút sang màn thêm san phâm
          top: 10,
          child: GestureDetector(
            onTap: () => {Get.toNamed('/add_product')},
            child: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kBrandOrange,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.add, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 3,
              width: selected ? 30 : 0,
              decoration: BoxDecoration(
                color: selected ? kBrandOrange : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 6),
            // Icon
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: selected ? kBrandOrange : Colors.grey,
                size: selected ? 26 : 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum NavItem {
  home(Icons.home_outlined, '/'),
  search(Icons.search_outlined, '/search'),
  favorites(Icons.notifications, '/favorites'),
  profile(Icons.person_outline, '/profile');

  const NavItem(this.iconData, this.route);
  final IconData iconData;
  final String route;

  Icon icon(ColorScheme scheme, {bool selected = false}) =>
      Icon(iconData, color: selected ? kBrandOrange : scheme.onSurfaceVariant);
}
