import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:binary_data/binary_data_lib.dart';
import 'package:device_emulators/channels/transport_channel_client.dart';

/// Клиент серверного сокета
class TcpServerClient extends TransportChannelClient {
  /// Сокет клиента
  final Socket socket;

  /// Контроллирует поток бинарных данных
  final StreamController<Uint8List> controller = StreamController<Uint8List>();

  /// Для чтения из бинарного потока данных
  @override
  BinaryStreamReader get streamReader => BinaryStreamReader(controller.stream);

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
  String toString() {
    return "${socket.address}";
  }

  /// Отправляет один байт
  @override
  void sendByte(int byte) {
    socket.add([byte]);
  }

  /// Отправляет список байт
  @override
  void sendList(Uint8List data) {
    socket.add(data);
  }
}
