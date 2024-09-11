import 'package:flutter/material.dart';
import 'package:app/drawer.dart';
import 'package:app/appbar.dart';
import 'package:app/websocket.dart';
import 'package:provider/provider.dart';

import 'package:syncfusion_flutter_gauges/gauges.dart';

class MyControl extends StatefulWidget {
  const MyControl({super.key});

  @override
  State<MyControl> createState() => _MyControlPageState();
}

class _MyControlPageState extends State<MyControl> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(),
      drawer: MyDrawer(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Consumer<WebSocketService>(
                  builder: (context, websocketService, child) {
                    return Text(
                      "Connected: ${websocketService.isConnected.toString()}",
                      style: TextStyle(color: Colors.white),
                    );
                  },
                ),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: MaterialButton(
                    onPressed: () {
                      context.read<WebSocketService>().sendMessage("0.01");
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                    child: const Text(
                      "START",
                    ),
                  ),
                ),
                //SizedBox(
                //  width: 200,
                //  height: 200,
                //  child: MaterialButton(
                //    onPressed: () {
                //      context.read<WebSocketService>().sendMessage("pause");
                //    },
                //    color: Colors.orange,
                //    textColor: Colors.white,
                //    padding: EdgeInsets.all(16),
                //    shape: CircleBorder(),
                //    child: const Text(
                //      "PAUSE",
                //    ),
                //  ),
                //),
                SizedBox(
                  width: 200,
                  height: 200,
                  child: MaterialButton(
                    onPressed: () {
                      context.read<WebSocketService>().sendMessage("0.00");
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(16),
                    shape: CircleBorder(),
                    child: const Text(
                      "STOP",
                    ),
                  ),
                ),
                // Add TextField and Send Button
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: 'Speed',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            context
                                .read<WebSocketService>()
                                .sendMessage(_controller.text);
                            _controller.clear(); // Clear the text field
                          }
                        },
                        child: Text('Set speed'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 4)),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(), color: Colors.blue),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(), color: Colors.grey),
                          child: Consumer<WebSocketService>(
                            builder: ((context, websocketService, child) {
                              return SfLinearGauge(
                                tickPosition: LinearElementPosition.outside,
                                labelPosition: LinearLabelPosition.outside,
                                barPointers: [
                                  LinearBarPointer(
                                      color: Colors.white,
                                      value:
                                          websocketService.message['ut'] ?? 0.0)
                                ],
                                orientation: LinearGaugeOrientation.vertical,
                              );
                            }),
                          ),
                        ),
                        SfLinearGauge(
                          tickPosition: LinearElementPosition.outside,
                          labelPosition: LinearLabelPosition.outside,
                          barPointers: [
                            LinearBarPointer(color: Colors.white, value: 10)
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            flex: 2,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    print("hello");
                  },
                  child: Text('STOP'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    print("hello");
                  },
                  child: Text('STOP'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: () {
                    print("hello");
                  },
                  child: Text('STOP'),
                ),
              ],
            ),
          ),
          //Consumer<WebSocketService>(
          //  builder: ((context, value, child) {
          //    return Text(value.message.toString());
          //  }),
          //),
          //Consumer<WebSocketService>(
          //  builder: ((context, value, child) {
          //    return Text(value.isConnected.toString());
          //  }),
          //),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

// Define your custom colors
class CustomColors {
  static const Color surfaceContainerHighest =
      Color(0xFF1F1F1F); // Example color
}

// Extend ThemeData to include custom colors
class CustomThemeData {
  static ThemeData themeData(BuildContext context) {
    final baseTheme =
        ThemeData.light(); // or ThemeData.dark() depending on your app

    return baseTheme.copyWith(
      colorScheme: baseTheme.colorScheme.copyWith(
        // Add custom colors to the color scheme
        surface: CustomColors.surfaceContainerHighest,
      ),
    );
  }
}
