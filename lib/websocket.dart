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
    _channel = WebSocketChannel.connect(Uri.parse('ws://192.168.1.71:5000'));
    getMessages();
  }

  void getMessages() {
    _channel?.stream.listen(
      (data) {
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
        _reconnect();
      },
      onDone: () {
        print("WebSocket connection closed");
        _isConnected = false;
        notifyListeners();
        _reconnect();
      },
    );
  }

  void sendMessage(String message) {
    if (_channel != null) {
      print("Sent message: $message");
      _channel?.sink.add(message);
      notifyListeners();
    } else {
      print("WebSocket is not connected.");
    }
  }

  void _reconnect() async {
    await _connect();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }
}
