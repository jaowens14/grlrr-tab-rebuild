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
      //bottomNavigationBar: MyBottomNavigationBar(),
      body: Consumer<WebSocketService>(
        builder: (context, websocketService, child) {
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 80,
                minWidth: MediaQuery.of(context).size.width,
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.red,
                            ),
                            onPressed: () {
                              context.read<WebSocketService>().connect();
                            },
                            child: const Text('connect to server'),
                          ),

                          Text(
                            "Connected: ${websocketService.isConnected.toString()}",
                            style: const TextStyle(color: Colors.white),
                          ),

                          Text(
                            "Message: ${websocketService.rxMsg}",
                            style: const TextStyle(color: Colors.white),
                          ),

                          Text(" "),
                          // Add TextField and Send Button

                          TextField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: 'Speed',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.black,
                            ),
                            onPressed: () {
                              if (_controller.text.isNotEmpty) {
                                context
                                    .read<WebSocketService>()
                                    .setProcessParameter(
                                        "process_speed", _controller.text);
                                _controller.clear(); // Clear the text field
                              }
                            },
                            child: const Text('Set process speed'),
                          ),

                          SizedBox(
                            width: 150,
                            height: 150,
                            child: MaterialButton(
                              onPressed: () {
                                context.read<WebSocketService>().startProcess();
                              },
                              color: Colors.green,
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                              shape: const CircleBorder(),
                              child: const Text(
                                "START",
                              ),
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
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(), color: Colors.blue),
                            ),
                            Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(), color: Colors.grey),
                                  child: Consumer<WebSocketService>(
                                    builder:
                                        ((context, websocketService, child) {
                                      return SfLinearGauge(
                                        tickPosition:
                                            LinearElementPosition.outside,
                                        labelPosition:
                                            LinearLabelPosition.outside,
                                        barPointers: [
                                          LinearBarPointer(
                                              color: Colors.white,
                                              value: websocketService
                                                      .rxJson['ut'] ??
                                                  0.0)
                                        ],
                                        orientation:
                                            LinearGaugeOrientation.vertical,
                                      );
                                    }),
                                  ),
                                ),
                                SfLinearGauge(
                                  tickPosition: LinearElementPosition.outside,
                                  labelPosition: LinearLabelPosition.outside,
                                  barPointers: [
                                    const LinearBarPointer(
                                        color: Colors.white, value: 10)
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 150,
                            height: 150,
                            child: MaterialButton(
                              onPressed: () {
                                context.read<WebSocketService>().stopProcess();
                              },
                              color: Colors.red,
                              textColor: Colors.white,
                              padding: const EdgeInsets.all(16),
                              shape: const CircleBorder(),
                              child: const Text(
                                "STOP",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
