import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert'; // Import the dart:convert library for JSON parsing

class WebSocketService with ChangeNotifier {
  WebSocketChannel? _channel;

  String _txMsg = '';
  String get txMsg => _txMsg;
  String _rxMsg = '';
  String get rxMsg => _rxMsg;

  Map<String, dynamic> _txJson = {};
  Map<String, dynamic> get txJson => _txJson;
  Map<String, dynamic> _rxJson = {};
  Map<String, dynamic> get rxJson => _rxJson;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  WebSocketService();

  void connect() {
          _isConnected = false;

    try {
      _channel = WebSocketChannel.connect(Uri.parse('ws://grlrr.local:5000'));
      getMessages();
    } catch (e) {
      _isConnected = false;
      notifyListeners();
      print("WebSocket connection error: $e");
    }

    notifyListeners(); // Notify the listeners that connection is established
  }

  void getMessages() {
    _isConnected = true;

    _channel?.stream.listen(
      (_rxJson) {
        // Set to true when message is received (connection confirmed)

        // Parse the JSON data
        try {
          _rxMsg = jsonDecode(_rxJson);
        } catch (e) {
          print("Error parsing JSON: $e");
        }

        notifyListeners();
      },
      onError: (error) {
        print("WebSocket error: $error");
        _isConnected = false;
        notifyListeners();
        reconnect(); // Try to reconnect on error
      },
      onDone: () {
        print("WebSocket connection closed");
        _isConnected = false;
        notifyListeners();
        reconnect(); // Try to reconnect when done
      },
    );
  }

  void startProcess() {
    _txJson = {"process": "start"};
    _sendMessage();
  }

  void stopProcess() {
    _txJson = {"process": "stop"};
    _sendMessage();
  }

  void setProcessParameter(String parameterName, String parameterValue) {
    _txJson = {parameterName: parameterValue};
    _sendMessage();
  }

  void _sendMessage() {
    _txMsg = jsonEncode(_txJson);
    _channel?.sink.add(_txMsg);
    print(_txMsg);
  }

  void reconnect() async {
    _channel?.sink.close();

    print("Attempting to reconnect...");
    await Future.delayed(
        Duration(seconds: 5)); // Optional: Wait before reconnecting
    connect();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
