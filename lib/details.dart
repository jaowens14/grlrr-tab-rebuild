import 'package:flutter/material.dart';
import 'package:app/drawer.dart';
import 'package:app/appbar.dart';
import 'package:app/routes.dart';
import 'package:go_router/go_router.dart';

class MyDetails extends StatelessWidget {
  /// Constructs a [MyDetails]
  const MyDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      drawer: MyDrawer(),
      body: Center(
        child: ElevatedButton(
          onPressed: () => context.go(controlRoute),
          child: const Text('Go back to the Home screen'),
        ),
      ),
    );
  }
}
