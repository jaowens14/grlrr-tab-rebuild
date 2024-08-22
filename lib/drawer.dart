import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:app/routes.dart';

class MyDrawer extends StatelessWidget {
  static const headerTitle = "GR-LRR";

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepOrange,
            ),
            child: Text(headerTitle),
          ),
          ListTile(
            title: Text(controlRoute),
            onTap: () => context.go(controlRoute),
          ),
          ListTile(
            title: Text(detailsRoute),
            onTap: () => context.go(detailsRoute),
          ),
          ListTile(
            title: Text(detailsRoute),
            onTap: () => context.go(detailsRoute),
          ),
        ],
      ),
    );
  }
}
