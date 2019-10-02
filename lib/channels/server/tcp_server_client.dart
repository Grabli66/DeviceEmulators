import 'dart:io';
import 'dart:typed_data';

import 'package:device_emulators/channels/transport_channel_client.dart';

/// Клиент серверного сокета
class TcpServerClient extends TransportChannelClient {
  /// Сокет клиента
  final Socket socket;

  /// Конструктор
  TcpServerClient(this.socket) {
    // Начинает слушать данные сокета
    socket.listen((data) {
      controller.add(data);
    }, onDone: () {
      controller.addError(Exception("Connection closed"));
    }, onError: (Object e) {
      print("Client error: $e");
    });
  }

  @override
  void add(int byte) {
    socket.add([byte]);
  }

  @override
  void addList(Uint8List data) {
    socket.add(data);
  }

  @override
  String toString() {
    return "${socket.address}";
  }
}
