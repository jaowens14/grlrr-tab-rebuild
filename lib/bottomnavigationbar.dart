import 'package:flutter/material.dart';

class MyBottomNavigationBar extends StatelessWidget
    implements PreferredSizeWidget {
  const MyBottomNavigationBar({super.key});

  @override
  Size get preferredSize => AppBar().preferredSize;
  final int _selectedIndex = 0; //New

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.stop), label: "stop"),
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "home")
      ],
      currentIndex: _selectedIndex, //New
      onTap: _onItemTapped,
    );
  }
}

void _onItemTapped(int index) {
  print(index);
}
