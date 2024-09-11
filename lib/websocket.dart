import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'dart:convert'; // Import the dart:convert library for JSON parsing

class WebSocketService with ChangeNotifier {
  WebSocketChannel? _channel;
  Map<String, dynamic> _message = {};
  Map<String, dynamic> get message => _message;

  bool _isConnected = false;
  bool get isConnected => _isConnected;

  WebSocketService() {
    _connect();
  }

  _connect() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse('ws://grlrr.local:5000'));
      _isConnected = true;
      notifyListeners(); // Notify the listeners that connection is established
      getMessages();
    } catch (e) {
      _isConnected = false;
      notifyListeners();
      print("WebSocket connection error: $e");
    }
  }

  void getMessages() {
    _channel?.stream.listen(
      (data) {
        // Set to true when message is received (connection confirmed)
        _isConnected = true;

        // Parse the JSON data
        try {
          _message = jsonDecode(data);
        } catch (e) {
          print("Error parsing JSON: $e");
        }

        notifyListeners();
      },
      onError: (error) {
        print("WebSocket error: $error");
        _isConnected = false;
        notifyListeners();
        _reconnect(); // Try to reconnect on error
      },
      onDone: () {
        print("WebSocket connection closed");
        _isConnected = false;
        notifyListeners();
        _reconnect(); // Try to reconnect when done
      },
    );
  }

  void sendMessage(String message) {
    if (_channel != null) {
      print("Sent message: $message");
      double val = double.parse(message);
      message = jsonEncode({
        "motorSpeed0": val,
        "motorSpeed1": val,
        "motorSpeed2": val,
        "motorSpeed3": val
      });
      _channel?.sink.add(message);
      // No need to call notifyListeners here since it doesn't affect UI state
    } else {
      print("WebSocket is not connected.");
    }
  }

  void _reconnect() async {
    print("Attempting to reconnect...");
    await Future.delayed(Duration(seconds: 5)); // Optional: Wait before reconnecting
    _connect();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
