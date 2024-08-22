import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app/websocket.dart';

import 'package:app/control.dart';

import 'package:app/routes.dart';
import 'package:app/details.dart';

void main() {
  runApp(const MyApp());
}

GoRouter router() {
  return GoRouter(
    initialLocation: controlRoute,
    routes: [
      GoRoute(
        path: controlRoute,
        builder: (context, state) => const MyControl(),
      ),
      GoRoute(
        path: detailsRoute,
        builder: (context, state) => MyDetails(),
      ),
    ],
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<WebSocketService>(
          create: (_) => WebSocketService(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Provider Demo',
        routerConfig: router(),
        theme: ThemeData.dark(),
      ),
    );
  }
}
